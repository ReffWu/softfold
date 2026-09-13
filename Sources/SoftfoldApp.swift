import AppKit
import Carbon.HIToolbox
import Sparkle
import SwiftUI

@main
struct SoftfoldApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate
  @StateObject private var desktop = LiveDesktop()
  @StateObject private var updater = Updater()

  var body: some Scene {
    Window("Softfold", id: "main") {
      MainView(desktop: desktop, updater: updater)
        .onAppear {
          delegate.onTerminate = { desktop.shutDown() }
          delegate.installToggleHotKey {
            if !desktop.isStarting { desktop.setEnabled(!desktop.isEnabled) }
          }
        }
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(.contentSize)
    .defaultPosition(.center)
    .commands {
      WindowCommands()
      CommandGroup(after: .appInfo) {
        Button("Check for Updates…") { updater.checkForUpdates() }
      }
    }
    Window("About Softfold", id: "about") {
      AboutView()
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(.contentSize)
    .defaultPosition(.center)
    MenuBarExtra {
      SoftfoldMenu(desktop: desktop, updater: updater)
    } label: {
      Image(desktop.isActive ? "MenuBarIconActive" : "MenuBarIcon")
        .accessibilityLabel("Softfold")
    }
  }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
  var onTerminate: (() -> Void)?
  private var toggleHotKey: EventHotKeyRef?
  private var hotKeyHandler: EventHandlerRef?

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { false }

  func applicationDidFinishLaunching(_ notification: Notification) {
    AppIconStyle.restore()
  }

  func applicationWillTerminate(_ notification: Notification) {
    if let toggleHotKey { UnregisterEventHotKey(toggleHotKey) }
    if let hotKeyHandler { RemoveEventHandler(hotKeyHandler) }
    onTerminate?()
  }

  func installToggleHotKey(_ action: @escaping () -> Void) {
    onToggle = action
    guard toggleHotKey == nil else { return }
    var event = EventTypeSpec(
      eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
    var handler: EventHandlerRef?
    let context = Unmanaged.passUnretained(self).toOpaque()
    let handlerStatus = InstallEventHandler(
      GetApplicationEventTarget(),
      { _, _, context in
        guard let context else { return OSStatus(eventNotHandledErr) }
        let delegate = Unmanaged<AppDelegate>.fromOpaque(context).takeUnretainedValue()
        Task { @MainActor in delegate.onToggle?() }
        return noErr
      }, 1, &event, context, &handler)
    guard handlerStatus == noErr else {
      showHotKeyError(handlerStatus)
      return
    }
    var hotKey: EventHotKeyRef?
    let hotKeyStatus = RegisterEventHotKey(
      UInt32(kVK_ANSI_H), UInt32(controlKey | optionKey),
      EventHotKeyID(signature: OSType(0x484E_4745), id: 1), GetApplicationEventTarget(), 0,
      &hotKey)
    guard hotKeyStatus == noErr else {
      if let handler { RemoveEventHandler(handler) }
      showHotKeyError(hotKeyStatus)
      return
    }
    hotKeyHandler = handler
    toggleHotKey = hotKey
  }

  private var onToggle: (() -> Void)?

  private func showHotKeyError(_ status: OSStatus) {
    let alert = NSAlert()
    alert.messageText = String(localized: "Keyboard shortcut unavailable")
    alert.informativeText = String(localized: "Softfold could not register ⌃⌥H (error \(status)).")
    alert.alertStyle = .warning
    alert.runModal()
  }
}

struct WindowCommands: Commands {
  @Environment(\.openWindow) private var openWindow

  var body: some Commands {
    CommandGroup(replacing: .appInfo) {
      Button("About Softfold") {
        openWindow(id: "about")
        NSApp.activate(ignoringOtherApps: true)
      }
    }
    CommandGroup(replacing: .appSettings) {
      Button("Settings…") {
        openWindow(id: "main")
        NSApp.activate(ignoringOtherApps: true)
      }
      .keyboardShortcut(",")
    }
  }
}

struct SoftfoldMenu: View {
  @ObservedObject var desktop: LiveDesktop
  @ObservedObject var updater: Updater
  @Environment(\.openWindow) private var openWindow

  var body: some View {
    Button {
      desktop.setEnabled(!desktop.isEnabled)
    } label: {
      HStack {
        Text(desktop.isEnabled ? String(localized: "Turn off") : String(localized: "Turn on"))
        Spacer()
        Text("⌃⌥H").foregroundStyle(.secondary)
      }
    }
    .disabled(desktop.isStarting)
    Button("Set open position") { desktop.setOpenPosition() }
      .disabled(!desktop.sensorAvailable || desktop.isStarting)
    Divider()
    Button("About Softfold") {
      openWindow(id: "about")
      NSApp.activate(ignoringOtherApps: true)
    }
    Button("Open Softfold") {
      openWindow(id: "main")
      NSApp.activate(ignoringOtherApps: true)
    }
    Button("Check for Updates…") { updater.checkForUpdates() }
    Button("Quit Softfold") { NSApp.terminate(nil) }.keyboardShortcut("q")
  }
}

@MainActor
final class Updater: ObservableObject {
  private let controller = SPUStandardUpdaterController(
    startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)

  init() {
    controller.updater.automaticallyChecksForUpdates = true
  }

  func checkForUpdates() {
    NSApp.activate(ignoringOtherApps: true)
    controller.checkForUpdates(nil)
  }
}
