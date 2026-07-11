import 'package:drift/drift.dart';

import '../domain/streak_rules.dart';
import '../domain/todo.dart';
import 'database.dart';
import 'widget_state_writer.dart';

/// Single mutation point for all persisted state. Every write also pushes a
/// fresh snapshot to the home-screen widget.
class TodoRepository {
  TodoRepository(
    this._db,
    this._widgetWriter, {
    DateTime Function() now = DateTime.now,
  }) : _now = now;

  final AppDatabase _db;
  final WidgetStateWriter _widgetWriter;
  final DateTime Function() _now;

  Stream<List<Todo>> watchTodos() => _orderedTodos().watch();

  Stream<int> watchStreak() =>
      _db.select(_db.streakStates).watchSingle().map((r) => r.count);

  Future<void> addTodo(String name) async {
    await _db.into(_db.todos).insert(TodosCompanion.insert(name: name));
    await _pushWidgetState();
  }

  Future<void> deleteTodo(int id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.todos)..where((t) => t.id.equals(id))).go();
      // Deleting the last open item can complete the day.
      await _settleAllDone();
    });
    await _pushWidgetState();
  }

  Future<void> completeTodo(int id) async {
    await _db.transaction(() async {
      await (_db.update(_db.todos)..where((t) => t.id.equals(id)))
          .write(const TodosCompanion(isCompleted: Value(true)));
      await _settleAllDone();
    });
    await _pushWidgetState();
  }

  /// Settles yesterday's streak and unchecks everything, once per day.
  /// Must run before anything else on every entry point (app start/resume,
  /// widget callback).
  Future<void> rolloverIfNeeded() async {
    await _db.transaction(() async {
      final next = rollover(await _readStreak(), _now());
      if (next == null) return;
      await _writeStreak(next);
      await _db
          .update(_db.todos)
          .write(const TodosCompanion(isCompleted: Value(false)));
    });
    await _pushWidgetState();
  }

  SimpleSelectStatement<$TodosTable, Todo> _orderedTodos() =>
      _db.select(_db.todos)..orderBy([(t) => OrderingTerm(expression: t.id)]);

  Future<void> _settleAllDone() async {
    final todos = await _db.select(_db.todos).get();
    if (todos.isEmpty || !todos.every((t) => t.isCompleted)) return;
    final next = allDone(await _readStreak(), _now());
    if (next != null) await _writeStreak(next);
  }

  Future<StreakState> _readStreak() async {
    final row = await _db.select(_db.streakStates).getSingle();
    return StreakState(
      count: row.count,
      lastAllDoneDate: row.lastAllDoneDate,
      lastResetDate: row.lastResetDate,
    );
  }

  Future<void> _writeStreak(StreakState s) =>
      _db.update(_db.streakStates).write(StreakStatesCompanion(
            count: Value(s.count),
            lastAllDoneDate: Value(s.lastAllDoneDate),
            lastResetDate: Value(s.lastResetDate),
          ));

  Future<void> _pushWidgetState() async {
    final todos = await _orderedTodos().get();
    final s = await _readStreak();
    await _widgetWriter.write(WidgetSnapshot(
      todos: todos,
      streak: s.count,
      afterMidnightStreak: streakAfterMidnight(s, _now()),
    ));
  }
}
