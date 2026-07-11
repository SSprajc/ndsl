// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, isCompleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Todo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isCompleted;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isCompleted = const Value.absent(),
  });
  TodosCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isCompleted = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Todo> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isCompleted != null) 'is_completed': isCompleted,
    });
  }

  TodosCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isCompleted,
  }) {
    return TodosCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }
}

class $StreakStatesTable extends StreakStates
    with TableInfo<$StreakStatesTable, StreakRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreakStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String>
  lastAllDoneDate = GeneratedColumn<String>(
    'last_all_done_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<DateTime?>($StreakStatesTable.$converterlastAllDoneDaten);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> lastResetDate =
      GeneratedColumn<String>(
        'last_reset_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($StreakStatesTable.$converterlastResetDaten);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    count,
    lastAllDoneDate,
    lastResetDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streak_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreakRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StreakRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreakRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      lastAllDoneDate: $StreakStatesTable.$converterlastAllDoneDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}last_all_done_date'],
        ),
      ),
      lastResetDate: $StreakStatesTable.$converterlastResetDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}last_reset_date'],
        ),
      ),
    );
  }

  @override
  $StreakStatesTable createAlias(String alias) {
    return $StreakStatesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterlastAllDoneDate =
      const DateTextConverter();
  static TypeConverter<DateTime?, String?> $converterlastAllDoneDaten =
      NullAwareTypeConverter.wrap($converterlastAllDoneDate);
  static TypeConverter<DateTime, String> $converterlastResetDate =
      const DateTextConverter();
  static TypeConverter<DateTime?, String?> $converterlastResetDaten =
      NullAwareTypeConverter.wrap($converterlastResetDate);
}

