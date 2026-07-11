import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/todo.dart';
import 'todo_cubit.dart';

/// Bare functional screen — layout and styling are deliberately absent;
/// claude-design owns the visual pass.
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
    return Scaffold(
      appBar: AppBar(title: Text('Streak: ${state.streak}')),
      body: ListView(
        children: [
          for (final todo in state.todos)
            ListTile(
              leading: Checkbox(
                value: todo.isCompleted,
                // Done is done: no unchecking.
                onChanged: todo.isCompleted
                    ? null
                    : (_) => context.read<TodoCubit>().complete(todo.id),
              ),
              title: Text(todo.name),
              onLongPress: () => _confirmDelete(todo),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _promptAdd,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _promptAdd() async {
    final cubit = context.read<TodoCubit>();
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New habit'),
        content: TextField(
          controller: controller,
          autofocus: true,
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    final trimmed = name?.trim() ?? '';
    if (trimmed.isNotEmpty) await cubit.add(trimmed);
  }

  Future<void> _confirmDelete(Todo todo) async {
    final cubit = context.read<TodoCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${todo.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.delete(todo.id);
  }
}
