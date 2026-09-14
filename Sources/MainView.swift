import AppKit
import IOKit
import SwiftUI
import UniformTypeIdentifiers

struct MainView: View {
  @ObservedObject var desktop: LiveDesktop
  @ObservedObject var updater: Updater
  @State private var screenRecordingAllowed = CGPreflightScreenCaptureAccess()
  @Environment(\.openWindow) private var openWindow

  var body: some View {
    VStack(spacing: 0) {
      hero
      VStack(spacing: 16) {
        effect
        position
        focus
        PreferencesCard(updater: updater)
        MoreAppsCard()
      }
      .padding(.horizontal, 20)
      footer
    }
    .frame(width: 440)
    .fixedSize()
    .background(Color(nsColor: .windowBackgroundColor).ignoresSafeArea())
    .onAppear { MoreApps.shared.refreshIfStale() }
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
        "power", tint: desktop.isActive ? .green : .gray, title: desktop.statusTitle,
        subtitle: desktop.statusSubtitle
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
          "Folding begins below this angle. Softfold takes it from your lid the first time you turn it on."
      )
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

  private var focus: some View {
    SettingsGroup {
      SettingsRow(
        "camera.aperture", tint: .teal, title: String(localized: "Sharpen when you stop"),
        subtitle: String(localized: "Pause partway and the desktop comes back into focus.")
      ) {
        Toggle(
          "Sharpen when you stop",
          isOn: Binding(get: { desktop.focusesWhenHeld }, set: { desktop.setFocusesWhenHeld($0) })
        )
        .toggleStyle(.switch)
        .labelsHidden()
      }
    }
  }

  private var footer: some View {
    HStack(spacing: 6) {
      Button {
        openWindow(id: "about")
      } label: {
        Text(verbatim: "Softfold \(version)")
      }
      .buttonStyle(.plain)
      .help("About Softfold")
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

  private var version: String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
  }
}

extension LiveDesktop {
  var statusTitle: String {
    if isActive { return String(localized: "On") }
    if isStarting { return String(localized: "Starting…") }
    return isEnabled ? String(localized: "Waiting…") : String(localized: "Off")
  }

  var statusSubtitle: String {
    if isActive { return String(localized: "Your desktop bends as the lid closes.") }
    if isStarting { return String(localized: "Getting the desktop and the sensor ready.") }
    if isWaitingForDisplay {
      return String(localized: "Waiting for the built-in display to turn on.")
    }
    if !sensorAvailable { return String(localized: "Waiting for the lid angle sensor.") }
    if isEnabled { return String(localized: "Softfold is on but not running yet.") }
    return String(localized: "Turn Softfold on to follow the lid.")
  }
}

func degrees(_ value: Double) -> String {
  Measurement(value: value, unit: UnitAngle.degrees).formatted(
    .measurement(width: .narrow, numberFormatStyle: .number.precision(.fractionLength(0))))
}

struct MacLook {
  enum Model {
    case pro14
    case pro16
    case air13
    case air15
  }

  enum Port {
    case magSafe
    case thunderbolt
    case headphone
  }

  struct Chassis {
    let isPro: Bool
    let depth: Double
    let baseHeight: Double
    let lidMetal: Double
    let lidGlass: Double
    let lidCorner: Double
    let curveHeight: Double
    let curveWidth: Double
    let portCenter: Double
    let ports: [(port: Port, center: Double)]
    let feet: [Double]
    let footTop: Double
    let footBottom: Double
    let footHeight: Double
    let vent: ClosedRange<Double>?
    let hingeDrop: Double
    let hingeGap: Double
    let displayHeight: Double
    let topBezel: Double

    var lidThickness: Double { lidMetal + lidGlass }
  }

  let model: Model
  let color: Int

  static let current = detect()
  static let pointsPerCentimeter: CGFloat = 4.6

