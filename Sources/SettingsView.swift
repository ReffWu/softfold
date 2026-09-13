import ServiceManagement
import SwiftUI

struct SettingsView: View {
  @ObservedObject var desktop: LiveDesktop
  @State private var loginItemStatus = SMAppService.mainApp.status
  @State private var loginItemError: String?
  @State private var language = AppLanguage.current
  @State private var iconStyle = AppIconStyle.current

  var body: some View {
    SettingsPage {
      controls
      status
      about
    }
    .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification))
    { _ in
      loginItemStatus = SMAppService.mainApp.status
    }
  }

  private var controls: some View {
    SettingsGroup(title: String(localized: "Controls")) {
      SettingsRow(
        "power", tint: .blue, title: String(localized: "Launch at login"),
        subtitle: loginItemError ?? loginItemNote
      ) {
        if loginItemStatus == .requiresApproval {
          Button("Open Login Items") { SMAppService.openSystemSettingsLoginItems() }
            .controlSize(.small)
        }
        Toggle("Launch at login", isOn: launchAtLogin)
          .toggleStyle(.switch)
          .controlSize(.small)
          .labelsHidden()
      }
      SettingsDivider()
      SettingsRow("keyboard", tint: .gray, title: String(localized: "Turn Softfold on or off")) {
        Text("⌃⌥H")
          .font(.system(size: 12, weight: .medium))
          .foregroundStyle(.secondary)
          .padding(.horizontal, 7)
          .padding(.vertical, 3)
          .background(Color.primary.opacity(0.07), in: RoundedRectangle(cornerRadius: 5))
      }
      SettingsDivider()
      SettingsRow(
        "globe", tint: .indigo, title: String(localized: "Language"),
        subtitle: language == AppLanguage.atLaunch
          ? nil : String(localized: "Relaunch Softfold to switch languages.")
      ) {
        if language != AppLanguage.atLaunch {
          Button("Relaunch", action: AppLanguage.relaunch)
            .controlSize(.small)
        }
        Picker(
          "Language",
          selection: Binding(
            get: { language },
            set: {
              language = $0
              AppLanguage.choose($0)
            })
        ) {
          Text("System Language").tag("")
          ForEach(AppLanguage.available, id: \.self) { code in
            Text(verbatim: AppLanguage.name(of: code)).tag(code)
          }
        }
        .labelsHidden()
        .fixedSize()
        .controlSize(.small)
      }
    }
  }

  private var status: some View {
    SettingsGroup(
      title: String(localized: "Status"),
      footnote: String(
        localized:
          "Softfold reads your display only to draw the fold. Frames stay in memory on your Mac.")
    ) {
      let allowed = CGPreflightScreenCaptureAccess()
      SettingsRow(
        "rectangle.dashed.badge.record", tint: .red, title: String(localized: "Screen Recording"),
        subtitle: allowed
          ? String(localized: "Allowed") : String(localized: "Needed to show your live desktop")
      ) {
        if allowed {
          Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
        } else {
          Button("Open Settings", action: openScreenRecordingSettings)
            .controlSize(.small)
        }
      }
      SettingsDivider()
      SettingsRow(
        "laptopcomputer", tint: .teal, title: String(localized: "Lid angle sensor"),
        subtitle: desktop.sensorAvailable
          ? String(localized: "Connected") : String(localized: "Not connected")
      ) {
        Circle()
          .fill(desktop.sensorAvailable ? Color.green : Color.orange)
          .frame(width: 8, height: 8)
      }
    }
  }

  private var about: some View {
    SettingsGroup(title: String(localized: "About")) {
      SettingsRow("app.badge", tint: .blue, title: String(localized: "App icon")) {
        Picker(
          "App icon",
          selection: Binding(
            get: { iconStyle },
            set: {
              iconStyle = $0
              AppIconStyle.choose($0)
            })
        ) {
          Text("Dark").tag(AppIconStyle.dark)
          Text("Light").tag(AppIconStyle.light)
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .fixedSize()
        .controlSize(.small)
      }
      SettingsDivider()
      SettingsRow(
        title: "Softfold \(version)", subtitle: String(localized: "Your desktop follows your lid."),
        leading: { Image(nsImage: NSApp.applicationIconImage).resizable() },
        trailing: {
          if let project = URL(string: "https://github.com/ReffWu/softfold") {
            Link("GitHub", destination: project).font(.system(size: 12))
          }
        })
    }
  }

  private var loginItemNote: String? {
    loginItemStatus == .requiresApproval
      ? String(localized: "Allow Softfold in Login Items to finish.") : nil
  }

  private var launchAtLogin: Binding<Bool> {
    Binding(
      get: {
        loginItemStatus == .enabled || loginItemStatus == .requiresApproval
      },
      set: setLaunchAtLogin)
  }

  private func setLaunchAtLogin(_ enabled: Bool) {
    do {
      if enabled {
        try SMAppService.mainApp.register()
      } else {
        try SMAppService.mainApp.unregister()
      }
      loginItemError = nil
    } catch {
      loginItemError = String(
        localized: "Could not update Launch at Login: \(error.localizedDescription)")
    }
    loginItemStatus = SMAppService.mainApp.status
  }

  private var version: String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
  }
}

enum AppIconStyle: String {
  case dark
  case light

  private static let key = "AppIconStyle"

  static var current: AppIconStyle {
    AppIconStyle(rawValue: UserDefaults.standard.string(forKey: key) ?? "") ?? .dark
  }

  static func choose(_ style: AppIconStyle) {
    UserDefaults.standard.set(style.rawValue, forKey: key)
    apply(style)
  }

  static func restore() {
    if current != .dark { apply(current) }
  }

  private static func apply(_ style: AppIconStyle) {
    let image = style == .dark ? nil : NSImage(named: "AppIcon-\(style.rawValue)")
    NSApp.applicationIconImage = image
    NSWorkspace.shared.setIcon(image, forFile: Bundle.main.bundlePath, options: [])
  }
}

private enum AppLanguage {
  static let atLaunch = current

  static var current: String {
    let domain = UserDefaults.standard.persistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
    return (domain?["AppleLanguages"] as? [String])?.first ?? ""
  }

  static let available = Set(Bundle.main.localizations).subtracting(["Base"]).sorted {
    name(of: $0).localizedStandardCompare(name(of: $1)) == .orderedAscending
  }

  static func name(of code: String) -> String {
    let locale = Locale(identifier: code)
    return locale.localizedString(forIdentifier: code)?.capitalized(with: locale) ?? code
  }

  static func choose(_ code: String) {
    if code.isEmpty {
      UserDefaults.standard.removeObject(forKey: "AppleLanguages")
    } else {
      UserDefaults.standard.set([code], forKey: "AppleLanguages")
    }
  }

  static func relaunch() {
    let reopen = Process()
    reopen.executableURL = URL(fileURLWithPath: "/bin/sh")
    reopen.arguments = ["-c", "sleep 0.5; /usr/bin/open \"$0\"", Bundle.main.bundlePath]
    try? reopen.run()
    NSApp.terminate(nil)
  }
}
