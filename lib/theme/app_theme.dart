import 'package:flutter/material.dart';

/// Design tokens from `design/tokens.md` (Playful gamified direction),
/// translated 1:1. Semantic colors are theme-aware via [AppColors]; spacing,
/// radii and type are theme-independent constants.

/// Theme-aware color + shadow tokens. Read via `context.colors`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.text,
    required this.muted,
    required this.line,
    required this.primary,
    required this.primaryBright,
    required this.primaryGradA,
    required this.primaryGradB,
    required this.success,
    required this.successDeep,
    required this.secondary,
    required this.onPrimary,
    required this.scrim,
    required this.mascotFace,
    required this.headerDotIdle,
    required this.cardShadowColor,
    required this.dialogShadowColor,
    required this.mascotShadowColor,
  });

  final Color bg, surface, surfaceAlt, text, muted, line;
  final Color primary, primaryBright, primaryGradA, primaryGradB;
  final Color success, successDeep, secondary, onPrimary, scrim;
  final Color mascotFace, headerDotIdle;
  final Color cardShadowColor, dialogShadowColor, mascotShadowColor;

  // Mascot limbs / rings and active header dot track the accent colors.
  Color get mascotLimb => primary;
  Color get headerDotActive => secondary;

  /// Primary 135° gradient (CSS 135deg ≈ top-left → bottom-right).
  LinearGradient get primaryGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryGradA, primaryGradB],
      );

  List<BoxShadow> get cardShadow => [
        BoxShadow(color: cardShadowColor, offset: const Offset(0, 22), blurRadius: 55, spreadRadius: -24),
      ];
  List<BoxShadow> get dialogShadow => [
        BoxShadow(color: dialogShadowColor, offset: const Offset(0, 26), blurRadius: 60, spreadRadius: -22),
      ];
  List<BoxShadow> get fabShadow => [
        BoxShadow(color: primary, offset: const Offset(0, 14), blurRadius: 28, spreadRadius: -8),
      ];
  List<BoxShadow> get tileShadow => [
        BoxShadow(color: primary, offset: const Offset(0, 10), blurRadius: 22, spreadRadius: -8),
      ];
  List<BoxShadow> get mascotShadow => [
        BoxShadow(color: mascotShadowColor, offset: const Offset(0, 8), blurRadius: 22, spreadRadius: -6),
      ];

  static const light = AppColors(
    bg: Color(0xFFFAF7FF),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFECE9FB),
    text: Color(0xFF201B3A),
    muted: Color(0xFF8A86AD),
    line: Color(0xFFECE9F7),
    primary: Color(0xFFFB5B40),
    primaryBright: Color(0xFFFF643C),
    primaryGradA: Color(0xFFFF7C30),
    primaryGradB: Color(0xFFF53B4B),
    success: Color(0xFF22C273),
    successDeep: Color(0xFF20B46B),
    secondary: Color(0xFF7965F0),
    onPrimary: Color(0xFFFFFFFF),
    scrim: Color.fromARGB(102, 0x1E, 0x14, 0x3C), // #1E143C @40%
    mascotFace: Color(0xFF1B1630),
    headerDotIdle: Color(0xFFC8C2E0),
    cardShadowColor: Color.fromARGB(89, 0x50, 0x28, 0x78), // #502878 @35%
    dialogShadowColor: Color.fromARGB(153, 0x28, 0x14, 0x50), // #281450 @60%
    mascotShadowColor: Color.fromARGB(115, 0x78, 0x28, 0x0A), // #78280A @45%
  );

  static const dark = AppColors(
    bg: Color(0xFF12101D),
    surface: Color(0xFF201C30),
    surfaceAlt: Color(0xFF0C0A16),
    text: Color(0xFFF4F2FF),
    muted: Color(0xFF9D98C2),
    line: Color(0xFF322C48),
    primary: Color(0xFFFF7438),
    primaryBright: Color(0xFFFF7438), // dark table gives no separate bright
    primaryGradA: Color(0xFFFF8238),
    primaryGradB: Color(0xFFFC4351),
    success: Color(0xFF3EC87D),
    successDeep: Color(0xFF3EC87D),
    secondary: Color(0xFF9588FF),
    onPrimary: Color(0xFFFFFFFF),
    scrim: Color.fromARGB(140, 0, 0, 0), // #000 @55%
    mascotFace: Color(0xFF1B1630),
    headerDotIdle: Color(0xFFC8C2E0),
    cardShadowColor: Color.fromARGB(191, 0, 0, 0), // #000 @75%
    dialogShadowColor: Color.fromARGB(191, 0, 0, 0),
    mascotShadowColor: Color.fromARGB(115, 0x78, 0x28, 0x0A),
  );

  // ponytail: tokens are immutable sets; no per-field override is ever needed.
  @override
  AppColors copyWith() => this;

  // ponytail: light/dark don't cross-fade in this app, so a step lerp suffices.
  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) =>
      (other is AppColors && t >= 0.5) ? other : this;
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

