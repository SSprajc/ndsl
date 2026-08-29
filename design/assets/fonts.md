# Fonts

## Required family

**Fredoka** — rounded geometric sans. Primary UI typeface for all in-app text.

- Weights needed: **400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold)**.
- Source: Google Fonts — https://fonts.google.com/specimen/Fredoka
- License: SIL Open Font License 1.1 (bundling in the app is permitted).

### Flutter setup
Download the static instances (not the variable font, unless you configure
`fontVariations`) and place them under `assets/fonts/`, then declare:

```yaml
# pubspec.yaml
flutter:
  fonts:
    - family: Fredoka
      fonts:
        - asset: assets/fonts/Fredoka-Regular.ttf
          weight: 400
        - asset: assets/fonts/Fredoka-Medium.ttf
          weight: 500
        - asset: assets/fonts/Fredoka-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Fredoka-Bold.ttf
          weight: 700
```

Fallback stack (if Fredoka fails to load): `SF Pro Rounded` (iOS) →
`Nunito` → `system-ui` → `sans-serif`.

## Widget / native surfaces

Home-screen widgets do **not** use Fredoka:
- **Android `RemoteViews`** cannot load custom fonts → use the **system font**
  (Roboto).
- **iOS WidgetKit** may use Fredoka if bundled in the widget extension, but the
  mock was designed to look fine with the system rounded font — either is
  acceptable. Match weights (700/800 for the big numerals).
