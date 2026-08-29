# Design handover

Shared drop point between **Claude design** (desktop) and **Claude Code**.
Claude design writes here; Claude Code reads from here and translates to Flutter.

Expected files:

- `tokens.md` — every design value as a concrete token (colors hex + semantic
  name, spacing scale in dp, type scale, radii, elevations, icon sizes).
- `handover.md` — screen-by-screen breakdown with every state
  (default/empty/loading/error/disabled), component inventory mapped to token
  names, and motion/interaction notes.
- `assets/` — exported icons/images/SVGs + the required font list.
- `final_ui/` — the design artifact itself (e.g. exported `.html`). Translation
  reference only, not code to copy.

Target platform: Flutter (iOS + Android). Values must be exact — no guessing.
