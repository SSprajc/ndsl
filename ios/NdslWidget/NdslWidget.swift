import AppIntents
import SwiftUI
import WidgetKit

let appGroupId = "group.com.example.ndsl"

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

struct NdslWidgetView: View {
  var entry: NdslEntry

  var body: some View {
    Group {
      if entry.uncompleted.isEmpty {
        Text("\(entry.streak)")
          .font(.system(size: 44, weight: .bold))
      } else {
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            Spacer()
            Text("\(entry.streak)")
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          // ponytail: first 4 items only; that's what a medium widget fits.
          ForEach(entry.uncompleted.prefix(4)) { item in
            Button(
              intent: BackgroundIntent(
                url: URL(string: "ndsl://complete?id=\(item.id)"), appGroup: appGroupId)
            ) {
              Label(item.name, systemImage: "circle")
                .font(.callout)
            }
            .buttonStyle(.plain)
          }
          Spacer(minLength: 0)
        }
      }
    }
    .containerBackground(for: .widget) { Color(uiColor: .systemBackground) }
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
