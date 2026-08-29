# ndsl — Design Tokens

Direction: **Playful gamified**. Single source of truth for Claude Code.
Every value below is concrete. Colors are given as hex; the source was authored
in OKLCH and converted to sRGB hex (rounded to 8-bit). Where the design uses a
**gradient**, both stops + angle are given — do not substitute a solid.

> **Coordinate space / scaling.** The mockup phone frame is drawn at
> **260 × 540** logical units. All px values below are in that space and map
> **1:1 to dp**. The phone-frame corner radius (38) is the *mock device bezel*,
> not an app token. When rendering full-screen on a real device, keep the
> component-internal values as-is and let the scaffold fill the screen; only the
> outer screen padding (`space.screen-x = 24`) and the streak header scale with
> width. Nothing here should be guessed.

---

## 1. Color

### 1.1 Light theme (default)

| Token | Hex | Notes / usage |
|---|---|---|
| `color.bg` | `#FAF7FF` | App scaffold background |
| `color.surface` | `#FFFFFF` | Cards, sheets, dialog, list surface |
| `color.surface-alt` | `#ECE9FB` | "wall" — widget backdrop, dialog input fill, cancel button, empty streak tile |
| `color.text` | `#201B3A` | Primary text / headings |
| `color.muted` | `#8A86AD` | Secondary text, captions, section labels, status bar |
| `color.line` | `#ECE9F7` | Hairline borders, progress track |
| `color.primary` | `#FB5B40` | Primary accent (solid) — streak label, icons, ping ring |
| `color.primary-bright` | `#FF643C` | Brighter accent used for large streak numerals |
| `color.primary-grad-a` | `#FF7C30` | FAB / primary button gradient **start** |
| `color.primary-grad-b` | `#F53B4B` | FAB / primary button gradient **end** (135°) |
| `color.success` | `#22C273` | Completed-check fill, progress fill |
| `color.success-deep` | `#20B46B` | "+1" streak badge fill |
| `color.secondary` | `#7965F0` | Purple — unchecked rings, dialog input border, caret, wordmark |
| `color.on-primary` | `#FFFFFF` | Text/icon on primary & gradient |
| `color.scrim` | `#1E143C` @ 40% | Modal scrim behind dialog |

### 1.2 Dark theme

| Token | Hex | Notes |
|---|---|---|
| `color.bg` | `#12101D` | |
| `color.surface` | `#201C30` | |
| `color.surface-alt` | `#0C0A16` | widget backdrop / wall |
| `color.text` | `#F4F2FF` | |
| `color.muted` | `#9D98C2` | |
| `color.line` | `#322C48` | |
| `color.primary` | `#FF7438` | |
| `color.primary-grad-a` | `#FF8238` | gradient start |
| `color.primary-grad-b` | `#FC4351` | gradient end (135°) |
| `color.success` | `#3EC87D` | |
| `color.secondary` | `#9588FF` | |
| `color.on-primary` | `#FFFFFF` | |
| `color.scrim` | `#000000` @ 55% | |

### 1.3 Brand / fixed (theme-independent)

| Token | Value | Usage |
|---|---|---|
| `color.icon-grad-a` | `#FF6D31` | Launcher icon gradient start (135°) |
| `color.icon-grad-b` | `#E62845` | Launcher icon gradient end |
| `color.mascot-face` | `#1B1630` | Mascot dark "screen" face |
| `color.mascot-limb` | = `color.primary` | Arms, legs, binder rings |
| `color.mascot-header-dot-active` | = `color.secondary` | First calendar-header dot |
| `color.mascot-header-dot-idle` | `#C8C2E0` | Remaining header dots |

---

## 2. Spacing scale (dp)

Base rhythm is loosely 2/4. Named steps:

| Token | dp |
|---|---|
| `space.2` | 2 |
| `space.4` | 4 |
| `space.6` | 6 |
| `space.8` | 8 |
| `space.10` | 10 |
| `space.12` | 12 |
| `space.14` | 14 |
| `space.16` | 16 |
| `space.18` | 18 |
| `space.20` | 20 |
| `space.24` | 24 |
| `space.26` | 26 |
| `space.30` | 30 |
| `space.38` | 38 |

