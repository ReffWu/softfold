import AppKit
import Carbon.HIToolbox
import Sparkle
import SwiftUI

@main
struct SoftfoldApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate
  @StateObject private var desktop = LiveDesktop()
  @StateObject private var updater = Updater()
  @AppStorage("showsMenuBarIcon") private var showsMenuBarIcon = true

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
    MenuBarExtra(isInserted: $showsMenuBarIcon) {
      MenuBarPanel(desktop: desktop, updater: updater)
    } label: {
      Image(desktop.isActive ? "MenuBarIconActive" : "MenuBarIcon")
        .accessibilityLabel("Softfold")
    }
    .menuBarExtraStyle(.window)
  }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
  var onTerminate: (() -> Void)?
  private var toggleHotKey: EventHotKeyRef?
  private var hotKeyHandler: EventHandlerRef?

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { false }

  func applicationWillFinishLaunching(_ notification: Notification) {
    DockIcon.apply()
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

struct MenuBarPanel: View {
  @ObservedObject var desktop: LiveDesktop
  @ObservedObject var updater: Updater
  @Environment(\.openWindow) private var openWindow

  var body: some View {
    VStack(spacing: 12) {
      LidPicture(
        lid: desktop.lid, openAngle: desktop.openAngle, active: desktop.isActive,
        available: desktop.sensorAvailable, folding: desktop.isFolding, centered: true
      )
      .padding(.top, 8)
      VStack(spacing: 0) {
        SettingsRow(
          title: desktop.statusTitle, subtitle: desktop.statusSubtitle,
          leading: { SettingsIcon(symbol: "power", tint: desktop.isActive ? .green : .gray) }
        ) {
          Toggle(
            "Turn Softfold on or off",
            isOn: Binding(get: { desktop.isEnabled }, set: { desktop.setEnabled($0) })
          )
          .toggleStyle(.switch)
          .labelsHidden()
          .disabled(desktop.isStarting)
          .help(Text("⌃⌥H"))
        }
        SettingsDivider()
        SettingsRow(
          "angle", tint: .indigo, title: String(localized: "Open position"),
          subtitle: degrees(desktop.openAngle)
        ) {
          if !desktop.isDefaultOpenAngle {
            Button {
              withAnimation(.smooth(duration: 0.4)) { desktop.restoreDefaultOpenPosition() }
            } label: {
              Image(systemName: "arrow.counterclockwise")
            }
            .accessibilityLabel(Text("Restore Default"))
            .controlSize(.small)
            .fixedSize()
            .help(Text("Go back to \(degrees(LiveDesktop.defaultOpenAngle))"))
          }
          Button("Use Current Angle") {
            withAnimation(.smooth(duration: 0.4)) { desktop.setOpenPosition() }
          }
          .controlSize(.small)
          .fixedSize()
          .disabled(!desktop.sensorAvailable || desktop.isStarting)
          .help("Save the lid angle you are viewing at right now")
        }
      }
      .panelCard()
      if let error = desktop.error {
        HStack(alignment: .top, spacing: 8) {
          Image(systemName: "exclamationmark.triangle.fill")
            .foregroundStyle(.orange)
          Text(error)
            .font(.system(size: 11))
            .fixedSize(horizontal: false, vertical: true)
          Spacer(minLength: 4)
          if desktop.needsPermission {
            Button("Open Settings", action: openScreenRecordingSettings)
              .controlSize(.small)
          }
        }
        .padding(10)
        .panelCard()
      }
      Divider().padding(.horizontal, 6)
      VStack(spacing: 0) {
        PanelAction(symbol: "gearshape", title: String(localized: "Settings…"), shortcut: "⌘,") {
          openWindow(id: "main")
          NSApp.activate(ignoringOtherApps: true)
        }
        .keyboardShortcut(",")
        PanelAction(
          symbol: "arrow.triangle.2.circlepath", title: String(localized: "Check for Updates…")
        ) {
          updater.checkForUpdates()
        }
        PanelAction(symbol: "power", title: String(localized: "Quit Softfold"), shortcut: "⌘Q") {
          NSApp.terminate(nil)
        }
        .keyboardShortcut("q")
      }
    }
    .padding(.horizontal, 12)
    .padding(.top, 8)
    .padding(.bottom, 6)
    .frame(width: 330)
    .background(.regularMaterial)
  }
}

private struct PanelAction: View {
  let symbol: String
  let title: String
  var shortcut: String?
  let action: () -> Void

  @State private var hovering = false

  var body: some View {
    Button(action: action) {
      HStack(spacing: 8) {
        Image(systemName: symbol)
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
          .frame(width: 18)
        Text(verbatim: title)
          .font(.system(size: 13))
          .lineLimit(1)
        Spacer(minLength: 8)
        if let shortcut {
          Text(verbatim: shortcut)
            .font(.system(size: 12))
            .foregroundStyle(.tertiary)
        }
      }
      .padding(.horizontal, 8)
      .frame(height: 26)
      .background(
        RoundedRectangle(cornerRadius: 6, style: .continuous)
          .fill(Color.primary.opacity(hovering ? 0.09 : 0))
      )
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .onHover { hovering = $0 }
  }
}

extension View {
  fileprivate func panelCard() -> some View {
    background(
      RoundedRectangle(cornerRadius: 10, style: .continuous)
        .fill(Color.primary.opacity(0.05))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 10, style: .continuous)
        .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
    )
  }
}

@MainActor
final class Updater: NSObject, ObservableObject, SPUUpdaterDelegate {
  private var controller: SPUStandardUpdaterController?
  @Published var installsAutomatically = true {
    didSet { controller?.updater.automaticallyDownloadsUpdates = installsAutomatically }
  }

  override init() {
    super.init()
    let controller = SPUStandardUpdaterController(
      startingUpdater: true, updaterDelegate: self, userDriverDelegate: nil)
    controller.updater.automaticallyChecksForUpdates = true
    self.controller = controller
    installsAutomatically = controller.updater.automaticallyDownloadsUpdates
  }

  func checkForUpdates() {
    NSApp.activate(ignoringOtherApps: true)
    controller?.checkForUpdates(nil)
  }

  nonisolated func updater(
    _ updater: SPUUpdater, willInstallUpdateOnQuit item: SUAppcastItem,
    immediateInstallationBlock: @escaping () -> Void
  ) -> Bool {
    DispatchQueue.main.async { immediateInstallationBlock() }
    return true
  }
}
