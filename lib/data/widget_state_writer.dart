import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:home_widget/home_widget.dart';

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

/// Android AppWidgetProvider class name / iOS WidgetKind. Must match the
/// native widget declarations.
const androidWidgetName = 'NdslWidgetProvider';
const iOSWidgetName = 'NdslWidget';

class WidgetStateWriter {
  Future<void> write(WidgetSnapshot snapshot) async {
    List<Map<String, Object>> encode(Iterable<Todo> todos) =>
        [for (final t in todos) {'id': t.id, 'name': t.name}];

    await HomeWidget.saveWidgetData('streak', snapshot.streak);
    await HomeWidget.saveWidgetData(
        'afterMidnightStreak', snapshot.afterMidnightStreak);
    await HomeWidget.saveWidgetData('uncompleted',
        jsonEncode(encode(snapshot.todos.where((t) => !t.isCompleted))));
    // Full list: the iOS midnight timeline entry renders it all-unchecked.
    await HomeWidget.saveWidgetData('allTodos', jsonEncode(encode(snapshot.todos)));
    await HomeWidget.updateWidget(
        androidName: androidWidgetName, iOSName: iOSWidgetName);
  }
}
