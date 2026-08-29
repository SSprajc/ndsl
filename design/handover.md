# ndsl — Design Handover

Companion to `tokens.md`. This maps the **Playful gamified** design onto screens,
states, and reusable components, and flags anything web-specific that must be
re-thought for Flutter. Claude Code should **translate** these into widgets — the
HTML in `final_ui/` is a visual reference, not code to port.

Every color / size / radius named below (e.g. `color.primary`, `radius.pill`)
is defined exactly in `tokens.md`.

---

## A. Screens & states

### A1. Habit list (home) — the main screen
Default layout, top → bottom:
1. **Status bar** row (mock only — real app uses the OS status bar).
2. **Streak header** — a 76dp gradient **StreakTile** (number, `type.streak-tile`,
   `shadow.tile`) + title block ("7-day" `type.title` / "streak 🔥" `type.subtitle`
   in `color.primary`) + **Mascot** (`peek`, `m=30`) pinned to the row's right end.
3. **Progress** — 10dp track (`color.line`) with `color.success` fill; width = %
   complete. Label `type.progress-label` in `color.muted`.
4. **Habit rows** (scroll area) — each row = check control + label, vertical
   padding 11.
5. **FAB** — bottom-right, 58dp, `color.primary` gradient, "+", `shadow.fab`.

States:
- **Default (mixed):** completed rows show a filled `color.success` circle with a
  white check + label in `color.muted` weight 500; todo rows show a `color.secondary`
  3dp ring + label in `color.text` weight 600.
- **Empty** (0 habits): streak tile is *flat* `color.surface-alt` (no gradient/shadow),
  number "0", title "Day zero / let's go!". Body shows a 90dp dashed
  `color.secondary` square, "No habits yet!" (`type.empty-title`) + caption. Mascot
  (`point`, `m=48`) points at the FAB, which carries the `motion.ping` ring.
- **All done** (every habit checked): replaces list body with the celebration —
  confetti (`motion.confetti`), Mascot (`cheer`, `m=84`, wrapped in `motion.pop`),
  streak numeral `type.streak-hero` in `color.primary-bright` + "day streak" +
  `+1` badge (`color.success-deep`, pill), "YOU DID IT!" `type.title`, caption.
- **Loading:** (not drawn) — show StreakTile + 4–5 row skeletons at `color.line`
  fill, no progress label; FAB visible, disabled.
- **Error:** (not drawn) — inline card on `color.surface-alt`, text `color.text`,
  retry = text button in `color.primary`. No destructive red in this palette; use
  `color.primary` for the retry affordance.
