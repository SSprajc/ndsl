import 'package:equatable/equatable.dart';

import '../domain/todo.dart';

class TodoState extends Equatable {
  const TodoState({required this.todos, required this.streak});

  static const initial = TodoState(todos: [], streak: 0);

  final List<Todo> todos;
  final int streak;

  bool get allDone => todos.isNotEmpty && todos.every((t) => t.isCompleted);

  @override
  List<Object?> get props => [todos, streak];
}
