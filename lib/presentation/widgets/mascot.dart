import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// "Snappy" — the calendar mascot. Rendered by [CustomPaint] from the reference
/// vectors in `design/assets/mascot_*.svg`, which share a 215×195 viewBox
/// (= 2.15m × 1.95m at m=100). Everything is parametrised by the base unit [m];
/// only the arms differ between poses, only fills differ for the white variant.
enum MascotPose { peek, cheer, point }

/// Explicit colour set for the mascot (e.g. the launcher-icon variant, which
/// uses white limbs + a dark header strip). When null, colours derive from
/// [Mascot.white] and the theme.
class MascotColors {
  const MascotColors({
    required this.gradA,
    required this.gradB,
    required this.limb,
    required this.dot1,
    required this.dotIdle,
    required this.face,
    required this.header,
  });
  final Color gradA, gradB, limb, dot1, dotIdle, face, header;
}

class Mascot extends StatefulWidget {
  const Mascot({
    super.key,
    required this.pose,
    required this.m,
    this.white = false,
    this.idle = true,
    this.colors,
  });

  /// Base unit in dp. Widget footprint is 2.15m × 1.95m.
  final double m;
  final MascotPose pose;

  /// White-on-colour variant (widget all-done); ignored in-app for now.
  final bool white;

  /// Continuous idle float (`motion.idle-bob`): translateY −5% + rotate ±1°.
  final bool idle;

  /// Overrides all fills; when null they derive from [white] + theme.
  final MascotColors? colors;

  @override
  State<Mascot> createState() => _MascotState();
}

class _MascotState extends State<Mascot> with SingleTickerProviderStateMixin {
  late final AnimationController _bob;

  @override
  void initState() {
    super.initState();
    // Created unconditionally so dispose() is always safe, even when !idle
    // (a lazy `late` init would otherwise fire during teardown and crash).
    _bob = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800));
    if (widget.idle) _bob.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(Mascot old) {
    super.didUpdateWidget(old);
    if (widget.idle && !_bob.isAnimating) {
      _bob.repeat(reverse: true);
    } else if (!widget.idle && _bob.isAnimating) {
      _bob.stop();
    }
  }

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final painter = _MascotPainter(
      arms: _armsFor(widget.pose),
      colors: widget.colors ?? _themeColors(context),
      m: widget.m,
    );

    final box = SizedBox(
      width: 2.15 * widget.m,
      height: 1.95 * widget.m,
      child: CustomPaint(painter: painter),
    );

    if (!widget.idle) return box;

    return AnimatedBuilder(
      animation: _bob,
      builder: (context, child) {
        final curved = Curves.easeInOut.transform(_bob.value);
        return Transform.translate(
          offset: Offset(0, -0.05 * 1.95 * widget.m * curved),
          child: Transform.rotate(
            angle: (curved * 2 - 1) * math.pi / 180, // ±1°
            child: child,
          ),
        );
      },
      child: box,
    );
  }

  MascotColors _themeColors(BuildContext context) {
    final c = context.colors;
    return MascotColors(
      gradA: widget.white ? const Color(0xFFFFFFFF) : c.primaryGradA,
      gradB: widget.white ? const Color(0xFFFFE3D4) : c.primaryGradB,
      limb: widget.white ? const Color(0xFFFFCAA0) : c.mascotLimb,
      dot1: widget.white ? const Color(0xFFFFCAA0) : c.headerDotActive,
      dotIdle: c.headerDotIdle,
      face: c.mascotFace,
      header: const Color(0xEBFFFFFF), // white @ 92%
    );
  }
}

/// One rounded arm/limb rect: (x,y,w,h) then SVG rotate(deg) about (cx,cy).
class _Limb {
  const _Limb(this.x, this.y, this.w, this.h, this.deg, this.cx, this.cy);
  final double x, y, w, h, deg, cx, cy;
}

