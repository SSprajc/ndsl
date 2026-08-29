# ndsl

A single-screen daily habit tracker for iOS and Android, built with Flutter.

Keep a short list of habits. Check them off during the day. **At midnight
everything unchecks** — if the day ended with every habit done, the streak
increments; a missed day resets it to zero.

The **home-screen widget is the core feature**. The app itself is mostly the
management surface: you add and remove habits there, but the daily interaction
is meant to happen on the home screen without opening anything.

## Features

- **One screen, no navigation** — habit list, streak, add/delete. That's the app.
- **Home-screen widgets on both platforms**, with two states each:
  - *items pending* — tap a row to complete that habit without opening the app
  - *all done* — a big streak number; tapping opens the app
- **One-way completion** — checking off is deliberate and can't be undone; the
  day's slate is cleared by midnight, not by the user.
- **Automatic midnight rollover** — an Android `AlarmManager` receiver and an
  iOS WidgetKit timeline entry that pre-renders midnight, so the widget shows
  the new day even if the app never runs.
- **System light/dark**, one shared visual identity across both platforms.

## Architecture

Three layers under `lib/`, with the native widget code alongside:

| Layer | Contents |
|---|---|
| `domain/` | `Todo`, and the streak rules (`rollover`, `allDone`) as pure date-only functions |
| `data/` | Drift/SQLite database, `TodoRepository`, and `WidgetStateWriter` |
| `presentation/` | `TodoCubit` + `TodoState` (flutter_bloc), the screen, and its widgets |
| `theme/` | `ThemeData` (Material 3), light and dark |

Key packages: [`drift`](https://pub.dev/packages/drift) for persistence,
[`flutter_bloc`](https://pub.dev/packages/flutter_bloc) for state, and
[`home_widget`](https://pub.dev/packages/home_widget) to bridge Dart to the
native widgets.

Native sources:

- `android/app/src/main/kotlin/com/example/ndsl/` — `NdslWidgetProvider.kt`
  (RemoteViews, rows added programmatically), `MidnightAlarm.kt`
- `ios/NdslWidget/NdslWidget.swift` — SwiftUI widget (iOS 17+), rows are
  `Button(intent:)` AppIntents

### Widget data contract

The app writes these keys via `lib/data/widget_state_writer.dart`; both native
widgets read them. On iOS they live in the `group.com.example.ndsl` App Group.

| Key | Type | Meaning |
|---|---|---|
| `streak` | int | current streak |
| `uncompleted` | JSON `[{id, name}]` | today's remaining habits |
| `allTodos` | JSON `[{id, name}]` | full list, for the iOS midnight entry |
| `afterMidnightStreak` | int | precomputed streak for the iOS midnight entry |

Tapping a widget row runs Dart headlessly and the widget redraws roughly 1–5
seconds later — there's no spinner mechanism, so the UI is designed to tolerate
a beat of staleness.

### The iOS database lives in the App Group

The widget extension reads the same SQLite file as the app, so on iOS the
database is stored in the shared App Group container rather than Documents.
`lib/bootstrap.dart` migrates it (with its WAL sidecars) on first launch.

## Getting started

Requires Flutter **3.38.x** (Dart SDK `^3.10.3`). Verified on iOS Simulator and
an Android emulator.

```bash
flutter pub get
flutter run
```

Bundle id / application id: `com.example.ndsl`.

### Code generation

Drift generates `lib/data/database.g.dart`:

```bash
dart run build_runner build --force-jit
```

`--force-jit` is required — the AOT builder fails to compile against sqlite3's
native-asset hooks.

### Launcher icons

Icon sources live in `assets/icon/` and are rendered by
`test/generate_widget_assets.dart`. Regenerate the platform icon sets with:

```bash
dart run flutter_launcher_icons
```

### Tests

```bash
flutter test
```

Covers the streak rules, the repository, the widget state writer, the cubit,
and the database bootstrap/migration.

## Design

The visual design was produced as a separate pass against a written brief:

- `DESIGN_HANDOVER.md` — the brief: what was open to restyling, what was fixed,
  and the platform constraints (RemoteViews limits, WidgetKit rules)
- `design/` — tokens, exported assets, and the final UI canvases

The shipped direction is the playful one: Fredoka as the type family, a mascot
that reacts to progress, and gradient accents.

## Notes and limits

- Completion is one-way by design — there is no un-check affordance.
- A streak of `0` is a starting line, not an error state.
- Android widgets can't scroll: the layout shows as many rows as fit the cell.
- The iOS widget currently caps at 4 visible items for the medium family.
