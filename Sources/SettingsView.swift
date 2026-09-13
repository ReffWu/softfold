import SwiftUI

struct PreferencesCard: View {
  @State private var language = AppLanguage.current
  @State private var iconStyle = AppIconStyle.current

  var body: some View {
    SettingsGroup {
      SettingsRow("app.badge", tint: .blue, title: String(localized: "App icon")) {
        HStack(spacing: 10) {
          iconChoice(.dark, label: Text("Dark"))
          iconChoice(.light, label: Text("Light"))
        }
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

  private static let iconSize: CGFloat = 46
  private static let iconDrawn: CGFloat = iconSize * 1024 / 980
  private static let iconCorner: CGFloat = iconSize * 262 / 980
  private static let ringGap: CGFloat = 2.5
  private static let ringWidth: CGFloat = 2.5

  private func iconChoice(_ style: AppIconStyle, label: Text) -> some View {
    let selected = iconStyle == style
    return Button {
      iconStyle = style
      AppIconStyle.choose(style)
    } label: {
      VStack(spacing: 4) {
        Image(nsImage: NSImage(named: "AppIcon-\(style.rawValue)") ?? NSImage())
          .resizable()
          .frame(width: Self.iconDrawn, height: Self.iconDrawn)
          .frame(width: Self.iconSize, height: Self.iconSize)
          .clipShape(RoundedRectangle(cornerRadius: Self.iconCorner, style: .circular))
          .overlay(
            RoundedRectangle(cornerRadius: Self.iconCorner, style: .circular)
              .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
          )
          .padding(Self.ringGap + Self.ringWidth)
          .overlay(
            RoundedRectangle(
              cornerRadius: Self.iconCorner + Self.ringGap + Self.ringWidth, style: .circular
            )
            .strokeBorder(selected ? Color.accentColor : .clear, lineWidth: Self.ringWidth)
          )
        label
          .font(.system(size: 11, weight: selected ? .semibold : .regular))
          .foregroundStyle(selected ? .primary : .secondary)
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .accessibilityAddTraits(selected ? .isSelected : [])
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

struct AboutView: View {
  @State private var style = AppIconStyle.current

  private static let icon: CGFloat = 240

  var body: some View {
    VStack(spacing: 0) {
      Image(nsImage: NSImage(named: "AppIcon-\(style.rawValue)") ?? NSImage())
        .resizable()
        .interpolation(.high)
        .frame(width: Self.icon * 1024 / 980, height: Self.icon * 1024 / 980)
        .frame(width: Self.icon, height: Self.icon)
        .clipShape(RoundedRectangle(cornerRadius: Self.icon * 262 / 980, style: .circular))
        .shadow(color: .black.opacity(0.22), radius: 16, y: 8)
        .padding(.top, 40)
        .padding(.bottom, 6)
        .accessibilityHidden(true)
      Text(verbatim: "Softfold")
        .font(.system(size: 24, weight: .semibold))
        .padding(.top, 8)
      Text("Your desktop follows your lid.")
        .font(.system(size: 13))
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 36)
        .padding(.top, 6)
      HStack(spacing: 6) {
        Text("Version \(versionLabel)")
        if let project = URL(string: "https://github.com/ReffWu/softfold") {
          Text(verbatim: "·")
          Link(destination: project) { Text(verbatim: "GitHub") }
            .buttonStyle(.plain)
        }
      }
      .font(.system(size: 11))
      .foregroundStyle(.secondary)
      .padding(.top, 20)
      Text(verbatim: "© 2026 Reff Wu")
        .font(.system(size: 11))
        .foregroundStyle(.tertiary)
        .padding(.top, 4)
        .padding(.bottom, 28)
    }
    .frame(width: 360)
    .background(Color(nsColor: .windowBackgroundColor).ignoresSafeArea())
    .onAppear { style = AppIconStyle.current }
  }

  private var versionLabel: String {
    let info = Bundle.main.infoDictionary
    let version = info?["CFBundleShortVersionString"] as? String ?? ""
    guard let build = info?["CFBundleVersion"] as? String, !build.isEmpty else { return version }
    return "\(version) (\(build))"
  }
}