({_Limb left, _Limb right}) _armsFor(MascotPose pose) => switch (pose) {
      MascotPose.peek => (
          left: const _Limb(47.5, 63.5, 62, 15, 162, 47.5, 71.0),
          right: const _Limb(167.5, 47.5, 66, 15, -34, 167.5, 55.0),
        ),
      MascotPose.cheer => (
          left: const _Limb(47.5, 39.5, 66, 15, 232, 47.5, 47.0),
          right: const _Limb(167.5, 39.5, 66, 15, -52, 167.5, 47.0),
        ),
      MascotPose.point => (
          left: const _Limb(47.5, 67.5, 60, 15, 164, 47.5, 75.0),
          right: const _Limb(167.5, 33.5, 68, 15, -58, 167.5, 41.0),
        ),
    };

// Legs and binder rings are identical across all poses.
const _legLeft = _Limb(65.5, 143, 16, 66, 20, 65.5, 143);
const _legRight = _Limb(133.5, 143, 16, 72, -24, 133.5, 143);

class _MascotPainter extends CustomPainter {
  _MascotPainter({required this.arms, required this.colors, required this.m});

  final ({_Limb left, _Limb right}) arms;
  final MascotColors colors;
  final double m;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(m / 100); // draw in raw 215×195 SVG units

    final limbFill = Paint()..color = colors.limb;
    final ringStroke = Paint()
      ..color = colors.limb
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    // Arms + legs (behind the body card).
    _limb(canvas, arms.left, limbFill, 7.5);
    _limb(canvas, arms.right, limbFill, 7.5);
    _limb(canvas, _legLeft, limbFill, 8);
    _limb(canvas, _legRight, limbFill, 8);

    // Binder rings (poke out the top).
    _ring(canvas, 78.7, 25, 19, 30, 9.5, ringStroke);
    _ring(canvas, 117.3, 25, 19, 30, 9.5, ringStroke);

    // Body (calendar card) with the 135° gradient.
    final bodyRect = const Rect.fromLTWH(47.5, 45, 120, 100);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(20)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.gradA, colors.gradB],
        ).createShader(bodyRect),
    );

    // Header strip + calendar dots.
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(57.5, 54, 100, 16), const Radius.circular(8)),
      Paint()..color = colors.header,
    );
    canvas.drawCircle(const Offset(92.5, 62), 3.5, Paint()..color = colors.dot1);
    canvas.drawCircle(const Offset(107.5, 62), 3.5, Paint()..color = colors.dotIdle);
    canvas.drawCircle(const Offset(122.5, 62), 3.5, Paint()..color = colors.dotIdle);

    // Face screen.
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(57.5, 77, 100, 59), const Radius.circular(14)),
      Paint()..color = colors.face,
    );

    final white = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Left eye = open ring; right eye = wink (top arc).
    canvas.drawCircle(const Offset(88, 103), 9.3, Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.5);
    canvas.drawPath(
      Path()
        ..moveTo(114, 103)
        ..arcToPoint(const Offset(140, 103), radius: const Radius.circular(13), clockwise: true),
      white..strokeWidth = 7.5,
    );
    // Smile.
    canvas.drawPath(
      Path()
        ..moveTo(95.5, 124.2)
        ..quadraticBezierTo(107.5, 145, 119.5, 124.2),
      white..strokeWidth = 6,
    );

    canvas.restore();
  }

  void _limb(Canvas c, _Limb l, Paint p, double r) {
    c.save();
    c.translate(l.cx, l.cy);
    c.rotate(l.deg * math.pi / 180);
    c.translate(-l.cx, -l.cy);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(l.x, l.y, l.w, l.h), Radius.circular(r)), p);
    c.restore();
  }

  void _ring(Canvas c, double x, double y, double w, double h, double r, Paint p) {
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), Radius.circular(r)), p);
  }

  @override
  bool shouldRepaint(_MascotPainter old) =>
      old.arms != arms || old.colors != colors || old.m != m;
}
