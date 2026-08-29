# final_ui — reference only

Visual reference for the **Playful gamified** direction. **Do not port this code**
— translate it to Flutter widgets using `../tokens.md` and `../handover.md`.

- `PlayfulBoard.dc.html` — all app screens + both widget states + branding,
  laid out on one board (light theme values inline; the dark theme overrides
  live in the parent canvas and are captured in `tokens.md §1.2`).
- `PlayfulMascot.dc.html` — the mascot component (poses: peek / cheer / point).
  Geometry is parametrised by a single base unit `--m`; see `tokens.md §7`.
- `support.js` — runtime for the `.dc.html` files; needed only to open them in a
  browser. Not part of the app.

To view: open either `.dc.html` in a browser (they load `support.js` from this
folder).