  var chassis: Chassis {
    switch model {
    case .pro14:
      return Chassis(
        isPro: true, depth: 22.12, baseHeight: 1.11, lidMetal: 0.37, lidGlass: 0.045,
        lidCorner: 0.16, curveHeight: 0.62, curveWidth: 0.9, portCenter: 0.37,
        ports: [(.magSafe, 2.81), (.thunderbolt, 4.63), (.thunderbolt, 6.12), (.headphone, 7.41)],
        feet: [1.716, 18.337], footTop: 2.07, footBottom: 1.79, footHeight: 0.15,
        vent: 9.07...19.48, hingeDrop: 0.70, hingeGap: 0.18,
        displayHeight: 19.64, topBezel: 0.56)
    case .pro16:
      return Chassis(
        isPro: true, depth: 24.81, baseHeight: 1.22, lidMetal: 0.39, lidGlass: 0.07,
        lidCorner: 0.16, curveHeight: 0.62, curveWidth: 0.9, portCenter: 0.375,
        ports: [(.magSafe, 3.58), (.thunderbolt, 5.43), (.thunderbolt, 6.93), (.headphone, 8.21)],
        feet: [1.72, 21.03], footTop: 2.05, footBottom: 1.79, footHeight: 0.15,
        vent: 9.81...22.42, hingeDrop: 0.76, hingeGap: 0.24,
        displayHeight: 22.34, topBezel: 0.54)
    case .air13:
      return Chassis(
        isPro: false, depth: 21.5, baseHeight: 0.74, lidMetal: 0.32, lidGlass: 0.06,
        lidCorner: 0.07, curveHeight: 0.37, curveWidth: 0.45, portCenter: 0.22,
        ports: [(.magSafe, 2.27), (.thunderbolt, 4.14), (.thunderbolt, 5.64)],
        feet: [1.43, 18.02], footTop: 1.98, footBottom: 1.76, footHeight: 0.14,
        vent: nil, hingeDrop: 0.52, hingeGap: 0.09,
        displayHeight: 18.87, topBezel: 0.64)
    case .air15:
      return Chassis(
        isPro: false, depth: 23.76, baseHeight: 0.76, lidMetal: 0.32, lidGlass: 0.06,
        lidCorner: 0.07, curveHeight: 0.37, curveWidth: 0.45, portCenter: 0.21,
        ports: [(.magSafe, 3.30), (.thunderbolt, 5.11), (.thunderbolt, 6.58)],
        feet: [1.49, 20.22], footTop: 2.00, footBottom: 1.80, footHeight: 0.14,
        vent: nil, hingeDrop: 0.52, hingeGap: 0.09,
        displayHeight: 21.14, topBezel: 0.68)
    }
  }

  var finish: (red: Double, green: Double, blue: Double) {
    let isPro = model == .pro14 || model == .pro16
    let hex: UInt32
    switch color {
    case 2 where isPro: hex = 0xBCBCBF
    case 2: hex = 0xB0B0B3
    case 7: hex = 0x59626F
    case 8: hex = 0xE9E2D8
    case 9: hex = 0x555257
    case 11: hex = 0xCCD8DF
    default: hex = 0xDFE0E2
    }
    return (
      Double((hex >> 16) & 0xFF) / 255, Double((hex >> 8) & 0xFF) / 255, Double(hex & 0xFF) / 255
    )
  }

  func shade(_ factor: Double) -> Color {
    let base = finish
    return Color(
      .sRGB, red: min(base.red * factor, 1), green: min(base.green * factor, 1),
      blue: min(base.blue * factor, 1))
  }

  func gradient(_ stops: [(Double, Double)]) -> Gradient {
    Gradient(stops: stops.map { Gradient.Stop(color: shade($0.1), location: $0.0) })
  }

  var baseShading: Gradient {
    chassis.isPro
      ? gradient([
        (0, 1.02), (0.2, 0.99), (0.35, 0.95), (0.5, 0.82), (0.62, 0.63), (0.74, 0.5), (0.8, 0.52),
        (0.88, 0.66), (0.92, 0.7), (0.96, 0.55), (1, 0.25),
      ])
      : gradient([
        (0, 1.12), (0.03, 1.0), (0.29, 1.0), (0.64, 0.6), (0.91, 0.9), (0.96, 0.84), (1, 0.6),
      ])
  }

  var endShading: [(Double, Double)] {
    chassis.isPro
      ? [
        (0, 0.7), (0.11, 0.66), (0.33, 1.05), (0.5, 0.82), (0.72, 0.56), (1.0, 0.64), (1.6, 0.75),
        (3.0, 0.9), (5.0, 1.0),
      ]
      : [(0, 0.8), (0.04, 0.75), (0.18, 1.16), (0.26, 1.06), (0.53, 0.74), (1.0, 0.92), (1.4, 1.0)]
  }

  var lidShading: Gradient {
    chassis.isPro
      ? gradient([(0, 0.56), (0.05, 1.13), (0.15, 1.0), (1, 1.0)])
      : gradient([(0, 1.0), (0.05, 1.15), (0.2, 1.0), (1, 1.0)])
  }