Applied constants:
- `space.screen-x` = **24** (screen horizontal padding)
- Streak header block padding = `18 24 6`
- List row vertical padding = **11**, horizontal **10**; row gap (icon↔label) = **14**
- Dialog padding = **24**; dialog button gap = **10**
- Widget card padding = **14 16**; widget row vertical padding = **5**
- Inter-card gap on boards = **26** (mockup only)

---

## 3. Type scale

**Family:** `Fredoka` (rounded geometric sans). Weights used: **400, 500, 600, 700**.
Fallback stack: `Fredoka, "SF Pro Rounded", "Nunito", system-ui, sans-serif`.
Widget text falls back to the **system font** (`system-ui / Roboto`) — see handover.

| Token | Size (sp) | Weight | Line-height | Role |
|---|---|---|---|---|
| `type.streak-hero` | 62 | 700 | 1.0 | All-done big streak numeral |
| `type.streak-tile` | 40 | 700 | 1.0 | Number inside 76dp streak tile |
| `type.title` | 26 | 700 | 1.0 | Screen title ("7-day") |
| `type.dialog-title` | 24 | 700 | 1.1 | "New habit!" |
| `type.empty-title` | 23 | 700 | 1.1 | "No habits yet!" |
| `type.subtitle` | 16 | 600 | 1.2 | Streak label ("streak 🔥", "let's go!") |
| `type.body` | 15.5 | 500 | 1.3 | Habit row label (done = 500 muted, todo = 600 text) |
| `type.control` | 15 | 600 | 1.2 | Buttons, dialog input text |
| `type.caption` | 14 | 500 | 1.5 | Helper / empty-state body |
| `type.caption-sm` | 13.5 | 500 | 1.4 | All-done subtext, widget rows |
| `type.progress-label` | 12.5 | 600 | 1.2 | "3 of 5 — almost there!" |
| `type.badge` | 12 | 700 | 1.0 | "+1" badge, section labels |
| `type.section-label` | 12 | 600 | 1.0 | Uppercase, letter-spacing **0.09em** |
| `type.widget-wordmark` | 12 | 800 | 1.0 | "ndsl" in widgets |
| `type.wordmark` | 34 | 700 | 1.0 | Wordmark, letter-spacing **-0.01em** |

---

## 4. Corner radii (dp)

| Token | dp | Usage |
|---|---|---|
| `radius.xs` | 3 | Status-bar battery glyph |
| `radius.progress` | 10 | Progress bar (pill on a 10dp-tall bar) |
| `radius.input` | 16 | Dialog input field |
| `radius.button` | 18 | Dialog action buttons |
| `radius.pill` | 20 | FAB glyph container, chips, "+1" badge (pill) |
| `radius.tile` | 24 | 76dp streak tile |
| `radius.widget-inner` | 22 | Inner widget card |
| `radius.widget-outer` | 26 | Widget frame; launcher icon |
| `radius.dialog` | 28 | Dialog card, empty-state dashed square |
| `radius.screen` | 38 | **Mock device frame only — not an app token** |

FAB itself: **58 × 58**, `radius.pill` (20). Streak tile: **76 × 76**, `radius.tile` (24).

---

## 5. Elevation / shadows

Expressed as `offsetX offsetY blur spread color`. Flutter `BoxShadow` uses
`blurRadius` and `spreadRadius`; negative spread = inset-tightened drop shadow.

| Token | Value (light) | Usage |
|---|---|---|
| `shadow.card` | `0 22 55 -24 #502878 @35%` | Screen/card container |
| `shadow.dialog` | `0 26 60 -22 #281450 @60%` | Dialog card |
| `shadow.fab` | `0 14 28 -8 {color.primary} @100%` | FAB (tinted with primary) |
| `shadow.tile` | `0 10 22 -8 {color.primary} @100%` | Streak tile |
| `shadow.widget` | `0 10 26 -12 #502878 @40%` | Widget card |
| `shadow.mascot` | `0 8 22 -6 #78280A @45%` | Mascot body |

