import AppKit
import SwiftUI

@MainActor
final class Navigator: ObservableObject {
  enum Page: String, CaseIterable, Identifiable {
    case effect
    case general

    var id: String { rawValue }

    var title: String {
      switch self {
      case .effect: String(localized: "Effect")
      case .general: String(localized: "General")
      }
    }

    var symbol: String {
      switch self {
      case .effect: "laptopcomputer"
      case .general: "gearshape.fill"
      }
    }

    var tint: Color {
      switch self {
      case .effect: .blue
      case .general: .gray
      }
    }
  }

  @Published var page = Page.effect
}

struct MainView: View {
  @ObservedObject var desktop: LiveDesktop
  @ObservedObject var navigator: Navigator

  var body: some View {
    HStack(spacing: 0) {
      sidebar
        .frame(width: 180)
        .background(SidebarMaterial().ignoresSafeArea())
      Divider().ignoresSafeArea()
      switch navigator.page {
      case .effect: EffectPage(desktop: desktop)
      case .general: SettingsView(desktop: desktop)
      }
    }
    .frame(width: 640, height: 520)
  }

  private var sidebar: some View {
    VStack(alignment: .leading, spacing: 2) {
      Color.clear.frame(height: 10)
      ForEach(Navigator.Page.allCases) { item in
        Button {
          navigator.page = item
        } label: {
          HStack(spacing: 10) {
            SettingsIcon(symbol: item.symbol, tint: item.tint)
            Text(item.title)
              .font(.system(size: 13))
              .foregroundStyle(navigator.page == item ? Color.white : Color.primary)
            Spacer(minLength: 0)
          }
          .padding(.horizontal, 8)
          .padding(.vertical, 6)
          .background(
            RoundedRectangle(cornerRadius: 7, style: .continuous)
              .fill(navigator.page == item ? Color.accentColor : .clear)
          )
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
      }
      Spacer(minLength: 0)
    }
    .padding(.horizontal, 9)
  }
}

private struct EffectPage: View {
  @ObservedObject var desktop: LiveDesktop

  var body: some View {
    SettingsPage {
      SettingsGroup(title: "Softfold") {
        SettingsRow(
          "power", tint: desktop.isActive ? .green : .gray, title: title, subtitle: subtitle
        ) {
          Toggle(
            "Turn Softfold on or off",
            isOn: Binding(get: { desktop.isEnabled }, set: { desktop.setEnabled($0) })
          )
          .toggleStyle(.switch)
          .controlSize(.small)
          .labelsHidden()
          .disabled(desktop.isStarting)
        }
        if let error = desktop.error {
          SettingsDivider()
          SettingsRow("exclamationmark.triangle.fill", tint: .orange, title: error) {
            if desktop.needsPermission {
              Button("Open Settings", action: openScreenRecordingSettings)
                .controlSize(.small)
            }
          }
        }
      }
      look
      SettingsGroup(
        title: String(localized: "Open position"),
        footnote: String(
          localized:
            "Starts at 100°. Set your comfortable open position once, and Softfold remembers it.")
      ) {
        SettingsRow(
          "angle", tint: .indigo, title: String(localized: "Open position"),
          subtitle: Measurement(value: desktop.openAngle, unit: UnitAngle.degrees).formatted(
            .measurement(width: .narrow, numberFormatStyle: .number.precision(.fractionLength(0))))
        ) {
          Button("Set") { desktop.setOpenPosition() }
            .controlSize(.small)
            .disabled(!desktop.sensorAvailable || desktop.isStarting)
            .help("Save the lid angle you are viewing at right now")
        }
      }
    }
  }

  private var look: some View {
    SettingsGroup(title: String(localized: "Look")) {
      SettingsRow(
        "slider.horizontal.3", tint: .orange, title: String(localized: "Effect strength"),
        subtitle: strength
      ) {
        HStack(spacing: 8) {
          Slider(
            value: Binding(
              get: { desktop.effectStrength },
              set: { desktop.setEffectStrength($0) }),
            in: 0.25...1, step: 0.05
          )
          .frame(width: 110)
          .accessibilityLabel("Effect strength")
          .accessibilityValue(strength)
          Button {
            desktop.setEffectStrength(1)
          } label: {
            Image(systemName: "arrow.counterclockwise")
          }
          .controlSize(.small)
          .disabled(desktop.effectStrength == 1)
          .help(String(localized: "Reset effect strength to 100%"))
          .accessibilityLabel("Reset effect strength to default")
        }
      }
      SettingsDivider()
      SettingsRow(
        "square.lefthalf.filled", tint: .indigo, title: String(localized: "Sides"),
        subtitle: String(localized: "Beside the folded desktop")
      ) {
        Picker(
          "Sides",
          selection: Binding(get: { desktop.sideFill }, set: { desktop.setSideFill($0) })
        ) {
          Text("Blur").tag(SideFill.blur)
          Text("Black").tag(SideFill.black)
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .fixedSize()
        .controlSize(.small)
      }
      SettingsDivider()
      SettingsRow(
        "crop", tint: .teal, title: String(localized: "Crop from the top"),
        subtitle: String(localized: "The top of the desktop slides out of view as the lid closes.")
      ) {
        Toggle(
          "Crop from the top",
          isOn: Binding(get: { desktop.cropsTop }, set: { desktop.setCropsTop($0) })
        )
        .toggleStyle(.switch)
        .controlSize(.small)
        .labelsHidden()
      }
      SettingsDivider()
      SettingsRow(
        "camera.aperture", tint: .purple, title: String(localized: "Blur by distance"),
        subtitle: desktop.blursByDistance
          ? String(
            localized:
              "Blur grows with distance from the open screen, so the hinge edge stays sharp.")
          : String(localized: "Blur builds toward the top and fades out near the hinge.")
      ) {
        Toggle(
          "Blur by distance",
          isOn: Binding(get: { desktop.blursByDistance }, set: { desktop.setBlursByDistance($0) })
        )
        .toggleStyle(.switch)
        .controlSize(.small)
        .labelsHidden()
      }
    }
  }

  private var strength: String {
    desktop.effectStrength.formatted(.percent.precision(.fractionLength(0)))
  }

  private var title: String {
    if desktop.isActive { return String(localized: "On") }
    if desktop.isStarting { return String(localized: "Starting…") }
    return desktop.isEnabled ? String(localized: "Waiting…") : String(localized: "Off")
  }

  private var subtitle: String {
    if desktop.isActive { return String(localized: "Your desktop bends as the lid closes.") }
    if desktop.isStarting { return String(localized: "Getting the desktop and the sensor ready.") }
    if desktop.isWaitingForDisplay {
      return String(localized: "Waiting for the built-in display to turn on.")
    }
    if !desktop.sensorAvailable { return String(localized: "Waiting for the lid angle sensor.") }
    if desktop.isEnabled { return String(localized: "Softfold is on but not running yet.") }
    return String(localized: "Turn Softfold on to follow the lid.")
  }
}

private struct SidebarMaterial: NSViewRepresentable {
  func makeNSView(context: Context) -> NSVisualEffectView {
    let view = NSVisualEffectView()
    view.material = .sidebar
    view.blendingMode = .behindWindow
    view.state = .followsWindowActiveState
    return view
  }

  func updateNSView(_ view: NSVisualEffectView, context: Context) {}
}