- **Disabled row** (e.g. mid-sync): label + control at 45% opacity (matches the
  dialog's dimmed-background treatment).

### A2. New-habit dialog
Modal over the list. Background screen dimmed by `color.scrim`; underlying content
also drops to 45% opacity. Card: `color.surface`, `radius.dialog`, padding 24,
`shadow.dialog`.
- Title "New habit!" `type.dialog-title`.
- Input: `color.surface-alt` fill, 2dp `color.secondary` border, `radius.input`,
  text `type.control`; blinking caret (`motion.caret`) in `color.secondary`.
- Actions row: **Cancel** (fill `color.surface-alt`, text `color.muted`) + **Add**
  (`color.primary` gradient, `color.on-primary`), both `radius.button`, flex 1:1,
  gap 10.
- States: *default* (empty input → Add may be disabled at 45%), *typing* (caret),
  *invalid/duplicate* (border → `color.primary`, helper caption in `color.primary`).

### A3. Home-screen widget
Two states, both on a `color.surface-alt` "wall". System font, not Fredoka.
- **Pending:** `color.surface` card, `radius.widget-inner`. Header row: "ndsl"
  wordmark (`type.widget-wordmark`, `color.secondary`) + streak pill (gradient,
  "7 🔥"). Up to 3 unchecked rows (`color.secondary` 14dp rings). Mascot (`peek`,
  `m=21`) tucked in the bottom-right corner.
- **All done:** full-bleed `color.primary` gradient card. "ndsl" in white 90%,
  big "8" (`type.streak-hero`-ish, 56sp) + "🔥 all done!" label, and the **white
  Mascot variant** (`cheer`, `m=50`) beside the number.

### A4. Branding
- **Launcher icon:** 82dp rounded square (`radius.widget-outer`), `color.icon-grad-a
  → color.icon-grad-b` gradient, white "n" (Fredoka 700, 46sp). See
  `assets/app_icon.svg`.
- **Wordmark:** "ndsl" all-lowercase, `type.wordmark`, `color.primary`, tracking
  −0.01em.

---

## B. Component inventory

| Component | Variants / states | Token mapping |
|---|---|---|
| **PrimaryButton** | default, pressed, disabled | fill `color.primary-grad-a→b`, text `color.on-primary`, `radius.button`, `type.control`; disabled = 45% opacity |
| **SecondaryButton** (Cancel) | default, pressed | fill `color.surface-alt`, text `color.muted`, `radius.button` |
| **FAB** | default, pulsing (empty) | 58dp, gradient, `shadow.fab`, "+" 30sp/600; empty adds `motion.ping` ring in `color.primary` |
| **StreakTile** | active, zero | 76dp, `radius.tile`; active = gradient + `shadow.tile` + `color.on-primary`; zero = `color.surface-alt` + `color.primary` numeral |
| **HabitRow** | done, todo, disabled | done = `color.success` filled check + `color.muted` label/500; todo = `color.secondary` ring + `color.text` label/600 |
| **ProgressBar** | 0–100% | track `color.line`, fill `color.success`, 10dp, `radius.progress` |
| **StreakBadge** | "+N" | pill `radius.pill`, `color.success-deep`, `type.badge`, white |
| **SectionLabel** | — | `type.section-label`, uppercase, tracking 0.09em, `color.muted` |
| **Dialog** | default, typing, invalid | card `color.surface` `radius.dialog` `shadow.dialog`; scrim `color.scrim` |
| **TextInput** | default, focus, invalid | `color.surface-alt` fill, 2dp `color.secondary` border, `radius.input`; invalid border `color.primary` |
| **Mascot** | peek / cheer / point, + white variant | see `tokens.md §7`; parametrised by base unit `m` |
| **Widget (glance)** | pending, all-done | system font; see A3 |
| **LauncherIcon** | — | `assets/app_icon.svg` |

---

## C. Motion & interaction

- **Idle mascot** floats continuously (`motion.idle-bob`) on all app surfaces.
  On widgets it is **static** (see D).
- **Check-off:** recommended `motion.pop` @220ms `easeOutBack` on the check
  control; when the last habit flips, transition list → all-done celebration
  (cross-fade ~300ms) and fire confetti + `motion.pop` on the mascot.
- **All-done celebration:** confetti pieces drift/rotate (`motion.confetti`),
  mascot cheer arms wiggle (`motion.cheer-wiggle`) inside a `motion.pop` scale loop.
- **Empty state:** FAB emits the `motion.ping` ring to draw the first tap; mascot
  points at it.
- **Dialog:** slide/scale in from center over the scrim (~250ms easeOut); input
  caret blinks (`motion.caret`). Dismiss on Cancel or scrim tap.
- **Gestures:** tap row = toggle; tap FAB = open dialog; (recommended) swipe row
  left = delete, long-press = edit — not shown in mock, confirm before building.

---

## D. Web-only — must be re-thought for Flutter / native

1. **CSS gradients on widgets.** The widget mocks use CSS `linear-gradient`.
   - iOS WidgetKit: fine (SwiftUI `LinearGradient`).
   - **Android `RemoteViews`: cannot use CSS/arbitrary gradients or custom fonts.**
     Ship the gradient as an XML `<shape><gradient>` drawable, use the **system
     font**, and render the **mascot as a static drawable (PNG/VectorDrawable)** —
     no animation is possible in a home-screen widget. Export the mascot poses from
     `assets/` to drawables.
2. **`position:absolute` layering** (mascot pinned to corners, confetti, FAB ring,
   scrim) → Flutter `Stack` + `Positioned`; the scrim is a `ModalBarrier`.
3. **`calc()`-based mascot geometry** (everything is `× m`) → drive from a single
   `size` parameter in a `CustomPaint`/composed widget. Do **not** hand-place at
   fixed px.
4. **CSS `@keyframes`** (`bob`, `pop`, `wiggle`, `ping`, `caret`, `confetti`) →
   `AnimationController`s. Durations/curves in `tokens.md §8`. Widgets get **none**
   of these.
5. **`box-shadow` with negative spread** → Flutter `BoxShadow(blurRadius, spreadRadius:
   negative)`. FAB/tile shadows are **tinted with `color.primary`**, not black.
6. **Emoji 🔥** renders as the platform emoji font — acceptable and intentional on
   both platforms (system emoji, no custom asset). Keep it out of the launcher icon.
7. **`letter-spacing` in em** (section label 0.09em, wordmark −0.01em) →
   Flutter `letterSpacing` is in **logical px**, so multiply by the font size
   (e.g. 12sp × 0.09 ≈ **1.08px**; 34sp × −0.01 ≈ **−0.34px**).
8. **Mock device frame** (260×540, `radius.screen` 38, status-bar row) is scaffolding
   only — the real app is full-screen. Ignore the outer rounded frame and fake status bar.

---

## E. Files in this handover

- `tokens.md` — all tokens (primary artifact).
- `handover.md` — this file.
- `assets/` — mascot pose vectors, launcher icon, `fonts.md`.
- `final_ui/` — the HTML design artifact (reference only).
