import AppIntents
import SwiftUI
import WidgetKit

let appGroupId = "group.com.example.ndsl"

// MARK: - Palette (from design/tokens.md, light values; widgets use the system font)

extension Color {
  init(hex: UInt32) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xff) / 255,
      green: Double((hex >> 8) & 0xff) / 255,
      blue: Double(hex & 0xff) / 255)
  }
}

enum Pal {
  static let surface = Color(hex: 0xFFFFFF)
  static let surfaceAlt = Color(hex: 0xECE9FB)
  static let text = Color(hex: 0x201B3A)
  static let secondary = Color(hex: 0x7965F0)
  static let gradA = Color(hex: 0xFF7C30)
  static let gradB = Color(hex: 0xF53B4B)
  static let primaryGradient = LinearGradient(
    colors: [gradA, gradB], startPoint: .topLeading, endPoint: .bottomTrailing)
}

// MARK: - Mascot (ported from design/assets/mascot_*.svg, 215×195 space)

struct MascotView: View {
  enum Pose { case peek, cheer }
  let pose: Pose
  var white = false
  let m: CGFloat

  var body: some View {
    Canvas { context, size in draw(context, size) }
      .frame(width: 2.15 * m, height: 1.95 * m)
  }

  private var gradA: Color { white ? Color(hex: 0xFFFFFF) : Pal.gradA }
  private var gradB: Color { white ? Color(hex: 0xFFE3D4) : Pal.gradB }
  private var limb: Color { white ? Color(hex: 0xFFCAA0) : Color(hex: 0xFB5B40) }
  private var dot1: Color { white ? Color(hex: 0xFFCAA0) : Pal.secondary }

  // (x, y, w, h, deg, cx, cy)
  private var arms: [(CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat)] {
    switch pose {
    case .peek: return [(47.5, 63.5, 62, 15, 162, 47.5, 71), (167.5, 47.5, 66, 15, -34, 167.5, 55)]
    case .cheer: return [(47.5, 39.5, 66, 15, 232, 47.5, 47), (167.5, 39.5, 66, 15, -52, 167.5, 47)]
    }
  }

  private func rotatedRect(
    _ ctx: GraphicsContext, _ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat,
    _ r: CGFloat, _ deg: CGFloat, _ cx: CGFloat, _ cy: CGFloat, _ shading: GraphicsContext.Shading
  ) {
    var c = ctx
    c.translateBy(x: cx, y: cy)
    c.rotate(by: .degrees(deg))
    c.translateBy(x: -cx, y: -cy)
    c.fill(Path(roundedRect: CGRect(x: x, y: y, width: w, height: h), cornerRadius: r), with: shading)
  }

  private func draw(_ context: GraphicsContext, _ size: CGSize) {
    var c = context
    c.scaleBy(x: size.width / 215, y: size.height / 195)
    let limbFill = GraphicsContext.Shading.color(limb)

    // Arms + legs (behind the body).
    for a in arms { rotatedRect(c, a.0, a.1, a.2, a.3, 7.5, a.4, a.5, a.6, limbFill) }
    rotatedRect(c, 65.5, 143, 16, 66, 8, 20, 65.5, 143, limbFill)
    rotatedRect(c, 133.5, 143, 16, 72, 8, -24, 133.5, 143, limbFill)

    // Binder rings.
    for x in [78.7, 117.3] as [CGFloat] {
      c.stroke(
        Path(roundedRect: CGRect(x: x, y: 25, width: 19, height: 30), cornerRadius: 9.5),
        with: limbFill, lineWidth: 6)
    }

    // Body (gradient calendar card).
    let body = CGRect(x: 47.5, y: 45, width: 120, height: 100)
    c.fill(
      Path(roundedRect: body, cornerRadius: 20),
      with: .linearGradient(
        Gradient(colors: [gradA, gradB]),
        startPoint: CGPoint(x: body.minX, y: body.minY),
        endPoint: CGPoint(x: body.maxX, y: body.maxY)))

    // Header strip + calendar dots.
    c.fill(
      Path(roundedRect: CGRect(x: 57.5, y: 54, width: 100, height: 16), cornerRadius: 8),
      with: .color(.white.opacity(0.92)))
    let dots: [(CGFloat, Color)] = [(92.5, dot1), (107.5, Color(hex: 0xC8C2E0)), (122.5, Color(hex: 0xC8C2E0))]
    for (dx, color) in dots {
      c.fill(Path(ellipseIn: CGRect(x: dx - 3.5, y: 58.5, width: 7, height: 7)), with: .color(color))
    }

    // Face screen.
    c.fill(
      Path(roundedRect: CGRect(x: 57.5, y: 77, width: 100, height: 59), cornerRadius: 14),
      with: .color(Color(hex: 0x1B1630)))

    // Left eye (open ring) + right eye (wink) + smile.
    c.stroke(
      Path(ellipseIn: CGRect(x: 88 - 9.3, y: 103 - 9.3, width: 18.6, height: 18.6)),
      with: .color(.white), lineWidth: 7.5)
    var wink = Path()
    wink.move(to: CGPoint(x: 114, y: 103))
    wink.addQuadCurve(to: CGPoint(x: 140, y: 103), control: CGPoint(x: 127, y: 77))
    c.stroke(wink, with: .color(.white), style: StrokeStyle(lineWidth: 7.5, lineCap: .round))
    var smile = Path()
    smile.move(to: CGPoint(x: 95.5, y: 124.2))
    smile.addQuadCurve(to: CGPoint(x: 119.5, y: 124.2), control: CGPoint(x: 107.5, y: 145))
    c.stroke(smile, with: .color(.white), style: StrokeStyle(lineWidth: 6, lineCap: .round))
  }
}