Dark theme: replace card/dialog/widget shadow color with `#000000` at
`@75%` (keep the same offset/blur/spread).

---

## 6. Icon / control sizes (dp)

| Element | Size |
|---|---|
| Check circle (list) | 26 × 26, check glyph 15sp/700 |
| Unchecked ring (list) | 26 × 26, stroke 3 |
| Widget check ring | 14 × 14, stroke 2.5 |
| FAB | 58 × 58, "+" glyph 30sp/600 |
| Streak tile | 76 × 76 |
| Empty dashed square | 90 × 90, stroke 3 dashed, "+" 40sp/600 |
| Progress bar height | 10 |
| Launcher icon (art) | 82 × 82 rounded (`radius.widget-outer`) |

---

## 7. Mascot ("Snappy") construction spec

Squared calendar character, Kotlin-mascot silhouette. Build it as **one widget
parametrised by a single base unit `m`** (dp). Every dimension is a ratio of `m`.
Rendered sizes used in the app: list `m=30`, all-done `m=84`, empty `m=48`,
widget-pending `m=21`, widget-done `m=50`.

Overall bounding box: **2.15m wide × 1.95m tall**.

| Part | Geometry (× m) | Fill |
|---|---|---|
| Body (calendar card) | 1.20 w × 1.00 h, radius 0.20, centered, bottom edge 0.50 up | `primary` gradient (135°) |
| Binder rings ×2 | 0.19 w × 0.30 h, stroke 0.06, no fill; at 26% inset, top −0.20 | `mascot-limb` |
| Header strip | inset 0.10 sides, top 0.09, height 0.16, pill | white 92% |
| Header dots ×3 | 0.07 dia, gap 0.08 | dot1 `secondary`, dot2/3 `#C8C2E0` |
| Face screen | inset 0.10 sides, top 0.32, bottom 0.09, radius 0.14 | `mascot-face` |
| Eye (open) | 0.26 dia ring, stroke 0.075 | white |
| Eye (wink) | 0.26 w × 0.15 h top-arc, stroke 0.075 | white |
| — eyes | at 22% from face top, gap 0.13 between | |
| Smile | 0.24 w × 0.13 h bottom-arc, stroke 0.06, at 20% from face bottom | white |
| Legs ×2 | 0.16 w × 0.66–0.72 long, rounded, splayed +20° / −24° | `mascot-limb` |
| Arms ×2 | 0.60–0.68 long × 0.15 thick, rounded | `mascot-limb` |

**Poses** (differ only in arm angle + animation):
- `peek` — right arm +18°, left arm −34° (relaxed wave). Idle only.
- `cheer` — both arms up ±52°, **wiggle** animation. Used on all-done (hero).
- `point` — right arm down +16°, left arm up +58° (points at FAB). Empty state.

**White variant** (widget-all-done, mascot on colored bg): body gradient
`#FFFFFF → #FFE3D4` (160°), limbs `#FFCAA0`, face stays `#1B1630`.

See `assets/mascot_*.svg` for exact reference vectors.

---

## 8. Motion tokens

| Token | Duration | Curve | Description |
|---|---|---|---|
| `motion.idle-bob` | 2800ms | ease-in-out, loop | Mascot floats: translateY −5% + rotate ±1° |
| `motion.cheer-wiggle` | 1100ms | ease-in-out, loop | Cheer arms bob ±8% |
| `motion.pop` | 1900ms | ease-in-out, loop | All-done mascot scale 1 → 1.12 → 0.96 → 1 |
| `motion.caret` | 1050ms | step, loop | Text caret blink (dialog input) |
| `motion.ping` | 2200ms | ease-out, loop | Empty-state ring around FAB: scale 1 → 1.7, fade 0.55 → 0 |
| `motion.confetti` | 1400–2300ms | ease-in-out, alternate | All-done confetti drift + rotate |

Tap/check feedback (recommended, not in mock): `motion.pop` shortened to
**220ms** `easeOutBack` on habit check-off.
