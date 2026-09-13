import AppKit
import SwiftUI

struct MainView: View {
  @ObservedObject var desktop: LiveDesktop
  @ObservedObject var updater: Updater
  @State private var screenRecordingAllowed = CGPreflightScreenCaptureAccess()

  var body: some View {
    VStack(spacing: 0) {
      hero
      VStack(spacing: 16) {
        effect
        position
        PreferencesCard()
      }
      .padding(.horizontal, 20)
      footer
    }
    .frame(width: 440)
    .fixedSize()
    .background(Color(nsColor: .windowBackgroundColor).ignoresSafeArea())
    .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification))
    { _ in
      screenRecordingAllowed = CGPreflightScreenCaptureAccess()
    }
  }

  private var hero: some View {
    VStack(spacing: 4) {
      LidPicture(
        lid: desktop.lid, openAngle: desktop.openAngle, active: desktop.isActive,
        available: desktop.sensorAvailable
      )
      .padding(.bottom, 14)
      Text(verbatim: "Softfold")
        .font(.system(size: 22, weight: .semibold))
      Text("Your desktop follows your lid.")
        .font(.system(size: 13))
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 38)
    .padding(.bottom, 24)
  }

  private var effect: some View {
    SettingsGroup {
      SettingsRow(
        "power", tint: desktop.isActive ? .green : .gray, title: title, subtitle: subtitle
      ) {
        Toggle(
          "Turn Softfold on or off",
          isOn: Binding(get: { desktop.isEnabled }, set: { desktop.setEnabled($0) })
        )
        .toggleStyle(.switch)
        .labelsHidden()
        .disabled(desktop.isStarting)
      }
      if !screenRecordingAllowed, !desktop.needsPermission {
        SettingsDivider()
        SettingsRow(
          "rectangle.dashed.badge.record", tint: .red,
          title: String(localized: "Screen Recording"),
          subtitle: String(
            localized:
              "Softfold reads your display only to draw the fold. Frames stay in memory on your Mac."
          )
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
  }

  private var position: some View {
    SettingsGroup(
      footnote: String(
        localized:
          "Starts at 100°. Set your comfortable open position once, and Softfold remembers it.")
    ) {
      SettingsRow(
        "angle", tint: .indigo, title: String(localized: "Open position"),
        subtitle: degrees(desktop.openAngle)
      ) {
        Button("Use Current Angle") {
          withAnimation(.smooth(duration: 0.4)) { desktop.setOpenPosition() }
        }
        .controlSize(.small)
        .disabled(!desktop.sensorAvailable || desktop.isStarting)
        .help("Save the lid angle you are viewing at right now")
      }
    }
  }

  private var footer: some View {
    HStack(spacing: 6) {
      Text(verbatim: "Softfold \(version)")
      Text(verbatim: "·")
      Button("Check for Updates…") { updater.checkForUpdates() }
        .buttonStyle(.plain)
      if let project = URL(string: "https://github.com/ReffWu/softfold") {
        Text(verbatim: "·")
        Link(destination: project) { Text(verbatim: "GitHub") }
          .buttonStyle(.plain)
      }
    }
    .font(.system(size: 11))
    .foregroundStyle(.secondary)
    .padding(.top, 18)
    .padding(.bottom, 20)
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

  private var version: String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
  }
}

private func degrees(_ value: Double) -> String {
  Measurement(value: value, unit: UnitAngle.degrees).formatted(
    .measurement(width: .narrow, numberFormatStyle: .number.precision(.fractionLength(0))))
}

private struct LidPicture: View {
  @ObservedObject var lid: LidReading
  let openAngle: Double
  let active: Bool
  let available: Bool

  private static let hinge = CGPoint(x: 46, y: 102)
  private static let length: CGFloat = 108
  private static let thickness: CGFloat = 7

  var body: some View {
    let live = available ? lid.degrees : nil
    let angle = min(max(live ?? openAngle, 0), 180)
    ZStack(alignment: .topLeading) {
      Ellipse()
        .fill(Color.black.opacity(0.12))
        .frame(width: 156, height: 12)
        .blur(radius: 5)
        .offset(x: Self.hinge.x - 8, y: Self.hinge.y + 6)
      guide(angle: openAngle)
      UnevenRoundedRectangle(
        topLeadingRadius: 2, bottomLeadingRadius: 4, bottomTrailingRadius: 4,
        topTrailingRadius: 2, style: .continuous
      )
      .fill(
        LinearGradient(
          colors: [Color(white: 0.86), Color(white: 0.66)], startPoint: .top, endPoint: .bottom)
      )
      .overlay(alignment: .top) {
        Rectangle().fill(Color.white.opacity(0.7)).frame(height: 1)
      }
      .frame(width: 136, height: 8)
      .offset(x: Self.hinge.x - 2, y: Self.hinge.y)
      lidBar
        .rotationEffect(.degrees(-angle), anchor: .bottomLeading)
        .offset(x: Self.hinge.x, y: Self.hinge.y - Self.thickness)
        .opacity(live == nil ? 0.35 : 1)
    }
    .frame(width: 200, height: 116, alignment: .topLeading)
    .animation(.smooth(duration: 0.2), value: angle)
    .animation(.smooth(duration: 0.4), value: openAngle)
    .animation(.easeInOut(duration: 0.3), value: active)
    .accessibilityElement()
    .accessibilityLabel(Text("Lid angle"))
    .accessibilityValue(Text(verbatim: degrees(angle)))
  }

  private var lidBar: some View {
    ZStack(alignment: .bottom) {
      RoundedRectangle(cornerRadius: 3.5, style: .continuous)
        .fill(Color(nsColor: .labelColor).opacity(0.88))
      Capsule()
        .fill(active ? Color.accentColor : Color(nsColor: .tertiaryLabelColor))
        .frame(height: 2.5)
        .padding(.horizontal, 7)
        .padding(.bottom, 0.5)
        .shadow(color: active ? Color.accentColor.opacity(0.9) : .clear, radius: 5)
    }
    .frame(width: Self.length, height: Self.thickness)
  }

  private func guide(angle: Double) -> some View {
    let radians = angle * .pi / 180
    let tip = CGPoint(
      x: Self.hinge.x + cos(radians) * (Self.length + 16),
      y: Self.hinge.y - sin(radians) * (Self.length + 16))
    return ZStack(alignment: .topLeading) {
      Path { path in
        path.move(to: Self.hinge)
        path.addLine(
          to: CGPoint(
            x: Self.hinge.x + cos(radians) * Self.length,
            y: Self.hinge.y - sin(radians) * Self.length))
      }
      .stroke(Color.secondary.opacity(0.55), style: StrokeStyle(lineWidth: 1.5, dash: [3, 4]))
      Text(verbatim: degrees(angle))
        .font(.system(size: 10, weight: .medium).monospacedDigit())
        .foregroundStyle(.secondary)
        .fixedSize()
        .position(tip)
    }
    .frame(width: 200, height: 116, alignment: .topLeading)
  }
}
