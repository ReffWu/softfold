import SwiftUI

struct SettingsView: View {
  @State private var language = AppLanguage.current
  @State private var iconStyle = AppIconStyle.current

  var body: some View {
    SettingsPage {
      SettingsGroup(title: String(localized: "Look")) {
        SettingsRow("app.badge", tint: .blue, title: String(localized: "App icon")) {
          HStack(spacing: 12) {
            iconChoice(.dark, label: Text("Dark"))
            iconChoice(.light, label: Text("Light"))
          }
        }
      }
      SettingsGroup(title: String(localized: "Controls")) {
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
      SettingsGroup(title: String(localized: "About")) {
        SettingsRow(
          title: "Softfold \(version)",
          subtitle: String(localized: "Your desktop follows your lid."),
          leading: { Image(nsImage: NSApp.applicationIconImage).resizable() },
          trailing: {
            if let project = URL(string: "https://github.com/ReffWu/softfold") {
              Link("GitHub", destination: project).font(.system(size: 12))
            }
          })
      }
    }
  }

  private func iconChoice(_ style: AppIconStyle, label: Text) -> some View {
    let selected = iconStyle == style
    return Button {
      iconStyle = style
      AppIconStyle.choose(style)
    } label: {
      VStack(spacing: 4) {
        Image(nsImage: NSImage(named: "AppIcon-\(style.rawValue)") ?? NSImage())
          .resizable()
          .frame(width: 56, height: 56)
          .padding(3)
          .overlay(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
              .strokeBorder(selected ? Color.accentColor : .clear, lineWidth: 2.5)
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
