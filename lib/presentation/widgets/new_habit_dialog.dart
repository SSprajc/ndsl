import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Shows the styled "New habit!" dialog; returns the trimmed name or null.
Future<String?> showNewHabitDialog(BuildContext context) {
  final c = context.colors;
  return showDialog<String>(
    context: context,
    barrierColor: c.scrim,
    builder: (context) => const _NewHabitDialog(),
  );
}

class _NewHabitDialog extends StatefulWidget {
  const _NewHabitDialog();

  @override
  State<_NewHabitDialog> createState() => _NewHabitDialogState();
}

class _NewHabitDialogState extends State<_NewHabitDialog> {
  final _controller = TextEditingController();
  bool _canAdd = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final can = _controller.text.trim().isNotEmpty;
      if (can != _canAdd) setState(() => _canAdd = can);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.dialog),
          boxShadow: c.dialogShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New habit!', style: AppType.dialogTitle.copyWith(color: c.text)),
            const SizedBox(height: AppSpace.s16),
            TextField(
              controller: _controller,
              autofocus: true,
              cursorColor: c.secondary,
              style: AppType.control.copyWith(color: c.text),
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                hintText: 'e.g. Drink water',
                hintStyle: AppType.control.copyWith(color: c.muted),
                filled: true,
                fillColor: c.surfaceAlt,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  borderSide: BorderSide(color: c.secondary, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  borderSide: BorderSide(color: c.secondary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.s20),
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    label: 'Cancel',
                    onTap: () => Navigator.pop(context),
                    fill: c.surfaceAlt,
                    textColor: c.muted,
                  ),
                ),
                const SizedBox(width: AppSpace.s10),
                Expanded(
                  child: _DialogButton(
                    label: 'Add',
                    onTap: _canAdd ? _submit : null,
                    gradient: c.primaryGradient,
                    textColor: c.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.onTap,
    required this.textColor,
    this.fill,
    this.gradient,
  });

  final String label;
  final VoidCallback? onTap;
  final Color textColor;
  final Color? fill;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.45 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fill,
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          child: Text(label, style: AppType.control.copyWith(color: textColor)),
        ),
      ),
    );
  }
}
