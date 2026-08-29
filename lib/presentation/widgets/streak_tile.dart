import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// 76dp streak tile. Active = primary gradient + tinted shadow; zero = flat
/// surface-alt with a primary numeral. (`StreakTile` in the inventory.)
class StreakTile extends StatelessWidget {
  const StreakTile({super.key, required this.value, required this.active});

  final int value;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 76,
      height: 76,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: active ? c.primaryGradient : null,
        color: active ? null : c.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        boxShadow: active ? c.tileShadow : null,
      ),
      child: Text(
        '$value',
        style: AppType.streakTile.copyWith(color: active ? c.onPrimary : c.primary),
      ),
    );
  }
}
