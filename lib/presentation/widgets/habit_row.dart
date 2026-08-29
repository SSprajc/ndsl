import 'package:flutter/material.dart';

import '../../domain/todo.dart';
import '../../theme/app_theme.dart';

/// One habit row: check control + label. Done = filled success check + muted
/// label; todo = secondary ring + text label. Tap completes (done is done);
/// long-press deletes.
class HabitRow extends StatelessWidget {
  const HabitRow({
    super.key,
    required this.todo,
    required this.onComplete,
    required this.onDelete,
  });

  final Todo todo;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final done = todo.isCompleted;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: done ? null : onComplete,
      onLongPress: onDelete,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        child: Row(
          children: [
            _check(c, done),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                todo.name,
                style: AppType.body.copyWith(
                  color: done ? c.muted : c.text,
                  fontWeight: done ? FontWeight.w500 : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _check(AppColors c, bool done) {
    if (done) {
      return Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: c.success, shape: BoxShape.circle),
        child: Icon(Icons.check_rounded, size: 15, color: c.onPrimary),
      );
    }
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: c.secondary, width: 3),
      ),
    );
  }
}