/// Spacing scale (dp). Theme-independent.
abstract final class AppSpace {
  static const double s2 = 2, s4 = 4, s6 = 6, s8 = 8, s10 = 10, s12 = 12;
  static const double s14 = 14, s16 = 16, s18 = 18, s20 = 20, s24 = 24;
  static const double s26 = 26, s30 = 30, s38 = 38;
  static const double screenX = 24;
}

/// Corner radii (dp). `screen` (38) is the mock device frame only.
abstract final class AppRadius {
  static const double xs = 3, progress = 10, input = 16, button = 18;
  static const double pill = 20, tile = 24, dialog = 28;
}

/// Type scale. Fredoka, weights 400/500/600/700. `height` is a line-height
/// multiplier; colors are applied at use-site from [AppColors].
abstract final class AppType {
  static const _f = 'Fredoka';
  static const streakHero = TextStyle(fontFamily: _f, fontSize: 62, fontWeight: FontWeight.w700, height: 1.0);
  static const streakTile = TextStyle(fontFamily: _f, fontSize: 40, fontWeight: FontWeight.w700, height: 1.0);
  static const title = TextStyle(fontFamily: _f, fontSize: 26, fontWeight: FontWeight.w700, height: 1.0);
  static const dialogTitle = TextStyle(fontFamily: _f, fontSize: 24, fontWeight: FontWeight.w700, height: 1.1);
  static const emptyTitle = TextStyle(fontFamily: _f, fontSize: 23, fontWeight: FontWeight.w700, height: 1.1);
  static const subtitle = TextStyle(fontFamily: _f, fontSize: 16, fontWeight: FontWeight.w600, height: 1.2);
  static const body = TextStyle(fontFamily: _f, fontSize: 15.5, fontWeight: FontWeight.w500, height: 1.3);
  static const control = TextStyle(fontFamily: _f, fontSize: 15, fontWeight: FontWeight.w600, height: 1.2);
  static const caption = TextStyle(fontFamily: _f, fontSize: 14, fontWeight: FontWeight.w500, height: 1.5);
  static const captionSm = TextStyle(fontFamily: _f, fontSize: 13.5, fontWeight: FontWeight.w500, height: 1.4);
  static const progressLabel = TextStyle(fontFamily: _f, fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.2);
  static const badge = TextStyle(fontFamily: _f, fontSize: 12, fontWeight: FontWeight.w700, height: 1.0);
  static const sectionLabel = TextStyle(fontFamily: _f, fontSize: 12, fontWeight: FontWeight.w600, height: 1.0, letterSpacing: 1.08); // 0.09em
  static const wordmark = TextStyle(fontFamily: _f, fontSize: 34, fontWeight: FontWeight.w700, height: 1.0, letterSpacing: -0.34); // -0.01em
}

ThemeData buildAppTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  return ThemeData(
    brightness: brightness,
    fontFamily: 'Fredoka',
    scaffoldBackgroundColor: c.bg,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.secondary,
      onSecondary: c.onPrimary,
      surface: c.surface,
      onSurface: c.text,
      error: c.primary, // no destructive red in this palette
      onError: c.onPrimary,
    ),
    extensions: [c],
  );
}
