# ndsl — Design Handover

Brief for the design pass ("claude design"). The app is functionally complete and
verified on both platforms; nothing here changes business logic. This doc is the
contract for what you may restyle, what is fixed, and what to deliver.

## What ndsl is

A single-screen daily habit tracker. The user keeps a short list of habits; each
one is checked off during the day; at **midnight everything unchecks**. If the day
ended with every habit done, `streak` increments; a missed day resets it to 0.
The **home-screen widget is the core feature** — the app itself is mostly the
management surface. The emotional core of the product is the streak number the
user doesn't want to break.

## Scope of the design pass

**Restyle only.** Keep the existing structure and interaction model. Within that:

- ✅ Full freedom over color, typography, spacing, shape, iconography, elevation.
- ✅ Animations and transitions are welcome (list check-off, streak increment,
  dialog entrances, the all-done moment).
- ✅ Small behavior changes are allowed when they serve the design (e.g. haptics,
  a slightly different celebration reveal) — flag each one explicitly.
- ❌ No new screens, navigation, settings, onboarding, or features.
- ❌ No un-complete affordance — completion is deliberately one-way (done
  checkboxes are disabled).
- ❌ No renaming — the product is "ndsl" (wordmark treatment is yours, see
  Branding).
- ❌ Don't touch `lib/data/`, `lib/domain/`, `lib/presentation/todo_cubit.dart`,
  `lib/bootstrap.dart`, or any Kotlin/Swift outside the widget view layer.

## Surfaces to design (all of them, light + dark)

Both themes must follow the **system** light/dark setting — app and widgets. One
shared visual identity across iOS and Android (Material 3 as the Flutter base);
no platform-adaptive split.

### 1. Flutter app — `lib/presentation/todo_screen.dart`, `lib/main.dart`

Current structure (keep it; restyle it):

- **AppBar** showing `Streak: N` — the streak display can become a hero element
  visually, but stays on this single screen.
- **List** of habits: checkbox + name per row. Completed rows have a disabled
  checkbox (no unchecking). Long-press a row → delete confirmation dialog.
- **FAB** → "New habit" dialog: autofocused text field, Cancel/Add.
- **Delete dialog**: `Delete "name"?`, No/Yes.
- **All-done state**: when every habit is checked, this is the emotional peak of
  the day — the streak just incremented. Design the moment (see Celebration).
- **Empty state** (no habits yet): currently a blank list. Design an in-app
  empty state that nudges toward the + button. *App only* — do NOT redesign the
  widget for the empty case (it intentionally falls through to the big-number
  state).

`MaterialApp` currently has no theme at all — you own `ThemeData` (Material 3),
fonts, the works. New font = bundle the asset. Any new pub.dev package must be
null-safe and support both iOS and Android — verify before adding.

### 2. Android widget — `android/app/src/main/res/layout/ndsl_widget.xml`, `ndsl_widget_item.xml`, styled from `NdslWidgetProvider.kt`

Two states:

- **Items pending**: list of uncompleted habits (each row tappable → completes
  it) + small streak indicator in a corner.
- **All done**: big centered streak number; tapping anywhere opens the app.

**RemoteViews constraints — hard limits, don't propose past them:**

- No custom fonts. System font only (weights/sizes via `textStyle`/`textSize`).
- No blur, no gradients beyond XML `<shape>` drawables, no arbitrary
  compositing. Backgrounds = color or shape drawable.
- View set is limited: `TextView`, `ImageView`, `LinearLayout`, `FrameLayout`,
  `ProgressBar` and friends. No custom views.
- Item rows are added **programmatically** (`RemoteViews.addView`) from
  `NdslWidgetProvider.kt` — per-row styling happens in Kotlin (`setTextColor`,
  etc.). The `"○  "` prefix on each row is set in code and is fully yours to
  change (any glyph, or an `ImageView` icon per row).
- Day/night theming via `res/values-night/` color resources.
- Android 12+ auto-clips widgets to system corner radius; target cell is 3×2
  (~180×110dp min). Show as many rows as fit — there is no scrolling.

