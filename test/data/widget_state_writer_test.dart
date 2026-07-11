import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ndsl/data/widget_state_writer.dart';
import 'package:ndsl/domain/todo.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('home_widget');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return true;
    });
  });

  const todos = [
    Todo(id: 1, name: 'water', isCompleted: true),
    Todo(id: 2, name: 'run', isCompleted: false),
  ];

  test('write saves streaks and todo lists, then triggers a widget update',
      () async {
    await WidgetStateWriter().write(
      const WidgetSnapshot(todos: todos, streak: 4, afterMidnightStreak: 0),
    );

    final saved = {
      for (final c in calls.where((c) => c.method == 'saveWidgetData'))
        c.arguments['id']: c.arguments['data'],
    };
    expect(saved['streak'], 4);
    expect(saved['afterMidnightStreak'], 0);
    expect(jsonDecode(saved['uncompleted'] as String), [
      {'id': 2, 'name': 'run'},
    ]);
    expect(jsonDecode(saved['allTodos'] as String), [
      {'id': 1, 'name': 'water'},
      {'id': 2, 'name': 'run'},
    ]);

    expect(calls.last.method, 'updateWidget');
    expect(calls.last.arguments['android'], 'NdslWidgetProvider');
    expect(calls.last.arguments['ios'], 'NdslWidget');
  });

  test('write with no uncompleted todos saves an empty uncompleted list',
      () async {
    await WidgetStateWriter().write(
      const WidgetSnapshot(
        todos: [Todo(id: 1, name: 'water', isCompleted: true)],
        streak: 5,
        afterMidnightStreak: 5,
      ),
    );

    final saved = {
      for (final c in calls.where((c) => c.method == 'saveWidgetData'))
        c.arguments['id']: c.arguments['data'],
    };
    expect(jsonDecode(saved['uncompleted'] as String), isEmpty);
    expect(saved['afterMidnightStreak'], 5);
  });
}