class StreakRow extends DataClass implements Insertable<StreakRow> {
  final int id;
  final int count;
  final DateTime? lastAllDoneDate;
  final DateTime? lastResetDate;
  const StreakRow({
    required this.id,
    required this.count,
    this.lastAllDoneDate,
    this.lastResetDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['count'] = Variable<int>(count);
    if (!nullToAbsent || lastAllDoneDate != null) {
      map['last_all_done_date'] = Variable<String>(
        $StreakStatesTable.$converterlastAllDoneDaten.toSql(lastAllDoneDate),
      );
    }
    if (!nullToAbsent || lastResetDate != null) {
      map['last_reset_date'] = Variable<String>(
        $StreakStatesTable.$converterlastResetDaten.toSql(lastResetDate),
      );
    }
    return map;
  }

  StreakStatesCompanion toCompanion(bool nullToAbsent) {
    return StreakStatesCompanion(
      id: Value(id),
      count: Value(count),
      lastAllDoneDate: lastAllDoneDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAllDoneDate),
      lastResetDate: lastResetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastResetDate),
    );
  }

  factory StreakRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreakRow(
      id: serializer.fromJson<int>(json['id']),
      count: serializer.fromJson<int>(json['count']),
      lastAllDoneDate: serializer.fromJson<DateTime?>(json['lastAllDoneDate']),
      lastResetDate: serializer.fromJson<DateTime?>(json['lastResetDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'count': serializer.toJson<int>(count),
      'lastAllDoneDate': serializer.toJson<DateTime?>(lastAllDoneDate),
      'lastResetDate': serializer.toJson<DateTime?>(lastResetDate),
    };
  }

  StreakRow copyWith({
    int? id,
    int? count,
    Value<DateTime?> lastAllDoneDate = const Value.absent(),
    Value<DateTime?> lastResetDate = const Value.absent(),
  }) => StreakRow(
    id: id ?? this.id,
    count: count ?? this.count,
    lastAllDoneDate: lastAllDoneDate.present
        ? lastAllDoneDate.value
        : this.lastAllDoneDate,
    lastResetDate: lastResetDate.present
        ? lastResetDate.value
        : this.lastResetDate,
  );
  StreakRow copyWithCompanion(StreakStatesCompanion data) {
    return StreakRow(
      id: data.id.present ? data.id.value : this.id,
      count: data.count.present ? data.count.value : this.count,
      lastAllDoneDate: data.lastAllDoneDate.present
          ? data.lastAllDoneDate.value
          : this.lastAllDoneDate,
      lastResetDate: data.lastResetDate.present
          ? data.lastResetDate.value
          : this.lastResetDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreakRow(')
          ..write('id: $id, ')
          ..write('count: $count, ')
          ..write('lastAllDoneDate: $lastAllDoneDate, ')
          ..write('lastResetDate: $lastResetDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, count, lastAllDoneDate, lastResetDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreakRow &&
          other.id == this.id &&
          other.count == this.count &&
          other.lastAllDoneDate == this.lastAllDoneDate &&
          other.lastResetDate == this.lastResetDate);
}

class StreakStatesCompanion extends UpdateCompanion<StreakRow> {
  final Value<int> id;
  final Value<int> count;
  final Value<DateTime?> lastAllDoneDate;
  final Value<DateTime?> lastResetDate;
  const StreakStatesCompanion({
    this.id = const Value.absent(),
    this.count = const Value.absent(),
    this.lastAllDoneDate = const Value.absent(),
    this.lastResetDate = const Value.absent(),
  });
  StreakStatesCompanion.insert({
    this.id = const Value.absent(),
    this.count = const Value.absent(),
    this.lastAllDoneDate = const Value.absent(),
    this.lastResetDate = const Value.absent(),
  });
  static Insertable<StreakRow> custom({
    Expression<int>? id,
    Expression<int>? count,
    Expression<String>? lastAllDoneDate,
    Expression<String>? lastResetDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (count != null) 'count': count,
      if (lastAllDoneDate != null) 'last_all_done_date': lastAllDoneDate,
      if (lastResetDate != null) 'last_reset_date': lastResetDate,
    });
  }

  StreakStatesCompanion copyWith({
    Value<int>? id,
    Value<int>? count,
    Value<DateTime?>? lastAllDoneDate,
    Value<DateTime?>? lastResetDate,
  }) {
    return StreakStatesCompanion(
      id: id ?? this.id,
      count: count ?? this.count,
      lastAllDoneDate: lastAllDoneDate ?? this.lastAllDoneDate,
      lastResetDate: lastResetDate ?? this.lastResetDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (lastAllDoneDate.present) {
      map['last_all_done_date'] = Variable<String>(
        $StreakStatesTable.$converterlastAllDoneDaten.toSql(
          lastAllDoneDate.value,
        ),
      );
    }
    if (lastResetDate.present) {
      map['last_reset_date'] = Variable<String>(
        $StreakStatesTable.$converterlastResetDaten.toSql(lastResetDate.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreakStatesCompanion(')
          ..write('id: $id, ')
          ..write('count: $count, ')
          ..write('lastAllDoneDate: $lastAllDoneDate, ')
          ..write('lastResetDate: $lastResetDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TodosTable todos = $TodosTable(this);
  late final $StreakStatesTable streakStates = $StreakStatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [todos, streakStates];
}

typedef $$TodosTableCreateCompanionBuilder =
    TodosCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isCompleted,
    });
typedef $$TodosTableUpdateCompanionBuilder =
    TodosCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isCompleted,
    });

class $$TodosTableFilterComposer extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodosTableOrderingComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );
}

class $$TodosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodosTable,
          Todo,
          $$TodosTableFilterComposer,
          $$TodosTableOrderingComposer,
          $$TodosTableAnnotationComposer,
          $$TodosTableCreateCompanionBuilder,
          $$TodosTableUpdateCompanionBuilder,
          (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
          Todo,
          PrefetchHooks Function()
        > {
  $$TodosTableTableManager(_$AppDatabase db, $TodosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
              }) =>
                  TodosCompanion(id: id, name: name, isCompleted: isCompleted),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isCompleted = const Value.absent(),
              }) => TodosCompanion.insert(
                id: id,
                name: name,
                isCompleted: isCompleted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodosTable,
      Todo,
      $$TodosTableFilterComposer,
      $$TodosTableOrderingComposer,
      $$TodosTableAnnotationComposer,
      $$TodosTableCreateCompanionBuilder,
      $$TodosTableUpdateCompanionBuilder,
      (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
      Todo,
      PrefetchHooks Function()
    >;
typedef $$StreakStatesTableCreateCompanionBuilder =
    StreakStatesCompanion Function({
      Value<int> id,
      Value<int> count,
      Value<DateTime?> lastAllDoneDate,
      Value<DateTime?> lastResetDate,
    });
typedef $$StreakStatesTableUpdateCompanionBuilder =
    StreakStatesCompanion Function({
      Value<int> id,
      Value<int> count,
      Value<DateTime?> lastAllDoneDate,
      Value<DateTime?> lastResetDate,
    });

class $$StreakStatesTableFilterComposer
    extends Composer<_$AppDatabase, $StreakStatesTable> {
  $$StreakStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String>
  get lastAllDoneDate => $composableBuilder(
    column: $table.lastAllDoneDate,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String>
  get lastResetDate => $composableBuilder(
    column: $table.lastResetDate,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$StreakStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $StreakStatesTable> {
  $$StreakStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastAllDoneDate => $composableBuilder(
    column: $table.lastAllDoneDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastResetDate => $composableBuilder(
    column: $table.lastResetDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreakStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreakStatesTable> {
  $$StreakStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, String> get lastAllDoneDate =>
      $composableBuilder(
        column: $table.lastAllDoneDate,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DateTime?, String> get lastResetDate =>
      $composableBuilder(
        column: $table.lastResetDate,
        builder: (column) => column,
      );
}

class $$StreakStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreakStatesTable,
          StreakRow,
          $$StreakStatesTableFilterComposer,
          $$StreakStatesTableOrderingComposer,
          $$StreakStatesTableAnnotationComposer,
          $$StreakStatesTableCreateCompanionBuilder,
          $$StreakStatesTableUpdateCompanionBuilder,
          (
            StreakRow,
            BaseReferences<_$AppDatabase, $StreakStatesTable, StreakRow>,
          ),
          StreakRow,
          PrefetchHooks Function()
        > {
  $$StreakStatesTableTableManager(_$AppDatabase db, $StreakStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreakStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreakStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreakStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<DateTime?> lastAllDoneDate = const Value.absent(),
                Value<DateTime?> lastResetDate = const Value.absent(),
              }) => StreakStatesCompanion(
                id: id,
                count: count,
                lastAllDoneDate: lastAllDoneDate,
                lastResetDate: lastResetDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<DateTime?> lastAllDoneDate = const Value.absent(),
                Value<DateTime?> lastResetDate = const Value.absent(),
              }) => StreakStatesCompanion.insert(
                id: id,
                count: count,
                lastAllDoneDate: lastAllDoneDate,
                lastResetDate: lastResetDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreakStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreakStatesTable,
      StreakRow,
      $$StreakStatesTableFilterComposer,
      $$StreakStatesTableOrderingComposer,
      $$StreakStatesTableAnnotationComposer,
      $$StreakStatesTableCreateCompanionBuilder,
      $$StreakStatesTableUpdateCompanionBuilder,
      (StreakRow, BaseReferences<_$AppDatabase, $StreakStatesTable, StreakRow>),
      StreakRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db, _db.todos);
  $$StreakStatesTableTableManager get streakStates =>
      $$StreakStatesTableTableManager(_db, _db.streakStates);
}
