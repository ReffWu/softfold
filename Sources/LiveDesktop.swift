import MetalKit
import ScreenCaptureKit
import ServiceManagement
import SwiftUI

final class ScreenFrames: NSObject, SCStreamOutput, SCStreamDelegate {
  var renderer: DesktopRenderer?
  var onFailure: ((Error) -> Void)?

  func stream(
    _ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer,
    of type: SCStreamOutputType
  ) {
    guard type == .screen, sampleBuffer.isValid,
      let attachments = CMSampleBufferGetSampleAttachmentsArray(
        sampleBuffer, createIfNecessary: false) as? [[SCStreamFrameInfo: Any]],
      let rawStatus = attachments.first?[.status] as? Int,
      SCFrameStatus(rawValue: rawStatus) == .complete,
      let buffer = CMSampleBufferGetImageBuffer(sampleBuffer)
    else { return }
    renderer?.receive(buffer)
  }

  func stream(_ stream: SCStream, didStopWithError error: Error) { onFailure?(error) }
}

final class DesktopPanel: NSPanel {
  override var canBecomeKey: Bool { false }
  override var canBecomeMain: Bool { false }
}

@MainActor
final class LidReading: ObservableObject {
  @Published fileprivate(set) var degrees: Double?
}

@MainActor
final class LiveDesktop: NSObject, ObservableObject {
  let lid = LidReading()
  @Published private(set) var isActive = false
  @Published private(set) var isFolding = false
  @Published private(set) var isStarting = false
  @Published private(set) var isWaitingForDisplay = false
  @Published private(set) var sensorAvailable = false
  @Published private(set) var openAngle: Double
  nonisolated static let defaultOpenAngle = 95.0
  @Published private(set) var focusesWhenHeld =
    UserDefaults.standard.object(forKey: "focusesWhenHeld") as? Bool ?? true
  @Published private(set) var error: String?
  @Published private(set) var needsPermission = false
  @Published private(set) var isEnabled = UserDefaults.standard.bool(forKey: "effectEnabled")
  private static let missingSensorMessage =
    String(
      localized:
        "This Mac doesn't appear to have a lid angle sensor, so Softfold can't follow the lid.")
  private static let sensorDroppedMessage =
    String(
      localized:
        "The lid sensor stopped responding. Softfold turns back on as soon as it reconnects.")
  private let sensor = LidSensor()
  private var sensorMissing = false
  private let motion: LidMotion
  private var stream: SCStream?
  private var frames: ScreenFrames?
  private var renderer: DesktopRenderer?
  private var overlay: NSWindow?
  private var metalView: MTKView?
  private var displayLink: CADisplayLink?
  private var session = UUID()
  private var observers = [NSObjectProtocol]()
  private var resumeAfterWake = false
  private var restoringAtLaunch = UserDefaults.standard.bool(forKey: "effectEnabled")
  private var wakeTask: Task<Void, Never>?
  private var displayTask: Task<Void, Never>?
  private var captureTask: Task<Void, Never>?
  private var filter: SCContentFilter?
  private var configuration: SCStreamConfiguration?
  private var lastCaptureRecovery = 0.0
  private var capturedDisplayID: CGDirectDisplayID?
  private var excludedWindowIDs = Set<CGWindowID>()