  private static func detect() -> MacLook {
    let model = hardwareModel()
    let color = housingColor() ?? 1
    let deviceModel = UTTagClass(rawValue: "com.apple.device-model-code")
    let identifier =
      UTType(tag: "\(model)@ECOLOR=\(color)", tagClass: deviceModel, conformingTo: nil)?.identifier
      ?? ""
    let kind: Model
    if identifier.contains("macbookair-15") {
      kind = .air15
    } else if identifier.contains("macbookair") || model.hasPrefix("MacBookAir") {
      kind = .air13
    } else if identifier.contains("macbookpro-16") {
      kind = .pro16
    } else {
      kind = .pro14
    }
    return MacLook(model: kind, color: color)
  }

  private static func hardwareModel() -> String {
    var size = 0
    sysctlbyname("hw.model", nil, &size, nil, 0)
    var buffer = [CChar](repeating: 0, count: size)
    sysctlbyname("hw.model", &buffer, &size, nil, 0)
    return String(cString: buffer)
  }

  private static func housingColor() -> Int? {
    let entry = IORegistryEntryFromPath(kIOMainPortDefault, "IODeviceTree:/chosen")
    guard entry != 0 else { return nil }
    defer { IOObjectRelease(entry) }
    guard
      let data = IORegistryEntryCreateCFProperty(
        entry, "housing-color" as CFString, kCFAllocatorDefault, 0)?
        .takeRetainedValue() as? Data,
      data.count >= 4
    else { return nil }
    let value = data.suffix(4).withUnsafeBytes { $0.loadUnaligned(as: UInt32.self) }
    return Int(value)
  }
}

struct LidPicture: View {
  @ObservedObject var lid: LidReading
  let openAngle: Double
  let active: Bool
  let available: Bool
  var look = MacLook.current

  private static let hinge = CGPoint(x: 46, y: 102)

  private func points(_ centimeters: Double) -> CGFloat {
    CGFloat(centimeters) * MacLook.pointsPerCentimeter
  }

  private var length: CGFloat { points(look.chassis.depth) }
  private var baseHeight: CGFloat { points(look.chassis.baseHeight) }
  private var lidThickness: CGFloat { points(look.chassis.lidThickness) }
  private var hingeDrop: CGFloat { points(look.chassis.hingeDrop) }
  private var hingeGap: CGFloat { points(look.chassis.hingeGap) }
  private var pivot: CGPoint {
    CGPoint(x: (hingeDrop - hingeGap) / 2, y: (hingeDrop + hingeGap) / 2)
  }

  var body: some View {
    let live = available ? lid.degrees : nil
    let angle = min(max(live ?? openAngle, 0), 180)
    ZStack(alignment: .topLeading) {
      Ellipse()
        .fill(Color.black.opacity(0.12))
        .frame(width: length + 22, height: 10)
        .blur(radius: 5)
        .offset(x: Self.hinge.x - 11, y: Self.hinge.y + baseHeight)
      guide(angle: openAngle)
      lidBar
        .rotationEffect(
          .degrees(-angle),
          anchor: UnitPoint(
            x: pivot.x / length, y: (lidThickness + pivot.y) / (lidThickness + hingeGap))
        )
        .offset(x: Self.hinge.x, y: Self.hinge.y - lidThickness)
        .opacity(live == nil ? 0.35 : 1)
      base
        .offset(x: Self.hinge.x, y: Self.hinge.y)
    }
    .frame(width: 200, height: 116, alignment: .topLeading)
    .animation(.smooth(duration: 0.2), value: angle)
    .animation(.smooth(duration: 0.4), value: openAngle)
    .animation(.easeInOut(duration: 0.3), value: active)
    .accessibilityElement()
    .accessibilityLabel(Text("Lid angle"))
    .accessibilityValue(Text(verbatim: degrees(angle)))
  }

  private func baseOutline(_ height: CGFloat) -> Path {
    let chassis = look.chassis
    let curveTop = height - points(chassis.curveHeight)
    let width = points(chassis.curveWidth)
    let controlY = curveTop + points(chassis.curveHeight) * 0.58
    let controlX = width * (chassis.isPro ? 0.33 : 0.42)
    var path = Path()
    path.move(to: .zero)
    path.addLine(to: CGPoint(x: length, y: 0))
    path.addLine(to: CGPoint(x: length, y: curveTop))
    path.addCurve(
      to: CGPoint(x: length - width, y: height), control1: CGPoint(x: length, y: controlY),
      control2: CGPoint(x: length - controlX, y: height))
    path.addLine(to: CGPoint(x: width, y: height))
    path.addCurve(
      to: CGPoint(x: 0, y: curveTop), control1: CGPoint(x: controlX, y: height),
      control2: CGPoint(x: 0, y: controlY))
    path.closeSubpath()
    return path
  }

