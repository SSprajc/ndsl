import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/todo.dart';
import '../theme/app_theme.dart';
import 'todo_cubit.dart';
import 'widgets/celebration.dart';
import 'widgets/empty_state.dart';
import 'widgets/gradient_fab.dart';
import 'widgets/habit_row.dart';
import 'widgets/mascot.dart';
import 'widgets/new_habit_dialog.dart';
import 'widgets/streak_tile.dart';

/// Playful gamified home. Three states: empty (0 habits), all-done
/// (celebration), and the default mixed list.
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // The date may change while we're backgrounded.
    _lifecycle = AppLifecycleListener(
      onResume: () => context.read<TodoCubit>().appResumed(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TodoCubit>().state;
    final empty = state.todos.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: state.allDone
            ? Celebration(streak: state.streak)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(streak: state.streak, active: !empty),
                  if (!empty) _Progress(todos: state.todos),
                  Expanded(
                    child: empty
                        ? const EmptyState()
                        : ListView(
                            padding: const EdgeInsets.fromLTRB(
                                AppSpace.screenX - 10, AppSpace.s8, AppSpace.screenX - 10, 96),
                            children: [
                              for (final todo in state.todos)
                                HabitRow(
                                  todo: todo,
                                  onComplete: () => context.read<TodoCubit>().complete(todo.id),
                                  onDelete: () => _confirmDelete(todo),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
      ),
      floatingActionButton: GradientFab(onTap: _promptAdd, pulsing: empty),
    );
  }

  Future<void> _promptAdd() async {
    final cubit = context.read<TodoCubit>();
    final name = await showNewHabitDialog(context);
    if (name != null && name.isNotEmpty) await cubit.add(name);
  }

  Future<void> _confirmDelete(Todo todo) async {
    final cubit = context.read<TodoCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${todo.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.delete(todo.id);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.streak, required this.active});

  final int streak;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.screenX, AppSpace.s18, AppSpace.screenX, AppSpace.s6),
      child: Row(
        children: [
          StreakTile(value: streak, active: active),
          const SizedBox(width: AppSpace.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(active ? '$streak-day' : 'Day zero', style: AppType.title.copyWith(color: c.text)),
                const SizedBox(height: AppSpace.s2),
                Text(
                  active ? 'streak 🔥' : "let's go!",
                  style: AppType.subtitle.copyWith(color: c.primary),
                ),
              ],
            ),
          ),
          const Mascot(pose: MascotPose.peek, m: 30),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final done = todos.where((t) => t.isCompleted).length;
    final total = todos.length;
    final value = total == 0 ? 0.0 : done / total;
    final label = done == 0
        ? '$done of $total — let\'s go!'
        : '$done of $total — almost there!';

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.screenX, AppSpace.s6, AppSpace.screenX, AppSpace.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.progress),
            child: SizedBox(
              height: 10,
              child: Stack(
                children: [
                  Container(color: c.line),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value,
                    child: Container(color: c.success),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s6),
          Text(label, style: AppType.progressLabel.copyWith(color: c.muted)),
        ],
      ),
    );
  }
}