  override init() {
    let savedAngle =
      UserDefaults.standard.object(forKey: "openAngle") as? Double ?? Self.defaultOpenAngle
    let openAngle =
      savedAngle.isFinite && (25...180).contains(savedAngle) ? savedAngle : Self.defaultOpenAngle
    self.openAngle = openAngle
    motion = LidMotion(openAngle: openAngle)
    super.init()
    motion.setFocusesWhenHeld(focusesWhenHeld)
    let motion = motion
    let lid = lid
    var shownDegree: Int?
    sensor.onAngle = { [weak self] angle in
      let degree = angle.map { value in
        shownDegree.flatMap { abs(value - Double($0)) < 0.8 ? $0 : nil } ?? Int(value.rounded())
      }
      if degree != shownDegree {
        shownDegree = degree
        Task { @MainActor in lid.degrees = degree.map(Double.init) }
      }
      let update = motion.receive(angle)
      guard update.availabilityChanged || update.beganClosing else { return }
      Task { @MainActor [weak self] in
        guard let self else { return }
        if update.availabilityChanged {
          self.sensorAvailable = update.available
          if update.available, self.sensorMissing {
            self.sensorMissing = false
            if self.error == Self.missingSensorMessage { self.error = nil }
          }
          if !update.available, self.isActive || self.isStarting {
            self.stop()
            self.error = Self.sensorDroppedMessage
          }
        }
        if update.beganClosing { self.beginRendering() }
        if update.available, self.isEnabled, !self.isActive, !self.isStarting,
          !self.resumeAfterWake
        {
          let restoring = self.restoringAtLaunch
          self.restoringAtLaunch = false
          await self.start(promptForPermission: !restoring)
        }
      }
    }
    sensor.onMissing = { [weak self] in
      Task { @MainActor [weak self] in
        guard let self, !self.sensorAvailable else { return }
        self.sensorMissing = true
        if self.error == nil { self.error = Self.missingSensorMessage }
      }
    }
    sensor.start()
    let center = NSWorkspace.shared.notificationCenter
    for name in [NSWorkspace.willSleepNotification, NSWorkspace.screensDidSleepNotification] {
      observers.append(
        center.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
          Task { @MainActor in self?.suspendForSleep() }
        })
    }
    for name in [NSWorkspace.didWakeNotification, NSWorkspace.screensDidWakeNotification] {
      observers.append(
        center.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
          Task { @MainActor in self?.resumeFromSleep() }
        })
    }
    observers.append(
      center.addObserver(
        forName: NSWorkspace.activeSpaceDidChangeNotification, object: nil, queue: .main
      ) { [weak self] _ in
        Task { @MainActor in self?.refreshSpace() }
      })
    observers.append(
      NotificationCenter.default.addObserver(
        forName: NSApplication.didChangeScreenParametersNotification, object: nil, queue: .main
      ) { [weak self] _ in
        Task { @MainActor in self?.refreshDisplay() }
      })
    observers.append(
      NotificationCenter.default.addObserver(
        forName: NSWindow.didBecomeKeyNotification, object: nil, queue: .main
      ) { [weak self] _ in
        Task { @MainActor in await self?.refreshExcludedWindows() }
      })
  }

  func setEnabled(_ enabled: Bool) {
    isEnabled = enabled
    restoringAtLaunch = false
    UserDefaults.standard.set(enabled, forKey: "effectEnabled")
    if enabled { setUpOnFirstEnable() }
    if enabled { Task { await start() } } else { stop() }
  }

  private func setUpOnFirstEnable() {
    guard !UserDefaults.standard.bool(forKey: "setUpOnFirstEnable") else { return }
    UserDefaults.standard.set(true, forKey: "setUpOnFirstEnable")
    try? SMAppService.mainApp.register()
    if let angle = lid.degrees, (80...140).contains(angle) { setOpenPosition() }
  }

  func setFocusesWhenHeld(_ value: Bool) {
    focusesWhenHeld = value
    UserDefaults.standard.set(value, forKey: "focusesWhenHeld")
    motion.setFocusesWhenHeld(value)
    beginRendering()
  }

  var isDefaultOpenAngle: Bool { abs(openAngle - Self.defaultOpenAngle) < 0.5 }

  func restoreDefaultOpenPosition() {
    motion.setBaseline(Self.defaultOpenAngle)
    openAngle = Self.defaultOpenAngle
    UserDefaults.standard.removeObject(forKey: "openAngle")
    error = nil
    displayLink?.isPaused = true
    metalView?.draw()
  }

  func setOpenPosition() {
    guard let angle = motion.calibrate() else {
      error = String(localized: "Open the lid to your comfortable viewing position first.")
      return
    }
    openAngle = angle
    UserDefaults.standard.set(angle, forKey: "openAngle")
    error = nil
    displayLink?.isPaused = true
    metalView?.draw()
  }

  func start(promptForPermission: Bool = true) async {
    guard !isStarting, !isActive else { return }
    error = nil
    needsPermission = false
    guard sensorAvailable else {
      sensor.reconnect()
      if sensorMissing { error = Self.missingSensorMessage }
      return
    }
    let hasScreenAccess =
      CGPreflightScreenCaptureAccess() || (promptForPermission && CGRequestScreenCaptureAccess())
    guard hasScreenAccess else {
      needsPermission = true
      error = String(
        localized: "Allow Softfold in Screen Recording settings, then quit and reopen it.")
      return
    }
    guard builtInScreenAvailable else {
      isWaitingForDisplay = true
      return
    }
    isWaitingForDisplay = false
    isStarting = true
    sensor.setTracking(true)
    let session = UUID()
    self.session = session
    do {
      let renderer = try DesktopRenderer(resources: .main, motion: motion)
      let content = try await SCShareableContent.excludingDesktopWindows(
        false, onScreenWindowsOnly: false)
      guard self.session == session else { return }
      guard let display = content.displays.first(where: { CGDisplayIsBuiltin($0.displayID) != 0 }),
        let screen = NSScreen.screens.first(where: {
          ($0.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.uint32Value
            == display.displayID
        })
      else {
        stop()
        isWaitingForDisplay = true
        return
      }
      let area = screen.frame
      makeOverlay(screen: screen, area: area, renderer: renderer)
      let withOverlay = try await SCShareableContent.excludingDesktopWindows(
        false, onScreenWindowsOnly: false)
      guard self.session == session else { return }
      let hidden = excludedWindows(in: withOverlay)
      guard hidden.contains(where: { $0.windowID == CGWindowID(overlay?.windowNumber ?? 0) })
      else {
        throw DesktopError.message(String(localized: "Could not prepare the desktop renderer."))
      }
      let filter = SCContentFilter(display: display, excludingWindows: hidden)
      capturedDisplayID = display.displayID
      excludedWindowIDs = Set(hidden.map(\.windowID))
      let configuration = SCStreamConfiguration()
      configuration.sourceRect = CGRect(
        x: area.minX - screen.frame.minX, y: screen.frame.maxY - area.maxY, width: area.width,
        height: area.height)
      let scale = min(screen.backingScaleFactor, 2400 / area.width)
      configuration.width = Int(area.width * scale) / 2 * 2
      configuration.height = Int(area.height * scale) / 2 * 2
      configuration.minimumFrameInterval = CMTime(value: 1, timescale: 60)
      configuration.queueDepth = 3
      configuration.pixelFormat = kCVPixelFormatType_32BGRA
      configuration.showsCursor = false
      configuration.capturesAudio = false
      configuration.colorSpaceName = CGColorSpace.sRGB
      try await renderer.warmUp(width: configuration.width, height: configuration.height)
      guard self.session == session else { return }
      self.renderer = renderer
      self.filter = filter
      self.configuration = configuration
      let stream = try makeStream(
        filter: filter, configuration: configuration, renderer: renderer, session: session)
      renderer.onPresentation = { [weak self] failure in
        guard let self, self.session == session else { return }
        if let failure {
          self.stop()
          self.error = String(
            localized: "The desktop renderer stopped: \(failure.localizedDescription)")
        }
      }
      renderer.onRest = { [weak self] in self?.restOverlay() }
      try await stream.startCapture()
      guard self.session == session else {
        try? await stream.stopCapture()
        return
      }
      let deadline = CACurrentMediaTime() + 5
      while !renderer.hasFrame {
        guard self.session == session else { return }
        guard CACurrentMediaTime() < deadline else {
          needsPermission = true
          throw DesktopError.message(
            String(
              localized:
                "No desktop frames arrived. Check Screen Recording permission and reopen Softfold.")
          )
        }
        try await Task.sleep(for: .milliseconds(10))
      }
      guard self.session == session else { return }
      guard sensorAvailable else { throw DesktopError.message(Self.sensorDroppedMessage) }
      motion.setEnabled(true)
      isActive = true
      isStarting = false
      if motion.isClosing { beginRendering() } else { pauseCapture() }
    } catch {
      guard self.session == session else { return }
      stop()
      if builtInScreenAvailable {
        self.error = error.localizedDescription
      } else {
        isWaitingForDisplay = true
      }
    }
  }

  private func makeStream(
    filter: SCContentFilter, configuration: SCStreamConfiguration, renderer: DesktopRenderer,
    session: UUID
  ) throws -> SCStream {
    let frames = ScreenFrames()
    frames.renderer = renderer
    frames.onFailure = { [weak self] failure in
      Task { @MainActor in
        guard let self, self.session == session else { return }
        self.stop()
        let now = CACurrentMediaTime()
        guard now - self.lastCaptureRecovery > 5 else {
          self.error = failure.localizedDescription
          return
        }
        self.lastCaptureRecovery = now
        self.isWaitingForDisplay = true
        self.refreshDisplay(after: .seconds(1))
      }
    }
    let stream = SCStream(filter: filter, configuration: configuration, delegate: frames)
    try stream.addStreamOutput(
      frames, type: .screen,
      sampleHandlerQueue: DispatchQueue(label: "softfold.capture", qos: .userInteractive))
    self.frames = frames
    self.stream = stream
    return stream
  }

  private func resumeCapture() {
    captureTask?.cancel()
    captureTask = nil
    guard stream == nil, let filter, let configuration, let renderer else { return }
    let session = self.session
    do {
      let stream = try makeStream(
        filter: filter, configuration: configuration, renderer: renderer, session: session)
      Task { [weak self] in
        do {
          try await stream.startCapture()
        } catch {
          guard let self, self.session == session, self.stream === stream else { return }
          self.stop()
          self.error = error.localizedDescription
        }
      }
    } catch {
      stop()
      self.error = error.localizedDescription
    }
  }

  private func pauseCapture() {
    captureTask?.cancel()
    let session = self.session
    captureTask = Task { [weak self] in
      do { try await Task.sleep(for: .seconds(3)) } catch { return }
      guard let self, self.session == session, !self.motion.isClosing, let stream = self.stream
      else { return }
      self.captureTask = nil
      let frames = self.frames
      self.stream = nil
      self.frames = nil
      try? await stream.stopCapture()
      if let frames { try? stream.removeStreamOutput(frames, type: .screen) }
      guard self.session == session, self.stream == nil else { return }
      self.renderer?.discardFrame()
    }
  }

  private var builtInScreenAvailable: Bool {
    NSScreen.screens.contains {
      guard
        let number = $0.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber
      else { return false }
      return CGDisplayIsBuiltin(number.uint32Value) != 0
    }
  }

  private func excludedWindows(in content: SCShareableContent) -> [SCWindow] {
    content.windows.filter {
      $0.owningApplication?.processID == ProcessInfo.processInfo.processIdentifier
        && ($0.windowID == CGWindowID(overlay?.windowNumber ?? 0)
          || $0.title == "Softfold Desktop Overlay" || $0.windowLayer != 0)
    }
  }

  private func refreshExcludedWindows() async {
    guard isActive, let capturedDisplayID else { return }
    let currentSession = session
    do {
      let content = try await SCShareableContent.excludingDesktopWindows(
        false, onScreenWindowsOnly: false)
      guard session == currentSession,
        let display = content.displays.first(where: { $0.displayID == capturedDisplayID })
      else { return }
      let windows = excludedWindows(in: content)
      let windowIDs = Set(windows.map(\.windowID))
      guard windowIDs != excludedWindowIDs,
        windowIDs.contains(CGWindowID(overlay?.windowNumber ?? 0))
      else { return }
      let filter = SCContentFilter(display: display, excludingWindows: windows)
      self.filter = filter
      try await stream?.updateContentFilter(filter)
      if session == currentSession { excludedWindowIDs = windowIDs }
    } catch {
      guard session == currentSession else { return }
      stop()
      self.error = String(
        localized: "Could not update the captured windows: \(error.localizedDescription)")
    }
  }

  private func refreshSpace() {
    guard isActive, !resumeAfterWake else { return }
    displayTask?.cancel()
    let refreshSession = session
    displayTask = Task { [weak self] in
      do { try await Task.sleep(for: .milliseconds(400)) } catch { return }
      guard let self, !Task.isCancelled, self.session == refreshSession,
        self.isActive, !self.resumeAfterWake
      else { return }
      self.displayTask = nil
      guard let displayID = self.capturedDisplayID,
        let screen = NSScreen.screens.first(where: {
          ($0.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?
            .uint32Value == displayID
        })
      else { return }
      if self.overlay?.frame != screen.frame {
        self.stop()
        await self.start()
      } else {
        self.overlay?.orderFrontRegardless()
      }
    }
  }

  private func makeOverlay(screen: NSScreen, area: CGRect, renderer: DesktopRenderer) {
    let window = DesktopPanel(
      contentRect: area, styleMask: [.borderless, .nonactivatingPanel], backing: .buffered,
      defer: false)
    window.isFloatingPanel = true
    window.becomesKeyOnlyIfNeeded = true
    window.title = "Softfold Desktop Overlay"
    window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.screenSaverWindow)))
    window.collectionBehavior = [
      .canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle,
    ]
    window.isOpaque = false
    window.backgroundColor = .clear
    window.hasShadow = false
    window.ignoresMouseEvents = true
    window.hidesOnDeactivate = false
    window.isReleasedWhenClosed = false
    window.sharingType = .readOnly
    let view = MTKView(frame: NSRect(origin: .zero, size: area.size), device: renderer.device)
    view.delegate = renderer
    view.colorPixelFormat = .bgra8Unorm
    view.colorspace = CGColorSpace(name: CGColorSpace.sRGB)
    view.clearColor = MTLClearColorMake(0, 0, 0, 0)
    view.framebufferOnly = true
    view.isPaused = true
    view.enableSetNeedsDisplay = false
    view.autoResizeDrawable = true
    view.layer?.isOpaque = false
    window.contentView = view
    window.setFrame(area, display: false)
    overlay = window
    metalView = view
    window.orderFrontRegardless()
    view.draw()
    let link = view.displayLink(target: self, selector: #selector(drawFrame(_:)))
    let refresh = Float(min(max(screen.maximumFramesPerSecond, 1), 60))
    view.preferredFramesPerSecond = Int(refresh)
    link.preferredFrameRateRange = CAFrameRateRange(
      minimum: refresh, maximum: refresh, preferred: refresh)
    link.isPaused = true
    link.add(to: .main, forMode: .common)
    displayLink = link
  }

  private func beginRendering() {
    guard isActive, motion.isClosing else { return }
    isFolding = true
    resumeCapture()
    displayLink?.isPaused = false
  }

  @objc private func drawFrame(_ link: CADisplayLink) {
    guard isActive else { return }
    renderer?.presentationTime = link.targetTimestamp
    metalView?.draw()
  }

  private func restOverlay() {
    guard !motion.isClosing else { return }
    isFolding = false
    displayLink?.isPaused = true
    pauseCapture()
  }

  private func refreshDisplay(after delay: Duration = .milliseconds(300)) {
    guard isActive || isWaitingForDisplay, !resumeAfterWake else { return }
    displayTask?.cancel()
    displayTask = Task { [weak self] in
      do { try await Task.sleep(for: delay) } catch { return }
      guard let self, self.isActive || self.isWaitingForDisplay, !self.resumeAfterWake else {
        return
      }
      self.displayTask = nil
      self.stop()
      await self.start()
    }
  }

  private func suspendForSleep() {
    resumeAfterWake = resumeAfterWake || isActive || isStarting || isWaitingForDisplay
    stop(preserveResume: true)
    sensor.stop()
  }

  private func resumeFromSleep() {
    guard !isActive, !isStarting, wakeTask == nil else { return }
    sensor.reconnect()
    guard resumeAfterWake else { return }
    wakeTask = Task { [weak self] in
      guard let self else { return }
      for _ in 0..<5 {
        do { try await Task.sleep(for: .seconds(1)) } catch { return }
        guard self.resumeAfterWake, !Task.isCancelled else { return }
        if self.sensorAvailable { break }
        self.sensor.reconnect()
      }
      guard self.resumeAfterWake, !Task.isCancelled else { return }
      self.wakeTask = nil
      self.resumeAfterWake = false
      await self.start()
    }
  }

  func stop(preserveResume: Bool = false) {
    if !preserveResume {
      resumeAfterWake = false
      wakeTask?.cancel()
      wakeTask = nil
    }
    session = UUID()
    sensor.setTracking(false)
    motion.setEnabled(false)
    displayLink?.invalidate()
    displayLink = nil
    metalView?.isPaused = true
    metalView?.delegate = nil
    overlay?.orderOut(nil)
    overlay?.close()
    overlay = nil
    metalView = nil
    displayTask?.cancel()
    displayTask = nil
    captureTask?.cancel()
    captureTask = nil
    filter = nil
    configuration = nil
    let oldStream = stream
    let oldFrames = frames
    stream = nil
    if let oldStream {
      Task {
        try? await oldStream.stopCapture()
        if let oldFrames { try? oldStream.removeStreamOutput(oldFrames, type: .screen) }
      }
    }
    frames = nil
    renderer = nil
    capturedDisplayID = nil
    excludedWindowIDs = []
    isActive = false
    isFolding = false
    isStarting = false
    isWaitingForDisplay = false
  }

  func shutDown() {
    stop()
    sensor.stop()
  }
}
