import 'package:equatable/equatable.dart';

import '../domain/todo.dart';

/// Everything the home-screen widget needs to render both its current state
/// and its post-midnight state (same items all unchecked + predicted streak).
class WidgetSnapshot extends Equatable {
  const WidgetSnapshot({
    required this.todos,
    required this.streak,
    required this.afterMidnightStreak,
  });

  final List<Todo> todos;
  final int streak;
  final int afterMidnightStreak;

  @override
  List<Object?> get props => [todos, streak, afterMidnightStreak];
}

class WidgetStateWriter {
  Future<void> write(WidgetSnapshot snapshot) async {
    // ponytail: no-op until Phase 2 wires home_widget storage + native widgets.
  }
}