  private func shadeEnds(of shape: Path, in context: inout GraphicsContext) {
    let stops = look.endShading
    let last = stops.last?.0 ?? 1
    let reach = points(last)
    let darken = Gradient(
      stops: stops.map { Gradient.Stop(color: Color(white: min($0.1, 1)), location: $0.0 / last) })
    let finish = look.finish
    let lighten = Gradient(
      stops: stops.map { stop in
        let lift = { (channel: Double) in max(min(channel * stop.1, 1) - channel, 0) }
        return Gradient.Stop(
          color: Color(
            .sRGB, red: lift(finish.red), green: lift(finish.green), blue: lift(finish.blue)),
          location: stop.0 / last)
      })
    for fromRear in [true, false] {
      let start = CGPoint(x: fromRear ? 0 : length, y: 0)
      let end = CGPoint(x: fromRear ? reach : length - reach, y: 0)
      let band = Path(CGRect(x: fromRear ? 0 : length - reach, y: -1, width: reach, height: 400))
      var multiply = context
      multiply.clip(to: shape)
      multiply.blendMode = .multiply
      multiply.fill(band, with: .linearGradient(darken, startPoint: start, endPoint: end))
      var add = context
      add.clip(to: shape)
      add.blendMode = .plusLighter
      add.fill(band, with: .linearGradient(lighten, startPoint: start, endPoint: end))
    }
  }

  private var base: some View {
    let chassis = look.chassis
    let height = baseHeight
    let footHeight = points(chassis.footHeight)
    return Canvas { context, _ in
      for start in chassis.feet {
        let top = points(chassis.footTop)
        let bottom = points(chassis.footBottom)
        let inset = (top - bottom) / 2
        let x = points(start)
        var foot = Path()
        foot.move(to: CGPoint(x: x, y: height - 1))
        foot.addLine(to: CGPoint(x: x + top, y: height - 1))
        foot.addLine(to: CGPoint(x: x + top - inset, y: height + footHeight))
        foot.addLine(to: CGPoint(x: x + inset, y: height + footHeight))
        foot.closeSubpath()
        context.fill(
          foot,
          with: .linearGradient(
            Gradient(colors: [Color(white: 0.42), Color(white: 0.16), Color(white: 0.1)]),
            startPoint: CGPoint(x: 0, y: height), endPoint: CGPoint(x: 0, y: height + footHeight)))
      }
      let outline = baseOutline(height)
      context.fill(
        outline,
        with: .linearGradient(
          look.baseShading, startPoint: .zero, endPoint: CGPoint(x: 0, y: height)))
      shadeEnds(of: outline, in: &context)
      context.drawLayer { layer in
        layer.clip(to: outline)
        if let vent = chassis.vent {
          let slot = CGRect(
            x: points(vent.lowerBound), y: height * 0.84,
            width: points(vent.upperBound - vent.lowerBound), height: height * 0.07)
          layer.fill(
            Path(roundedRect: slot, cornerRadius: slot.height / 2),
            with: .color(Color.black.opacity(0.55)))
          layer.fill(
            Path(
              CGRect(
                x: slot.minX + slot.height, y: slot.maxY, width: slot.width - slot.height * 2,
                height: 0.5)),
            with: .color(Color.white.opacity(0.18)))
        }
        for item in chassis.ports {
          drawPort(item.port, at: points(item.center), in: &layer)
        }
      }
      context.stroke(outline, with: .color(Color.primary.opacity(0.14)), lineWidth: 0.5)
    }
    .frame(width: length, height: height + footHeight + 1, alignment: .topLeading)
  }

