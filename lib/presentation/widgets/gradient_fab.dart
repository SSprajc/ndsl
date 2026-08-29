import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// 58dp primary-gradient FAB with a "+". When [pulsing] (empty state) it emits
/// the `motion.ping` ring to draw the first tap.
class GradientFab extends StatefulWidget {
  const GradientFab({super.key, required this.onTap, this.pulsing = false});

  final VoidCallback onTap;
  final bool pulsing;

  @override
  State<GradientFab> createState() => _GradientFabState();
}

class _GradientFabState extends State<GradientFab> with SingleTickerProviderStateMixin {
  late final AnimationController _ping = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void initState() {
    super.initState();
    if (widget.pulsing) _ping.repeat();
  }

  @override
  void didUpdateWidget(GradientFab old) {
    super.didUpdateWidget(old);
    if (widget.pulsing && !_ping.isAnimating) {
      _ping.repeat();
    } else if (!widget.pulsing && _ping.isAnimating) {
      _ping.stop();
    }
  }

  @override
  void dispose() {
    _ping.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      width: 58,
      height: 58,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (widget.pulsing)
            AnimatedBuilder(
              animation: _ping,
              builder: (context, _) {
                final t = Curves.easeOut.transform(_ping.value);
                return Container(
                  width: 58 * (1 + 0.7 * t),
                  height: 58 * (1 + 0.7 * t),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.primary.withValues(alpha: 0.55 * (1 - t)),
                  ),
                );
              },
            ),
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: c.primaryGradient,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: c.fabShadow,
              ),
              child: Text(
                '+',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: c.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