### 3. iOS widget — `ios/NdslWidget/NdslWidget.swift` (SwiftUI, iOS 17+)

Same two states as Android. Near-full SwiftUI freedom: custom fonts (bundle
into the extension target), gradients, SF Symbols, animations on state change.
Constraints:

- `containerBackground(for: .widget)` is mandatory.
- Item rows are `Button(intent:)` (AppIntents) — keep them buttons.
- Currently caps at **4 visible items** (`prefix(4)`) for the medium family;
  adjust per family if you constrain `supportedFamilies` (today all families
  are enabled; medium is the primary target — match Android's 3×2 feel).
- The timeline **pre-renders midnight**: at 00:00 the widget shows all items
  unchecked without the app running, and after a further untouched day it shows
  streak 0. Your design must look right in those auto-rendered states too.

### 4. Branding

Each style proposal includes:

- A **launcher icon** concept (it sits on the home screen next to the widget —
  same identity).
- The **"ndsl" wordmark**: casing and type treatment. The name itself is fixed.

## Data available to the widgets

Written by the app via `lib/data/widget_state_writer.dart`:

| Key | Type | Meaning |
|---|---|---|
| `streak` | int | current streak |
| `uncompleted` | JSON `[{id, name}]` | today's remaining habits |
| `allTodos` | JSON `[{id, name}]` | full list (used for the iOS midnight entry) |
| `afterMidnightStreak` | int | precomputed streak for the iOS midnight entry |

If a design needs more (e.g. completed count for a progress ring), that's a
small allowed contract change — flag it in the proposal.

## UX facts that should inform the design

- **Widget tap latency**: tapping an item runs Dart headlessly; the widget
  redraws ~1–5s later. There is no spinner mechanism on Android — the design
  should tolerate a beat of staleness (avoid anything that implies instant
  response).
- The all-done widget tap opens the app; item taps never open the app.
- Streak resets to 0 on a missed day — the design shouldn't make a `0` look
  like an error state; it's the starting line.
- Accessibility baseline: ≥48dp/44pt touch targets, WCAG AA contrast in both
  themes, survives large dynamic type in-app.

## The three style proposals

Build **three distinct directions**, one per mood (chosen by Sandro):

1. **Calm minimal** — Things 3 / iA Writer territory: generous whitespace, muted
   palette, one accent, quiet typography, subtle motion. The streak feels
   earned, not shouted.
2. **Warm cozy** — soft gradients (in-app; XML-shape gradients on the Android
   widget), warm neutrals, rounded corners, gentle encouraging tone. No mascot.
3. **Playful gamified** — Duolingo / Streaks territory: saturated color, big
   rounded shapes, bouncy motion, an unmistakable celebration.

Rules for the proposals:

- **Palette is fully each direction's call** — no color constraints; make the
  three genuinely divergent.
- **Celebration intensity is per-style**: calm gets a quiet count-up; playful
  can go confetti + haptics. The all-done moment is part of what's being judged.
- Every proposal must respect the Android RemoteViews limits in its widget
  mockups — no un-buildable Android widgets.

### Deliverable for the proposal round

**Static visual mockups** (an HTML page or images — side-by-side comparable),
per style:

- Main screen: list state (mixed done/undone) + all-done state
- "New habit" dialog
- In-app empty state
- Widget: items-pending state + all-done big-number state (Android-feasible
  rendering)
- Launcher icon + wordmark
- Everything in **both light and dark**

No Flutter/Swift/Kotlin implementation in this round.

### Process

1. Deliver the 3 mockup sets → Sandro picks a winner (possibly with tweaks).
2. Implement the winner across the Flutter app, Android widget, and iOS widget.
3. Verify on simulator/emulator — see `.claude/skills/verify/SKILL.md` for the
   build/launch/drive recipes for both platforms (including widget-specific
   gotchas).

## Repo notes

- Not a git repository (deliberate — do not `git init`).
- Tests: `flutter test` (44 green). Design changes shouldn't break them; the
  widget-data contract has tests in `test/data/widget_state_writer_test.dart`.
- `dart run build_runner build` needs `--force-jit` in this environment.
