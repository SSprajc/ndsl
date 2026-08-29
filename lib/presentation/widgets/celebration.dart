import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'mascot.dart';

/// All-done celebration: confetti + cheering mascot (pop-scale loop) + the hero
/// streak numeral, "+1" badge and "YOU DID IT!".
class Celebration extends StatefulWidget {
  const Celebration({super.key, required this.streak});

  final int streak;

  @override
  State<Celebration> createState() => _CelebrationState();
}

class _CelebrationState extends State<Celebration> with TickerProviderStateMixin {
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  )..repeat();
  late final AnimationController _confetti = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2300),
  )..repeat();

  @override
  void dispose() {
    _pop.dispose();
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _confetti,
            builder: (context, _) => CustomPaint(
              painter: _ConfettiPainter(_confetti.value, [c.primary, c.secondary, c.success, c.primaryBright]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenX),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pop,
                builder: (context, child) => Transform.scale(scale: _popScale(_pop.value), child: child),
                child: const Mascot(pose: MascotPose.cheer, m: 84),
              ),
              const SizedBox(height: AppSpace.s24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${widget.streak}', style: AppType.streakHero.copyWith(color: c.primaryBright)),
                  const SizedBox(width: AppSpace.s10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: c.successDeep,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text('+1', style: AppType.badge.copyWith(color: c.onPrimary)),
                  ),
                ],
              ),
              Text('day streak', style: AppType.subtitle.copyWith(color: c.muted)),
              const SizedBox(height: AppSpace.s16),
              Text('YOU DID IT!', style: AppType.title.copyWith(color: c.text)),
              const SizedBox(height: AppSpace.s8),
              Text(
                'Every habit done today. See you tomorrow!',
                textAlign: TextAlign.center,
                style: AppType.captionSm.copyWith(color: c.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 1 → 1.12 → 0.96 → 1 across the loop.
  double _popScale(double t) {
    if (t < 0.33) return 1 + 0.12 * (t / 0.33);
    if (t < 0.66) return 1.12 - 0.16 * ((t - 0.33) / 0.33);
    return 0.96 + 0.04 * ((t - 0.66) / 0.34);
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t, this.colors);

  final double t;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    // 18 deterministic pieces drifting down and rotating.
    for (var i = 0; i < 18; i++) {
      final seed = i * 0.137;
      final x = ((seed * 3.3) % 1) * size.width;
      final y = (((seed + t) % 1)) * size.height;
      final paint = Paint()..color = colors[i % colors.length];
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate((t * 2 * math.pi) + i);
      canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(-3, -5, 6, 10), const Radius.circular(2)),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
