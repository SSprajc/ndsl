import 'package:drift/drift.dart';

import '../domain/todo.dart';

part 'database.g.dart';

@UseRowClass(Todo)
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}

/// Single-row table (id is always 0) holding the streak bookkeeping.
@DataClassName('StreakRow')
class StreakStates extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get count => integer().withDefault(const Constant(0))();
  TextColumn get lastAllDoneDate =>
      text().map(const DateTextConverter()).nullable()();
  TextColumn get lastResetDate =>
      text().map(const DateTextConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Stores dates as 'yyyy-MM-dd' text so the calendar date survives timezone
/// changes (a unix timestamp would shift to a different local date).
class DateTextConverter extends TypeConverter<DateTime, String> {
  const DateTextConverter();

  @override
  DateTime fromSql(String fromDb) => DateTime.parse(fromDb);

  @override
  String toSql(DateTime value) {
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    return '${value.year.toString().padLeft(4, '0')}-$m-$d';
  }
}

@DriftDatabase(tables: [Todos, StreakStates])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Seed the single streak row so reads can assume it exists.
          await into(streakStates).insert(const StreakStatesCompanion());
        },
      );
}
