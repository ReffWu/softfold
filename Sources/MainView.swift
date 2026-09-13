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
      case .general: SettingsView()
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
  @State private var screenRecordingAllowed = CGPreflightScreenCaptureAccess()

  var body: some View {
    SettingsPage {
      SettingsGroup(
        title: "Softfold",
        footnote: String(
          localized:
            "Softfold reads your display only to draw the fold. Frames stay in memory on your Mac.")
      ) {
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
        if !screenRecordingAllowed, !desktop.needsPermission {
          SettingsDivider()
          SettingsRow(
            "rectangle.dashed.badge.record", tint: .red,
            title: String(localized: "Screen Recording"),
            subtitle: String(localized: "Needed to show your live desktop")
          ) {
            Button("Open Settings", action: openScreenRecordingSettings)
              .controlSize(.small)
          }
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
    .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification))
    { _ in
      screenRecordingAllowed = CGPreflightScreenCaptureAccess()
    }
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