  private func drawPort(_ port: MacLook.Port, at center: CGFloat, in context: inout GraphicsContext)
  {
    let chassis = look.chassis
    let y = points(chassis.portCenter)
    let rim = look.shade(chassis.isPro ? 1.35 : 1.2)
    switch port {
    case .magSafe:
      let outer = CGRect(
        x: center - points(0.865), y: y - points(0.16), width: points(1.73), height: points(0.32))
      context.fill(
        Path(roundedRect: outer, cornerRadius: outer.height / 2),
        with: .color(look.shade(chassis.isPro ? 0.82 : 0.86)))
      context.stroke(
        Path(roundedRect: outer, cornerRadius: outer.height / 2), with: .color(rim),
        lineWidth: 0.35)
      let strip = CGRect(
        x: center - points(0.53), y: y - points(0.06), width: points(1.06), height: points(0.12))
      context.fill(
        Path(roundedRect: strip, cornerRadius: strip.height / 2),
        with: .color(chassis.isPro ? Color(white: 0.05) : Color(red: 0.85, green: 0.86, blue: 0.87))
      )
      for index in 0..<5 {
        let pinX = center + points(0.187 * Double(index - 2))
        let pin = CGRect(
          x: pinX - points(0.018), y: y - points(0.018), width: points(0.036),
          height: points(0.036))
        context.fill(
          Path(ellipseIn: pin),
          with: .color(
            chassis.isPro ? Color(white: 0.62) : Color(red: 0.55, green: 0.5, blue: 0.46)))
      }
    case .thunderbolt:
      let outer = CGRect(
        x: center - points(0.42), y: y - points(0.1325), width: points(0.84),
        height: points(0.265))
      context.fill(
        Path(roundedRect: outer, cornerRadius: outer.height / 2),
        with: .color(chassis.isPro ? Color(white: 0.04) : Color(red: 0.11, green: 0.13, blue: 0.17))
      )
      context.stroke(
        Path(roundedRect: outer, cornerRadius: outer.height / 2), with: .color(look.shade(0.6)),
        lineWidth: 0.3)
      let tongue = CGRect(
        x: center - points(0.305), y: y - points(0.03), width: points(0.61), height: points(0.06))
      context.fill(
        Path(roundedRect: tongue, cornerRadius: tongue.height / 2),
        with: .color(chassis.isPro ? Color(white: 0.24) : Color(red: 0.45, green: 0.49, blue: 0.54))
      )
    case .headphone:
      let hole = CGRect(
        x: center - points(0.185), y: y - points(0.185), width: points(0.37), height: points(0.37))
      context.fill(Path(ellipseIn: hole), with: .color(Color(white: 0.03)))
      context.stroke(Path(ellipseIn: hole), with: .color(look.shade(0.6)), lineWidth: 0.3)
    }
  }

  private var lidBar: some View {
    let chassis = look.chassis
    let metal = points(chassis.lidMetal)
    let glass = points(chassis.lidGlass)
    let corner = points(chassis.lidCorner)
    let blockWidth = hingeDrop * 0.44
    return Canvas { context, _ in
      let shell = Path(
        roundedRect: CGRect(x: 0, y: 0, width: length, height: metal + glass),
        cornerRadii: RectangleCornerRadii(
          topLeading: corner, bottomLeading: 0.3, bottomTrailing: 0.3, topTrailing: corner),
        style: .continuous)
      context.fill(
        shell,
        with: .linearGradient(
          look.lidShading, startPoint: .zero, endPoint: CGPoint(x: 0, y: metal + glass)))
      shadeEnds(of: shell, in: &context)
      context.drawLayer { layer in
        layer.clip(to: shell)
        layer.fill(
          Path(CGRect(x: 0, y: metal, width: length, height: glass)),
          with: .color(Color(white: 0.04)))
      }
      context.stroke(shell, with: .color(Color.primary.opacity(0.14)), lineWidth: 0.5)
      context.fill(
        Path(CGRect(x: 0, y: metal + glass, width: blockWidth, height: hingeGap)),
        with: .color(look.shade(0.45)))
    }
    .frame(width: length, height: lidThickness + hingeGap, alignment: .topLeading)
    .overlay(alignment: .topLeading) {
      Rectangle()
        .fill(Color.accentColor)
        .frame(width: points(look.chassis.displayHeight), height: 0.6)
        .shadow(color: Color.accentColor.opacity(0.9), radius: 5)
        .offset(
          x: length - points(look.chassis.topBezel + look.chassis.displayHeight),
          y: lidThickness - 0.6
        )
        .opacity(active ? 1 : 0)
    }
  }

  private func guide(angle: Double) -> some View {
    let radians = CGFloat(angle) * .pi / 180
    let direction = CGVector(dx: cos(radians), dy: -sin(radians))
    let start = CGPoint(
      x: Self.hinge.x + pivot.x - pivot.x * cos(radians) - pivot.y * sin(radians),
      y: Self.hinge.y + pivot.y + pivot.x * sin(radians) - pivot.y * cos(radians))
    let tip = CGPoint(
      x: start.x + direction.dx * (length + 16), y: start.y + direction.dy * (length + 16))
    return ZStack(alignment: .topLeading) {
      Path { path in
        path.move(to: start)
        path.addLine(
          to: CGPoint(x: start.x + direction.dx * length, y: start.y + direction.dy * length))
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
