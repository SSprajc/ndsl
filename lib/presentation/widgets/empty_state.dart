import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'mascot.dart';

/// Empty state (0 habits): dashed placeholder, prompt, and the mascot pointing
/// at the FAB.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenX),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: CustomPaint(
              painter: _DashedSquare(color: c.secondary),
              child: Center(
                child: Text(
                  '+',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    color: c.secondary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s20),
          Text('No habits yet!', style: AppType.emptyTitle.copyWith(color: c.text)),
          const SizedBox(height: AppSpace.s8),
          Text(
            'Tap the + to add your first habit\nand start a streak.',
            textAlign: TextAlign.center,
            style: AppType.caption.copyWith(color: c.muted),
          ),
          const SizedBox(height: AppSpace.s24),
          const Mascot(pose: MascotPose.point, m: 48),
        ],
      ),
    );
  }
}

class _DashedSquare extends CustomPainter {
  _DashedSquare({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1.5, 1.5, size.width - 3, size.height - 3),
      const Radius.circular(AppRadius.dialog),
    );
    // Dashed outline: walk the path and draw ~9dp dashes with 7dp gaps.
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 9), paint);
        d += 16;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedSquare old) => old.color != color;
}
