import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ndsl/bootstrap.dart';
import 'package:ndsl/data/database.dart';
import 'package:ndsl/data/todo_repository.dart';
import 'package:ndsl/data/widget_state_writer.dart';
import 'package:ndsl/domain/todo.dart';

class _RecordingWriter extends WidgetStateWriter {
  @override
  Future<void> write(WidgetSnapshot snapshot) async {}
}

void main() {
  late AppDatabase db;
  late TodoRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = TodoRepository(db, _RecordingWriter());
  });

  tearDown(() => db.close());

  test('complete URI completes the addressed todo', () async {
    await repo.addTodo('water');
    final todo = (await repo.watchTodos().first).single;

    await handleWidgetUri(Uri.parse('ndsl://complete?id=${todo.id}'), repo);

    expect(
      await repo.watchTodos().first,
      [Todo(id: todo.id, name: 'water', isCompleted: true)],
    );
  });

  test('rollover URI unchecks everything', () async {
    await repo.addTodo('water');
    final todo = (await repo.watchTodos().first).single;
    await repo.completeTodo(todo.id);

    // A later day: rollover is date-guarded, so force a fresh repo clock.
    final tomorrowRepo = TodoRepository(
      db,
      _RecordingWriter(),
      now: () => DateTime.now().add(const Duration(days: 2)),
    );
    await handleWidgetUri(Uri.parse('ndsl://rollover'), tomorrowRepo);

    final todos = await repo.watchTodos().first;
    expect(todos.single.isCompleted, isFalse);
  });

  test('unknown and malformed URIs are ignored without throwing', () async {
    await handleWidgetUri(Uri.parse('ndsl://nonsense'), repo);
    await handleWidgetUri(Uri.parse('ndsl://complete?id=abc'), repo);
    await handleWidgetUri(Uri.parse('ndsl://complete'), repo);
  });

  group('moveDatabaseFiles', () {
    late Directory from;
    late Directory to;

    setUp(() async {
      from = await Directory.systemTemp.createTemp('ndsl_from');
      to = await Directory.systemTemp.createTemp('ndsl_to');
    });

    tearDown(() async {
      await from.delete(recursive: true);
      await to.delete(recursive: true);
    });

    test('moves database and WAL sidecars', () async {
      for (final suffix in ['', '-wal', '-shm']) {
        await File('${from.path}/ndsl.sqlite$suffix').writeAsString('x$suffix');
      }

      await moveDatabaseFiles('ndsl.sqlite', from: from, to: to);

      for (final suffix in ['', '-wal', '-shm']) {
        expect(File('${from.path}/ndsl.sqlite$suffix').existsSync(), isFalse);
        expect(await File('${to.path}/ndsl.sqlite$suffix').readAsString(),
            'x$suffix');
      }
    });

    test('is a no-op when the target database already exists', () async {
      await File('${from.path}/ndsl.sqlite').writeAsString('old');
      await File('${to.path}/ndsl.sqlite').writeAsString('new');

      await moveDatabaseFiles('ndsl.sqlite', from: from, to: to);

      expect(await File('${from.path}/ndsl.sqlite').readAsString(), 'old');
      expect(await File('${to.path}/ndsl.sqlite').readAsString(), 'new');
    });

    test('is a no-op when there is nothing to move', () async {
      await moveDatabaseFiles('ndsl.sqlite', from: from, to: to);
      expect(to.listSync(), isEmpty);
    });
  });
}
