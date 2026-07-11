import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ndsl/data/database.dart';
import 'package:ndsl/data/todo_repository.dart';
import 'package:ndsl/data/widget_state_writer.dart';
import 'package:ndsl/domain/todo.dart';

class MockWidgetStateWriter extends Mock implements WidgetStateWriter {}

void main() {
  late AppDatabase db;
  late MockWidgetStateWriter writer;
  late DateTime now;
  late TodoRepository repo;

  setUpAll(() {
    registerFallbackValue(
      const WidgetSnapshot(todos: [], streak: 0, afterMidnightStreak: 0),
    );
  });

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    writer = MockWidgetStateWriter();
    when(() => writer.write(any())).thenAnswer((_) async {});
    now = DateTime(2026, 7, 10, 9, 0);
    repo = TodoRepository(db, writer, now: () => now);
  });

  tearDown(() => db.close());

  WidgetSnapshot lastSnapshot() =>
      verify(() => writer.write(captureAny())).captured.last as WidgetSnapshot;

  group('crud', () {
    test('addTodo stores an uncompleted item', () async {
      await repo.addTodo('run');
      expect(await repo.watchTodos().first, [
        const Todo(id: 1, name: 'run', isCompleted: false),
      ]);
    });

    test('items are ordered by insertion', () async {
      await repo.addTodo('b');
      await repo.addTodo('a');
      final names = (await repo.watchTodos().first).map((t) => t.name);
      expect(names, ['b', 'a']);
    });

    test('deleteTodo removes the item', () async {
      await repo.addTodo('run');
      await repo.deleteTodo(1);
      expect(await repo.watchTodos().first, isEmpty);
    });

    test('completeTodo marks the item completed', () async {
      await repo.addTodo('run');
      await repo.addTodo('read');
      await repo.completeTodo(1);
      expect(await repo.watchTodos().first, [
        const Todo(id: 1, name: 'run', isCompleted: true),
        const Todo(id: 2, name: 'read', isCompleted: false),
      ]);
    });
  });

  group('streak', () {
    test('starts at 0', () async {
      expect(await repo.watchStreak().first, 0);
    });

    test('completing the last open item increments the streak', () async {
      await repo.addTodo('run');
      await repo.addTodo('read');
      await repo.completeTodo(1);
      expect(await repo.watchStreak().first, 0);
      await repo.completeTodo(2);
      expect(await repo.watchStreak().first, 1);
    });

    test('a second all-done on the same day does not double count', () async {
      await repo.addTodo('run');
      await repo.completeTodo(1);
      await repo.addTodo('read');
      await repo.completeTodo(2);
      expect(await repo.watchStreak().first, 1);
    });

    test('deleting the last open item settles all-done too', () async {
      await repo.addTodo('run');
      await repo.addTodo('read');
      await repo.completeTodo(1);
      await repo.deleteTodo(2);
      expect(await repo.watchStreak().first, 1);
    });

    test('deleting the only item does not count an empty list as done',
        () async {
      await repo.addTodo('run');
      await repo.deleteTodo(1);
      expect(await repo.watchStreak().first, 0);
    });
  });

  group('rolloverIfNeeded', () {
    test('unchecks everything and keeps streak after a completed day',
        () async {
      await repo.addTodo('run');
      await repo.completeTodo(1);
      now = DateTime(2026, 7, 11, 0, 5);
      await repo.rolloverIfNeeded();
      expect(await repo.watchTodos().first, [
        const Todo(id: 1, name: 'run', isCompleted: false),
      ]);
      expect(await repo.watchStreak().first, 1);
    });

    test('zeroes streak after a missed day', () async {
      await repo.addTodo('run');
      await repo.completeTodo(1);
      now = DateTime(2026, 7, 13, 9, 0);
      await repo.rolloverIfNeeded();
      expect(await repo.watchStreak().first, 0);
    });

    test('is a no-op the second time on the same day', () async {
      await repo.addTodo('run');
      now = DateTime(2026, 7, 11, 0, 5);
      await repo.rolloverIfNeeded();
      await repo.completeTodo(1);
      await repo.rolloverIfNeeded();
      expect(await repo.watchTodos().first, [
        const Todo(id: 1, name: 'run', isCompleted: true),
      ]);
      expect(await repo.watchStreak().first, 1);
    });
  });

  group('widget snapshot', () {
    test('pushed on every mutation with current items', () async {
      await repo.addTodo('run');
      final snap = lastSnapshot();
      expect(snap.todos, [const Todo(id: 1, name: 'run', isCompleted: false)]);
      expect(snap.streak, 0);
      expect(snap.afterMidnightStreak, 0);
    });

    test('predicts surviving streak after all-done', () async {
      await repo.addTodo('run');
      await repo.completeTodo(1);
      final snap = lastSnapshot();
      expect(snap.streak, 1);
      expect(snap.afterMidnightStreak, 1);
    });

    test('predicts dead streak while items are open', () async {
      await repo.addTodo('run');
      await repo.completeTodo(1);
      now = DateTime(2026, 7, 11, 0, 5);
      await repo.rolloverIfNeeded();
      final snap = lastSnapshot();
      expect(snap.streak, 1);
      expect(snap.afterMidnightStreak, 0);
    });
  });
}