// MARK: - Timeline

struct TodoItem: Identifiable, Decodable {
  let id: Int
  let name: String
}

struct NdslEntry: TimelineEntry {
  let date: Date
  let uncompleted: [TodoItem]
  let streak: Int
}

private func decodeTodos(_ json: String?) -> [TodoItem] {
  guard let data = json?.data(using: .utf8) else { return [] }
  return (try? JSONDecoder().decode([TodoItem].self, from: data)) ?? []
}

struct NdslProvider: TimelineProvider {
  func placeholder(in context: Context) -> NdslEntry {
    NdslEntry(date: .now, uncompleted: [], streak: 0)
  }

  func getSnapshot(in context: Context, completion: @escaping (NdslEntry) -> Void) {
    completion(currentEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<NdslEntry>) -> Void) {
    let defaults = UserDefaults(suiteName: appGroupId)
    let all = decodeTodos(defaults?.string(forKey: "allTodos"))
    let afterMidnightStreak = defaults?.integer(forKey: "afterMidnightStreak") ?? 0
    let calendar = Calendar.current
    let midnight = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: .now)!)
    let dayAfter = calendar.date(byAdding: .day, value: 1, to: midnight)!

    let timeline = Timeline(
      entries: [
        currentEntry(),
        // At midnight everything resets: all items unchecked; the streak keeps
        // its value only if today ended fully done (precomputed in Dart).
        NdslEntry(date: midnight, uncompleted: all, streak: afterMidnightStreak),
        // A further full day without any interaction means the streak is dead.
        NdslEntry(date: dayAfter, uncompleted: all, streak: 0),
      ], policy: .atEnd)
    completion(timeline)
  }

  private func currentEntry() -> NdslEntry {
    let defaults = UserDefaults(suiteName: appGroupId)
    return NdslEntry(
      date: .now,
      uncompleted: decodeTodos(defaults?.string(forKey: "uncompleted")),
      streak: defaults?.integer(forKey: "streak") ?? 0
    )
  }
}

// MARK: - Views

struct NdslWidgetView: View {
  var entry: NdslEntry

  var body: some View {
    Group {
      if entry.uncompleted.isEmpty { allDone } else { pending }
    }
    .containerBackground(for: .widget) {
      if entry.uncompleted.isEmpty { Pal.primaryGradient } else { Pal.surfaceAlt }
    }
  }

  private var streakPill: some View {
    HStack(spacing: 3) {
      Text("\(entry.streak)")
      Text("🔥")
    }
    .font(.system(size: 12, weight: .bold))
    .foregroundStyle(.white)
    .padding(.horizontal, 8)
    .padding(.vertical, 3)
    .background(Capsule().fill(Pal.primaryGradient))
  }

  private var pending: some View {
    ZStack(alignment: .bottomTrailing) {
      RoundedRectangle(cornerRadius: 22).fill(Pal.surface)
      VStack(alignment: .leading, spacing: 5) {
        HStack {
          Spacer()
          streakPill
        }
        // ponytail: 3 rows is what a medium widget fits with the mascot.
        ForEach(entry.uncompleted.prefix(3)) { item in
          Button(
            intent: BackgroundIntent(url: URL(string: "ndsl://complete?id=\(item.id)"), appGroup: appGroupId)
          ) {
            HStack(spacing: 8) {
              Circle().strokeBorder(Pal.secondary, lineWidth: 2.5).frame(width: 14, height: 14)
              Text(item.name).font(.system(size: 13.5, weight: .medium)).foregroundStyle(Pal.text).lineLimit(1)
            }
          }
          .buttonStyle(.plain)
        }
        Spacer(minLength: 0)
      }
      .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
      MascotView(pose: .peek, m: 21).padding(8)
    }
  }

  private var allDone: some View {
    VStack(alignment: .leading, spacing: 2) {
      Spacer(minLength: 0)
      HStack(alignment: .bottom, spacing: 8) {
        VStack(alignment: .leading, spacing: 0) {
          Text("\(entry.streak)").font(.system(size: 56, weight: .bold)).foregroundStyle(.white)
          Text("🔥 all done!").font(.system(size: 13.5, weight: .semibold)).foregroundStyle(.white.opacity(0.9))
        }
        Spacer()
        MascotView(pose: .cheer, white: true, m: 50)
      }
    }
    .padding(16)
  }
}

@main
struct NdslWidget: Widget {
  let kind: String = "NdslWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: NdslProvider()) { entry in
      NdslWidgetView(entry: entry)
    }
    .configurationDisplayName("ndsl")
    .description("Today's habits and streak.")
  }
}
