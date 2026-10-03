// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WorkoutDaysTable extends WorkoutDays
    with TableInfo<$WorkoutDaysTable, WorkoutDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutDaysTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usualTimeMeta = const VerificationMeta(
    'usualTime',
  );
  @override
  late final GeneratedColumn<String> usualTime = GeneratedColumn<String>(
    'usual_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRestDayMeta = const VerificationMeta(
    'isRestDay',
  );
  @override
  late final GeneratedColumn<bool> isRestDay = GeneratedColumn<bool>(
    'is_rest_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_rest_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weekday,
    title,
    usualTime,
    isRestDay,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('usual_time')) {
      context.handle(
        _usualTimeMeta,
        usualTime.isAcceptableOrUnknown(data['usual_time']!, _usualTimeMeta),
      );
    }
    if (data.containsKey('is_rest_day')) {
      context.handle(
        _isRestDayMeta,
        isRestDay.isAcceptableOrUnknown(data['is_rest_day']!, _isRestDayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      usualTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usual_time'],
      ),
      isRestDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_rest_day'],
      )!,
    );
  }

  @override
  $WorkoutDaysTable createAlias(String alias) {
    return $WorkoutDaysTable(attachedDatabase, alias);
  }
}

class WorkoutDay extends DataClass implements Insertable<WorkoutDay> {
  final int id;
  final int weekday;
  final String title;
  final String? usualTime;
  final bool isRestDay;
  const WorkoutDay({
    required this.id,
    required this.weekday,
    required this.title,
    this.usualTime,
    required this.isRestDay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['weekday'] = Variable<int>(weekday);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || usualTime != null) {
      map['usual_time'] = Variable<String>(usualTime);
    }
    map['is_rest_day'] = Variable<bool>(isRestDay);
    return map;
  }

  WorkoutDaysCompanion toCompanion(bool nullToAbsent) {
    return WorkoutDaysCompanion(
      id: Value(id),
      weekday: Value(weekday),
      title: Value(title),
      usualTime: usualTime == null && nullToAbsent
          ? const Value.absent()
          : Value(usualTime),
      isRestDay: Value(isRestDay),
    );
  }

  factory WorkoutDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutDay(
      id: serializer.fromJson<int>(json['id']),
      weekday: serializer.fromJson<int>(json['weekday']),
      title: serializer.fromJson<String>(json['title']),
      usualTime: serializer.fromJson<String?>(json['usualTime']),
      isRestDay: serializer.fromJson<bool>(json['isRestDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekday': serializer.toJson<int>(weekday),
      'title': serializer.toJson<String>(title),
      'usualTime': serializer.toJson<String?>(usualTime),
      'isRestDay': serializer.toJson<bool>(isRestDay),
    };
  }

  WorkoutDay copyWith({
    int? id,
    int? weekday,
    String? title,
    Value<String?> usualTime = const Value.absent(),
    bool? isRestDay,
  }) => WorkoutDay(
    id: id ?? this.id,
    weekday: weekday ?? this.weekday,
    title: title ?? this.title,
    usualTime: usualTime.present ? usualTime.value : this.usualTime,
    isRestDay: isRestDay ?? this.isRestDay,
  );
  WorkoutDay copyWithCompanion(WorkoutDaysCompanion data) {
    return WorkoutDay(
      id: data.id.present ? data.id.value : this.id,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      title: data.title.present ? data.title.value : this.title,
      usualTime: data.usualTime.present ? data.usualTime.value : this.usualTime,
      isRestDay: data.isRestDay.present ? data.isRestDay.value : this.isRestDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutDay(')
          ..write('id: $id, ')
          ..write('weekday: $weekday, ')
          ..write('title: $title, ')
          ..write('usualTime: $usualTime, ')
          ..write('isRestDay: $isRestDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weekday, title, usualTime, isRestDay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutDay &&
          other.id == this.id &&
          other.weekday == this.weekday &&
          other.title == this.title &&
          other.usualTime == this.usualTime &&
          other.isRestDay == this.isRestDay);
}

class WorkoutDaysCompanion extends UpdateCompanion<WorkoutDay> {
  final Value<int> id;
  final Value<int> weekday;
  final Value<String> title;
  final Value<String?> usualTime;
  final Value<bool> isRestDay;
  const WorkoutDaysCompanion({
    this.id = const Value.absent(),
    this.weekday = const Value.absent(),
    this.title = const Value.absent(),
    this.usualTime = const Value.absent(),
    this.isRestDay = const Value.absent(),
  });
  WorkoutDaysCompanion.insert({
    this.id = const Value.absent(),
    required int weekday,
    required String title,
    this.usualTime = const Value.absent(),
    this.isRestDay = const Value.absent(),
  }) : weekday = Value(weekday),
       title = Value(title);
  static Insertable<WorkoutDay> custom({
    Expression<int>? id,
    Expression<int>? weekday,
    Expression<String>? title,
    Expression<String>? usualTime,
    Expression<bool>? isRestDay,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekday != null) 'weekday': weekday,
      if (title != null) 'title': title,
      if (usualTime != null) 'usual_time': usualTime,
      if (isRestDay != null) 'is_rest_day': isRestDay,
    });
  }

  WorkoutDaysCompanion copyWith({
    Value<int>? id,
    Value<int>? weekday,
    Value<String>? title,
    Value<String?>? usualTime,
    Value<bool>? isRestDay,
  }) {
    return WorkoutDaysCompanion(
      id: id ?? this.id,
      weekday: weekday ?? this.weekday,
      title: title ?? this.title,
      usualTime: usualTime ?? this.usualTime,
      isRestDay: isRestDay ?? this.isRestDay,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (usualTime.present) {
      map['usual_time'] = Variable<String>(usualTime.value);
    }
    if (isRestDay.present) {
      map['is_rest_day'] = Variable<bool>(isRestDay.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutDaysCompanion(')
          ..write('id: $id, ')
          ..write('weekday: $weekday, ')
          ..write('title: $title, ')
          ..write('usualTime: $usualTime, ')
          ..write('isRestDay: $isRestDay')
          ..write(')'))
        .toString();
  }
}

class $PlannedExercisesTable extends PlannedExercises
    with TableInfo<$PlannedExercisesTable, PlannedExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlannedExercisesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _workoutDayIdMeta = const VerificationMeta(
    'workoutDayId',
  );
  @override
  late final GeneratedColumn<int> workoutDayId = GeneratedColumn<int>(
    'workout_day_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_days (id) ON DELETE CASCADE',
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
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutDayId,
    name,
    targetSets,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planned_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlannedExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_day_id')) {
      context.handle(
        _workoutDayIdMeta,
        workoutDayId.isAcceptableOrUnknown(
          data['workout_day_id']!,
          _workoutDayIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutDayIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlannedExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannedExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workoutDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_day_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $PlannedExercisesTable createAlias(String alias) {
    return $PlannedExercisesTable(attachedDatabase, alias);
  }
}

class PlannedExercise extends DataClass implements Insertable<PlannedExercise> {
  final int id;
  final int workoutDayId;
  final String name;
  final int targetSets;
  final int orderIndex;
  const PlannedExercise({
    required this.id,
    required this.workoutDayId,
    required this.name,
    required this.targetSets,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_day_id'] = Variable<int>(workoutDayId);
    map['name'] = Variable<String>(name);
    map['target_sets'] = Variable<int>(targetSets);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  PlannedExercisesCompanion toCompanion(bool nullToAbsent) {
    return PlannedExercisesCompanion(
      id: Value(id),
      workoutDayId: Value(workoutDayId),
      name: Value(name),
      targetSets: Value(targetSets),
      orderIndex: Value(orderIndex),
    );
  }

  factory PlannedExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannedExercise(
      id: serializer.fromJson<int>(json['id']),
      workoutDayId: serializer.fromJson<int>(json['workoutDayId']),
      name: serializer.fromJson<String>(json['name']),
      targetSets: serializer.fromJson<int>(json['targetSets']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutDayId': serializer.toJson<int>(workoutDayId),
      'name': serializer.toJson<String>(name),
      'targetSets': serializer.toJson<int>(targetSets),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  PlannedExercise copyWith({
    int? id,
    int? workoutDayId,
    String? name,
    int? targetSets,
    int? orderIndex,
  }) => PlannedExercise(
    id: id ?? this.id,
    workoutDayId: workoutDayId ?? this.workoutDayId,
    name: name ?? this.name,
    targetSets: targetSets ?? this.targetSets,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  PlannedExercise copyWithCompanion(PlannedExercisesCompanion data) {
    return PlannedExercise(
      id: data.id.present ? data.id.value : this.id,
      workoutDayId: data.workoutDayId.present
          ? data.workoutDayId.value
          : this.workoutDayId,
      name: data.name.present ? data.name.value : this.name,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannedExercise(')
          ..write('id: $id, ')
          ..write('workoutDayId: $workoutDayId, ')
          ..write('name: $name, ')
          ..write('targetSets: $targetSets, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, workoutDayId, name, targetSets, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannedExercise &&
          other.id == this.id &&
          other.workoutDayId == this.workoutDayId &&
          other.name == this.name &&
          other.targetSets == this.targetSets &&
          other.orderIndex == this.orderIndex);
}

class PlannedExercisesCompanion extends UpdateCompanion<PlannedExercise> {
  final Value<int> id;
  final Value<int> workoutDayId;
  final Value<String> name;
  final Value<int> targetSets;
  final Value<int> orderIndex;
  const PlannedExercisesCompanion({
    this.id = const Value.absent(),
    this.workoutDayId = const Value.absent(),
    this.name = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  PlannedExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int workoutDayId,
    required String name,
    this.targetSets = const Value.absent(),
    this.orderIndex = const Value.absent(),
  }) : workoutDayId = Value(workoutDayId),
       name = Value(name);
  static Insertable<PlannedExercise> custom({
    Expression<int>? id,
    Expression<int>? workoutDayId,
    Expression<String>? name,
    Expression<int>? targetSets,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutDayId != null) 'workout_day_id': workoutDayId,
      if (name != null) 'name': name,
      if (targetSets != null) 'target_sets': targetSets,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  PlannedExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutDayId,
    Value<String>? name,
    Value<int>? targetSets,
    Value<int>? orderIndex,
  }) {
    return PlannedExercisesCompanion(
      id: id ?? this.id,
      workoutDayId: workoutDayId ?? this.workoutDayId,
      name: name ?? this.name,
      targetSets: targetSets ?? this.targetSets,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutDayId.present) {
      map['workout_day_id'] = Variable<int>(workoutDayId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannedExercisesCompanion(')
          ..write('id: $id, ')
          ..write('workoutDayId: $workoutDayId, ')
          ..write('name: $name, ')
          ..write('targetSets: $targetSets, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _workoutDayIdMeta = const VerificationMeta(
    'workoutDayId',
  );
  @override
  late final GeneratedColumn<int> workoutDayId = GeneratedColumn<int>(
    'workout_day_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_days (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, workoutDayId, date, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_day_id')) {
      context.handle(
        _workoutDayIdMeta,
        workoutDayId.isAcceptableOrUnknown(
          data['workout_day_id']!,
          _workoutDayIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutDayIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workoutDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_day_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final int id;
  final int workoutDayId;
  final DateTime date;
  final String? notes;
  const WorkoutSession({
    required this.id,
    required this.workoutDayId,
    required this.date,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_day_id'] = Variable<int>(workoutDayId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      workoutDayId: Value(workoutDayId),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<int>(json['id']),
      workoutDayId: serializer.fromJson<int>(json['workoutDayId']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutDayId': serializer.toJson<int>(workoutDayId),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WorkoutSession copyWith({
    int? id,
    int? workoutDayId,
    DateTime? date,
    Value<String?> notes = const Value.absent(),
  }) => WorkoutSession(
    id: id ?? this.id,
    workoutDayId: workoutDayId ?? this.workoutDayId,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      workoutDayId: data.workoutDayId.present
          ? data.workoutDayId.value
          : this.workoutDayId,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('workoutDayId: $workoutDayId, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workoutDayId, date, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.workoutDayId == this.workoutDayId &&
          other.date == this.date &&
          other.notes == this.notes);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<int> id;
  final Value<int> workoutDayId;
  final Value<DateTime> date;
  final Value<String?> notes;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.workoutDayId = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int workoutDayId,
    required DateTime date,
    this.notes = const Value.absent(),
  }) : workoutDayId = Value(workoutDayId),
       date = Value(date);
  static Insertable<WorkoutSession> custom({
    Expression<int>? id,
    Expression<int>? workoutDayId,
    Expression<DateTime>? date,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutDayId != null) 'workout_day_id': workoutDayId,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutDayId,
    Value<DateTime>? date,
    Value<String?>? notes,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      workoutDayId: workoutDayId ?? this.workoutDayId,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutDayId.present) {
      map['workout_day_id'] = Variable<int>(workoutDayId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('workoutDayId: $workoutDayId, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SetLogsTable extends SetLogs with TableInfo<$SetLogsTable, SetLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPrMeta = const VerificationMeta('isPr');
  @override
  late final GeneratedColumn<bool> isPr = GeneratedColumn<bool>(
    'is_pr',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pr" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseName,
    setNumber,
    weightKg,
    reps,
    rpe,
    isPr,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('is_pr')) {
      context.handle(
        _isPrMeta,
        isPr.isAcceptableOrUnknown(data['is_pr']!, _isPrMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe'],
      ),
      isPr: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pr'],
      )!,
    );
  }

  @override
  $SetLogsTable createAlias(String alias) {
    return $SetLogsTable(attachedDatabase, alias);
  }
}

class SetLog extends DataClass implements Insertable<SetLog> {
  final int id;
  final int sessionId;
  final String exerciseName;
  final int setNumber;
  final double weightKg;
  final int reps;
  final double? rpe;
  final bool isPr;
  const SetLog({
    required this.id,
    required this.sessionId,
    required this.exerciseName,
    required this.setNumber,
    required this.weightKg,
    required this.reps,
    this.rpe,
    required this.isPr,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['exercise_name'] = Variable<String>(exerciseName);
    map['set_number'] = Variable<int>(setNumber);
    map['weight_kg'] = Variable<double>(weightKg);
    map['reps'] = Variable<int>(reps);
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    map['is_pr'] = Variable<bool>(isPr);
    return map;
  }

  SetLogsCompanion toCompanion(bool nullToAbsent) {
    return SetLogsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseName: Value(exerciseName),
      setNumber: Value(setNumber),
      weightKg: Value(weightKg),
      reps: Value(reps),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      isPr: Value(isPr),
    );
  }

  factory SetLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetLog(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      reps: serializer.fromJson<int>(json['reps']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      isPr: serializer.fromJson<bool>(json['isPr']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'setNumber': serializer.toJson<int>(setNumber),
      'weightKg': serializer.toJson<double>(weightKg),
      'reps': serializer.toJson<int>(reps),
      'rpe': serializer.toJson<double?>(rpe),
      'isPr': serializer.toJson<bool>(isPr),
    };
  }

  SetLog copyWith({
    int? id,
    int? sessionId,
    String? exerciseName,
    int? setNumber,
    double? weightKg,
    int? reps,
    Value<double?> rpe = const Value.absent(),
    bool? isPr,
  }) => SetLog(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseName: exerciseName ?? this.exerciseName,
    setNumber: setNumber ?? this.setNumber,
    weightKg: weightKg ?? this.weightKg,
    reps: reps ?? this.reps,
    rpe: rpe.present ? rpe.value : this.rpe,
    isPr: isPr ?? this.isPr,
  );
  SetLog copyWithCompanion(SetLogsCompanion data) {
    return SetLog(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      isPr: data.isPr.present ? data.isPr.value : this.isPr,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetLog(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('setNumber: $setNumber, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('isPr: $isPr')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exerciseName,
    setNumber,
    weightKg,
    reps,
    rpe,
    isPr,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetLog &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseName == this.exerciseName &&
          other.setNumber == this.setNumber &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.rpe == this.rpe &&
          other.isPr == this.isPr);
}

class SetLogsCompanion extends UpdateCompanion<SetLog> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> exerciseName;
  final Value<int> setNumber;
  final Value<double> weightKg;
  final Value<int> reps;
  final Value<double?> rpe;
  final Value<bool> isPr;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.rpe = const Value.absent(),
    this.isPr = const Value.absent(),
  });
  SetLogsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String exerciseName,
    required int setNumber,
    required double weightKg,
    required int reps,
    this.rpe = const Value.absent(),
    this.isPr = const Value.absent(),
  }) : sessionId = Value(sessionId),
       exerciseName = Value(exerciseName),
       setNumber = Value(setNumber),
       weightKg = Value(weightKg),
       reps = Value(reps);
  static Insertable<SetLog> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? exerciseName,
    Expression<int>? setNumber,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<double>? rpe,
    Expression<bool>? isPr,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (setNumber != null) 'set_number': setNumber,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (rpe != null) 'rpe': rpe,
      if (isPr != null) 'is_pr': isPr,
    });
  }

  SetLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? exerciseName,
    Value<int>? setNumber,
    Value<double>? weightKg,
    Value<int>? reps,
    Value<double?>? rpe,
    Value<bool>? isPr,
  }) {
    return SetLogsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseName: exerciseName ?? this.exerciseName,
      setNumber: setNumber ?? this.setNumber,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      isPr: isPr ?? this.isPr,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (isPr.present) {
      map['is_pr'] = Variable<bool>(isPr.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('setNumber: $setNumber, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('isPr: $isPr')
          ..write(')'))
        .toString();
  }
}

class $PersonalRecordsTable extends PersonalRecords
    with TableInfo<$PersonalRecordsTable, PersonalRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  @override
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseName,
    weightKg,
    reps,
    achievedAt,
    photoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonalRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      achievedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}achieved_at'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
    );
  }

  @override
  $PersonalRecordsTable createAlias(String alias) {
    return $PersonalRecordsTable(attachedDatabase, alias);
  }
}

class PersonalRecord extends DataClass implements Insertable<PersonalRecord> {
  final int id;
  final String exerciseName;
  final double weightKg;
  final int reps;
  final DateTime achievedAt;
  final String? photoPath;
  const PersonalRecord({
    required this.id,
    required this.exerciseName,
    required this.weightKg,
    required this.reps,
    required this.achievedAt,
    this.photoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_name'] = Variable<String>(exerciseName);
    map['weight_kg'] = Variable<double>(weightKg);
    map['reps'] = Variable<int>(reps);
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  PersonalRecordsCompanion toCompanion(bool nullToAbsent) {
    return PersonalRecordsCompanion(
      id: Value(id),
      exerciseName: Value(exerciseName),
      weightKg: Value(weightKg),
      reps: Value(reps),
      achievedAt: Value(achievedAt),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory PersonalRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalRecord(
      id: serializer.fromJson<int>(json['id']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      reps: serializer.fromJson<int>(json['reps']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'weightKg': serializer.toJson<double>(weightKg),
      'reps': serializer.toJson<int>(reps),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  PersonalRecord copyWith({
    int? id,
    String? exerciseName,
    double? weightKg,
    int? reps,
    DateTime? achievedAt,
    Value<String?> photoPath = const Value.absent(),
  }) => PersonalRecord(
    id: id ?? this.id,
    exerciseName: exerciseName ?? this.exerciseName,
    weightKg: weightKg ?? this.weightKg,
    reps: reps ?? this.reps,
    achievedAt: achievedAt ?? this.achievedAt,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
  );
  PersonalRecord copyWithCompanion(PersonalRecordsCompanion data) {
    return PersonalRecord(
      id: data.id.present ? data.id.value : this.id,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecord(')
          ..write('id: $id, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, exerciseName, weightKg, reps, achievedAt, photoPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalRecord &&
          other.id == this.id &&
          other.exerciseName == this.exerciseName &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.achievedAt == this.achievedAt &&
          other.photoPath == this.photoPath);
}

class PersonalRecordsCompanion extends UpdateCompanion<PersonalRecord> {
  final Value<int> id;
  final Value<String> exerciseName;
  final Value<double> weightKg;
  final Value<int> reps;
  final Value<DateTime> achievedAt;
  final Value<String?> photoPath;
  const PersonalRecordsCompanion({
    this.id = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.photoPath = const Value.absent(),
  });
  PersonalRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String exerciseName,
    required double weightKg,
    required int reps,
    required DateTime achievedAt,
    this.photoPath = const Value.absent(),
  }) : exerciseName = Value(exerciseName),
       weightKg = Value(weightKg),
       reps = Value(reps),
       achievedAt = Value(achievedAt);
  static Insertable<PersonalRecord> custom({
    Expression<int>? id,
    Expression<String>? exerciseName,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<DateTime>? achievedAt,
    Expression<String>? photoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (photoPath != null) 'photo_path': photoPath,
    });
  }

  PersonalRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? exerciseName,
    Value<double>? weightKg,
    Value<int>? reps,
    Value<DateTime>? achievedAt,
    Value<String?>? photoPath,
  }) {
    return PersonalRecordsCompanion(
      id: id ?? this.id,
      exerciseName: exerciseName ?? this.exerciseName,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      achievedAt: achievedAt ?? this.achievedAt,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }
}

class $RoutineItemsTable extends RoutineItems
    with TableInfo<$RoutineItemsTable, RoutineItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultTimeMeta = const VerificationMeta(
    'defaultTime',
  );
  @override
  late final GeneratedColumn<String> defaultTime = GeneratedColumn<String>(
    'default_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    category,
    defaultTime,
    orderIndex,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('default_time')) {
      context.handle(
        _defaultTimeMeta,
        defaultTime.isAcceptableOrUnknown(
          data['default_time']!,
          _defaultTimeMeta,
        ),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      defaultTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_time'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $RoutineItemsTable createAlias(String alias) {
    return $RoutineItemsTable(attachedDatabase, alias);
  }
}

class RoutineItem extends DataClass implements Insertable<RoutineItem> {
  final int id;
  final String label;
  final String category;
  final String? defaultTime;
  final int orderIndex;
  final bool isActive;
  const RoutineItem({
    required this.id,
    required this.label,
    required this.category,
    this.defaultTime,
    required this.orderIndex,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || defaultTime != null) {
      map['default_time'] = Variable<String>(defaultTime);
    }
    map['order_index'] = Variable<int>(orderIndex);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  RoutineItemsCompanion toCompanion(bool nullToAbsent) {
    return RoutineItemsCompanion(
      id: Value(id),
      label: Value(label),
      category: Value(category),
      defaultTime: defaultTime == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultTime),
      orderIndex: Value(orderIndex),
      isActive: Value(isActive),
    );
  }

  factory RoutineItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineItem(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      category: serializer.fromJson<String>(json['category']),
      defaultTime: serializer.fromJson<String?>(json['defaultTime']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'category': serializer.toJson<String>(category),
      'defaultTime': serializer.toJson<String?>(defaultTime),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  RoutineItem copyWith({
    int? id,
    String? label,
    String? category,
    Value<String?> defaultTime = const Value.absent(),
    int? orderIndex,
    bool? isActive,
  }) => RoutineItem(
    id: id ?? this.id,
    label: label ?? this.label,
    category: category ?? this.category,
    defaultTime: defaultTime.present ? defaultTime.value : this.defaultTime,
    orderIndex: orderIndex ?? this.orderIndex,
    isActive: isActive ?? this.isActive,
  );
  RoutineItem copyWithCompanion(RoutineItemsCompanion data) {
    return RoutineItem(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      category: data.category.present ? data.category.value : this.category,
      defaultTime: data.defaultTime.present
          ? data.defaultTime.value
          : this.defaultTime,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineItem(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('category: $category, ')
          ..write('defaultTime: $defaultTime, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, label, category, defaultTime, orderIndex, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineItem &&
          other.id == this.id &&
          other.label == this.label &&
          other.category == this.category &&
          other.defaultTime == this.defaultTime &&
          other.orderIndex == this.orderIndex &&
          other.isActive == this.isActive);
}

class RoutineItemsCompanion extends UpdateCompanion<RoutineItem> {
  final Value<int> id;
  final Value<String> label;
  final Value<String> category;
  final Value<String?> defaultTime;
  final Value<int> orderIndex;
  final Value<bool> isActive;
  const RoutineItemsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.category = const Value.absent(),
    this.defaultTime = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  RoutineItemsCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    required String category,
    this.defaultTime = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : label = Value(label),
       category = Value(category);
  static Insertable<RoutineItem> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<String>? category,
    Expression<String>? defaultTime,
    Expression<int>? orderIndex,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (category != null) 'category': category,
      if (defaultTime != null) 'default_time': defaultTime,
      if (orderIndex != null) 'order_index': orderIndex,
      if (isActive != null) 'is_active': isActive,
    });
  }

  RoutineItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<String>? category,
    Value<String?>? defaultTime,
    Value<int>? orderIndex,
    Value<bool>? isActive,
  }) {
    return RoutineItemsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      category: category ?? this.category,
      defaultTime: defaultTime ?? this.defaultTime,
      orderIndex: orderIndex ?? this.orderIndex,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (defaultTime.present) {
      map['default_time'] = Variable<String>(defaultTime.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineItemsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('category: $category, ')
          ..write('defaultTime: $defaultTime, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $RoutineChecksTable extends RoutineChecks
    with TableInfo<$RoutineChecksTable, RoutineCheck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineChecksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _routineItemIdMeta = const VerificationMeta(
    'routineItemId',
  );
  @override
  late final GeneratedColumn<int> routineItemId = GeneratedColumn<int>(
    'routine_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routine_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<DateTime> doneAt = GeneratedColumn<DateTime>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routineItemId,
    date,
    isDone,
    doneAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_checks';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineCheck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_item_id')) {
      context.handle(
        _routineItemIdMeta,
        routineItemId.isAcceptableOrUnknown(
          data['routine_item_id']!,
          _routineItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_routineItemIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineCheck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineCheck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      routineItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}routine_item_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_at'],
      ),
    );
  }

  @override
  $RoutineChecksTable createAlias(String alias) {
    return $RoutineChecksTable(attachedDatabase, alias);
  }
}

class RoutineCheck extends DataClass implements Insertable<RoutineCheck> {
  final int id;
  final int routineItemId;
  final DateTime date;
  final bool isDone;
  final DateTime? doneAt;
  const RoutineCheck({
    required this.id,
    required this.routineItemId,
    required this.date,
    required this.isDone,
    this.doneAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['routine_item_id'] = Variable<int>(routineItemId);
    map['date'] = Variable<DateTime>(date);
    map['is_done'] = Variable<bool>(isDone);
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<DateTime>(doneAt);
    }
    return map;
  }

  RoutineChecksCompanion toCompanion(bool nullToAbsent) {
    return RoutineChecksCompanion(
      id: Value(id),
      routineItemId: Value(routineItemId),
      date: Value(date),
      isDone: Value(isDone),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
    );
  }

  factory RoutineCheck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineCheck(
      id: serializer.fromJson<int>(json['id']),
      routineItemId: serializer.fromJson<int>(json['routineItemId']),
      date: serializer.fromJson<DateTime>(json['date']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      doneAt: serializer.fromJson<DateTime?>(json['doneAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routineItemId': serializer.toJson<int>(routineItemId),
      'date': serializer.toJson<DateTime>(date),
      'isDone': serializer.toJson<bool>(isDone),
      'doneAt': serializer.toJson<DateTime?>(doneAt),
    };
  }

  RoutineCheck copyWith({
    int? id,
    int? routineItemId,
    DateTime? date,
    bool? isDone,
    Value<DateTime?> doneAt = const Value.absent(),
  }) => RoutineCheck(
    id: id ?? this.id,
    routineItemId: routineItemId ?? this.routineItemId,
    date: date ?? this.date,
    isDone: isDone ?? this.isDone,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
  );
  RoutineCheck copyWithCompanion(RoutineChecksCompanion data) {
    return RoutineCheck(
      id: data.id.present ? data.id.value : this.id,
      routineItemId: data.routineItemId.present
          ? data.routineItemId.value
          : this.routineItemId,
      date: data.date.present ? data.date.value : this.date,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineCheck(')
          ..write('id: $id, ')
          ..write('routineItemId: $routineItemId, ')
          ..write('date: $date, ')
          ..write('isDone: $isDone, ')
          ..write('doneAt: $doneAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routineItemId, date, isDone, doneAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineCheck &&
          other.id == this.id &&
          other.routineItemId == this.routineItemId &&
          other.date == this.date &&
          other.isDone == this.isDone &&
          other.doneAt == this.doneAt);
}

class RoutineChecksCompanion extends UpdateCompanion<RoutineCheck> {
  final Value<int> id;
  final Value<int> routineItemId;
  final Value<DateTime> date;
  final Value<bool> isDone;
  final Value<DateTime?> doneAt;
  const RoutineChecksCompanion({
    this.id = const Value.absent(),
    this.routineItemId = const Value.absent(),
    this.date = const Value.absent(),
    this.isDone = const Value.absent(),
    this.doneAt = const Value.absent(),
  });
  RoutineChecksCompanion.insert({
    this.id = const Value.absent(),
    required int routineItemId,
    required DateTime date,
    this.isDone = const Value.absent(),
    this.doneAt = const Value.absent(),
  }) : routineItemId = Value(routineItemId),
       date = Value(date);
  static Insertable<RoutineCheck> custom({
    Expression<int>? id,
    Expression<int>? routineItemId,
    Expression<DateTime>? date,
    Expression<bool>? isDone,
    Expression<DateTime>? doneAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineItemId != null) 'routine_item_id': routineItemId,
      if (date != null) 'date': date,
      if (isDone != null) 'is_done': isDone,
      if (doneAt != null) 'done_at': doneAt,
    });
  }

  RoutineChecksCompanion copyWith({
    Value<int>? id,
    Value<int>? routineItemId,
    Value<DateTime>? date,
    Value<bool>? isDone,
    Value<DateTime?>? doneAt,
  }) {
    return RoutineChecksCompanion(
      id: id ?? this.id,
      routineItemId: routineItemId ?? this.routineItemId,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
      doneAt: doneAt ?? this.doneAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routineItemId.present) {
      map['routine_item_id'] = Variable<int>(routineItemId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<DateTime>(doneAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineChecksCompanion(')
          ..write('id: $id, ')
          ..write('routineItemId: $routineItemId, ')
          ..write('date: $date, ')
          ..write('isDone: $isDone, ')
          ..write('doneAt: $doneAt')
          ..write(')'))
        .toString();
  }
}

class $MealPrepTasksTable extends MealPrepTasks
    with TableInfo<$MealPrepTasksTable, MealPrepTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPrepTasksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, label, weekday, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_prep_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealPrepTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPrepTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPrepTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $MealPrepTasksTable createAlias(String alias) {
    return $MealPrepTasksTable(attachedDatabase, alias);
  }
}

class MealPrepTask extends DataClass implements Insertable<MealPrepTask> {
  final int id;
  final String label;
  final int weekday;
  final bool isActive;
  const MealPrepTask({
    required this.id,
    required this.label,
    required this.weekday,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    map['weekday'] = Variable<int>(weekday);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  MealPrepTasksCompanion toCompanion(bool nullToAbsent) {
    return MealPrepTasksCompanion(
      id: Value(id),
      label: Value(label),
      weekday: Value(weekday),
      isActive: Value(isActive),
    );
  }

  factory MealPrepTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPrepTask(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      weekday: serializer.fromJson<int>(json['weekday']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'weekday': serializer.toJson<int>(weekday),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  MealPrepTask copyWith({
    int? id,
    String? label,
    int? weekday,
    bool? isActive,
  }) => MealPrepTask(
    id: id ?? this.id,
    label: label ?? this.label,
    weekday: weekday ?? this.weekday,
    isActive: isActive ?? this.isActive,
  );
  MealPrepTask copyWithCompanion(MealPrepTasksCompanion data) {
    return MealPrepTask(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPrepTask(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('weekday: $weekday, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, weekday, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPrepTask &&
          other.id == this.id &&
          other.label == this.label &&
          other.weekday == this.weekday &&
          other.isActive == this.isActive);
}

class MealPrepTasksCompanion extends UpdateCompanion<MealPrepTask> {
  final Value<int> id;
  final Value<String> label;
  final Value<int> weekday;
  final Value<bool> isActive;
  const MealPrepTasksCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.weekday = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  MealPrepTasksCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    required int weekday,
    this.isActive = const Value.absent(),
  }) : label = Value(label),
       weekday = Value(weekday);
  static Insertable<MealPrepTask> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<int>? weekday,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (weekday != null) 'weekday': weekday,
      if (isActive != null) 'is_active': isActive,
    });
  }

  MealPrepTasksCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<int>? weekday,
    Value<bool>? isActive,
  }) {
    return MealPrepTasksCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      weekday: weekday ?? this.weekday,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPrepTasksCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('weekday: $weekday, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MealPrepChecksTable extends MealPrepChecks
    with TableInfo<$MealPrepChecksTable, MealPrepCheck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPrepChecksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _mealPrepTaskIdMeta = const VerificationMeta(
    'mealPrepTaskId',
  );
  @override
  late final GeneratedColumn<int> mealPrepTaskId = GeneratedColumn<int>(
    'meal_prep_task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meal_prep_tasks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<DateTime> weekStart = GeneratedColumn<DateTime>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, mealPrepTaskId, weekStart, isDone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_prep_checks';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealPrepCheck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_prep_task_id')) {
      context.handle(
        _mealPrepTaskIdMeta,
        mealPrepTaskId.isAcceptableOrUnknown(
          data['meal_prep_task_id']!,
          _mealPrepTaskIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mealPrepTaskIdMeta);
    }
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    } else if (isInserting) {
      context.missing(_weekStartMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPrepCheck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPrepCheck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mealPrepTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_prep_task_id'],
      )!,
      weekStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}week_start'],
      )!,
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
    );
  }

  @override
  $MealPrepChecksTable createAlias(String alias) {
    return $MealPrepChecksTable(attachedDatabase, alias);
  }
}

class MealPrepCheck extends DataClass implements Insertable<MealPrepCheck> {
  final int id;
  final int mealPrepTaskId;
  final DateTime weekStart;
  final bool isDone;
  const MealPrepCheck({
    required this.id,
    required this.mealPrepTaskId,
    required this.weekStart,
    required this.isDone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_prep_task_id'] = Variable<int>(mealPrepTaskId);
    map['week_start'] = Variable<DateTime>(weekStart);
    map['is_done'] = Variable<bool>(isDone);
    return map;
  }

  MealPrepChecksCompanion toCompanion(bool nullToAbsent) {
    return MealPrepChecksCompanion(
      id: Value(id),
      mealPrepTaskId: Value(mealPrepTaskId),
      weekStart: Value(weekStart),
      isDone: Value(isDone),
    );
  }

  factory MealPrepCheck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPrepCheck(
      id: serializer.fromJson<int>(json['id']),
      mealPrepTaskId: serializer.fromJson<int>(json['mealPrepTaskId']),
      weekStart: serializer.fromJson<DateTime>(json['weekStart']),
      isDone: serializer.fromJson<bool>(json['isDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealPrepTaskId': serializer.toJson<int>(mealPrepTaskId),
      'weekStart': serializer.toJson<DateTime>(weekStart),
      'isDone': serializer.toJson<bool>(isDone),
    };
  }

  MealPrepCheck copyWith({
    int? id,
    int? mealPrepTaskId,
    DateTime? weekStart,
    bool? isDone,
  }) => MealPrepCheck(
    id: id ?? this.id,
    mealPrepTaskId: mealPrepTaskId ?? this.mealPrepTaskId,
    weekStart: weekStart ?? this.weekStart,
    isDone: isDone ?? this.isDone,
  );
  MealPrepCheck copyWithCompanion(MealPrepChecksCompanion data) {
    return MealPrepCheck(
      id: data.id.present ? data.id.value : this.id,
      mealPrepTaskId: data.mealPrepTaskId.present
          ? data.mealPrepTaskId.value
          : this.mealPrepTaskId,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPrepCheck(')
          ..write('id: $id, ')
          ..write('mealPrepTaskId: $mealPrepTaskId, ')
          ..write('weekStart: $weekStart, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mealPrepTaskId, weekStart, isDone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPrepCheck &&
          other.id == this.id &&
          other.mealPrepTaskId == this.mealPrepTaskId &&
          other.weekStart == this.weekStart &&
          other.isDone == this.isDone);
}

class MealPrepChecksCompanion extends UpdateCompanion<MealPrepCheck> {
  final Value<int> id;
  final Value<int> mealPrepTaskId;
  final Value<DateTime> weekStart;
  final Value<bool> isDone;
  const MealPrepChecksCompanion({
    this.id = const Value.absent(),
    this.mealPrepTaskId = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.isDone = const Value.absent(),
  });
  MealPrepChecksCompanion.insert({
    this.id = const Value.absent(),
    required int mealPrepTaskId,
    required DateTime weekStart,
    this.isDone = const Value.absent(),
  }) : mealPrepTaskId = Value(mealPrepTaskId),
       weekStart = Value(weekStart);
  static Insertable<MealPrepCheck> custom({
    Expression<int>? id,
    Expression<int>? mealPrepTaskId,
    Expression<DateTime>? weekStart,
    Expression<bool>? isDone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealPrepTaskId != null) 'meal_prep_task_id': mealPrepTaskId,
      if (weekStart != null) 'week_start': weekStart,
      if (isDone != null) 'is_done': isDone,
    });
  }

  MealPrepChecksCompanion copyWith({
    Value<int>? id,
    Value<int>? mealPrepTaskId,
    Value<DateTime>? weekStart,
    Value<bool>? isDone,
  }) {
    return MealPrepChecksCompanion(
      id: id ?? this.id,
      mealPrepTaskId: mealPrepTaskId ?? this.mealPrepTaskId,
      weekStart: weekStart ?? this.weekStart,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealPrepTaskId.present) {
      map['meal_prep_task_id'] = Variable<int>(mealPrepTaskId.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<DateTime>(weekStart.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPrepChecksCompanion(')
          ..write('id: $id, ')
          ..write('mealPrepTaskId: $mealPrepTaskId, ')
          ..write('weekStart: $weekStart, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }
}

class $BodyLogsTable extends BodyLogs with TableInfo<$BodyLogsTable, BodyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, weightKg, photoPath, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $BodyLogsTable createAlias(String alias) {
    return $BodyLogsTable(attachedDatabase, alias);
  }
}

class BodyLog extends DataClass implements Insertable<BodyLog> {
  final int id;
  final DateTime date;
  final double weightKg;
  final String? photoPath;
  final String? note;
  const BodyLog({
    required this.id,
    required this.date,
    required this.weightKg,
    this.photoPath,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  BodyLogsCompanion toCompanion(bool nullToAbsent) {
    return BodyLogsCompanion(
      id: Value(id),
      date: Value(date),
      weightKg: Value(weightKg),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory BodyLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'weightKg': serializer.toJson<double>(weightKg),
      'photoPath': serializer.toJson<String?>(photoPath),
      'note': serializer.toJson<String?>(note),
    };
  }

  BodyLog copyWith({
    int? id,
    DateTime? date,
    double? weightKg,
    Value<String?> photoPath = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => BodyLog(
    id: id ?? this.id,
    date: date ?? this.date,
    weightKg: weightKg ?? this.weightKg,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    note: note.present ? note.value : this.note,
  );
  BodyLog copyWithCompanion(BodyLogsCompanion data) {
    return BodyLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('photoPath: $photoPath, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, weightKg, photoPath, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.weightKg == this.weightKg &&
          other.photoPath == this.photoPath &&
          other.note == this.note);
}

class BodyLogsCompanion extends UpdateCompanion<BodyLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double> weightKg;
  final Value<String?> photoPath;
  final Value<String?> note;
  const BodyLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.note = const Value.absent(),
  });
  BodyLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required double weightKg,
    this.photoPath = const Value.absent(),
    this.note = const Value.absent(),
  }) : date = Value(date),
       weightKg = Value(weightKg);
  static Insertable<BodyLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? weightKg,
    Expression<String>? photoPath,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (weightKg != null) 'weight_kg': weightKg,
      if (photoPath != null) 'photo_path': photoPath,
      if (note != null) 'note': note,
    });
  }

  BodyLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<double>? weightKg,
    Value<String?>? photoPath,
    Value<String?>? note,
  }) {
    return BodyLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      photoPath: photoPath ?? this.photoPath,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('photoPath: $photoPath, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _notifyDayBeforeMeta = const VerificationMeta(
    'notifyDayBefore',
  );
  @override
  late final GeneratedColumn<bool> notifyDayBefore = GeneratedColumn<bool>(
    'notify_day_before',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_day_before" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notifyBedtimeMeta = const VerificationMeta(
    'notifyBedtime',
  );
  @override
  late final GeneratedColumn<bool> notifyBedtime = GeneratedColumn<bool>(
    'notify_bedtime',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_bedtime" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notifyMorningMeta = const VerificationMeta(
    'notifyMorning',
  );
  @override
  late final GeneratedColumn<bool> notifyMorning = GeneratedColumn<bool>(
    'notify_morning',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_morning" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _bedtimeTargetMeta = const VerificationMeta(
    'bedtimeTarget',
  );
  @override
  late final GeneratedColumn<String> bedtimeTarget = GeneratedColumn<String>(
    'bedtime_target',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightUnitMeta = const VerificationMeta(
    'weightUnit',
  );
  @override
  late final GeneratedColumn<String> weightUnit = GeneratedColumn<String>(
    'weight_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('kg'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    notifyDayBefore,
    notifyBedtime,
    notifyMorning,
    bedtimeTarget,
    weightUnit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('notify_day_before')) {
      context.handle(
        _notifyDayBeforeMeta,
        notifyDayBefore.isAcceptableOrUnknown(
          data['notify_day_before']!,
          _notifyDayBeforeMeta,
        ),
      );
    }
    if (data.containsKey('notify_bedtime')) {
      context.handle(
        _notifyBedtimeMeta,
        notifyBedtime.isAcceptableOrUnknown(
          data['notify_bedtime']!,
          _notifyBedtimeMeta,
        ),
      );
    }
    if (data.containsKey('notify_morning')) {
      context.handle(
        _notifyMorningMeta,
        notifyMorning.isAcceptableOrUnknown(
          data['notify_morning']!,
          _notifyMorningMeta,
        ),
      );
    }
    if (data.containsKey('bedtime_target')) {
      context.handle(
        _bedtimeTargetMeta,
        bedtimeTarget.isAcceptableOrUnknown(
          data['bedtime_target']!,
          _bedtimeTargetMeta,
        ),
      );
    }
    if (data.containsKey('weight_unit')) {
      context.handle(
        _weightUnitMeta,
        weightUnit.isAcceptableOrUnknown(data['weight_unit']!, _weightUnitMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      notifyDayBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_day_before'],
      )!,
      notifyBedtime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_bedtime'],
      )!,
      notifyMorning: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_morning'],
      )!,
      bedtimeTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bedtime_target'],
      ),
      weightUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weight_unit'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final bool notifyDayBefore;
  final bool notifyBedtime;
  final bool notifyMorning;
  final String? bedtimeTarget;
  final String weightUnit;
  const AppSetting({
    required this.id,
    required this.notifyDayBefore,
    required this.notifyBedtime,
    required this.notifyMorning,
    this.bedtimeTarget,
    required this.weightUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['notify_day_before'] = Variable<bool>(notifyDayBefore);
    map['notify_bedtime'] = Variable<bool>(notifyBedtime);
    map['notify_morning'] = Variable<bool>(notifyMorning);
    if (!nullToAbsent || bedtimeTarget != null) {
      map['bedtime_target'] = Variable<String>(bedtimeTarget);
    }
    map['weight_unit'] = Variable<String>(weightUnit);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      notifyDayBefore: Value(notifyDayBefore),
      notifyBedtime: Value(notifyBedtime),
      notifyMorning: Value(notifyMorning),
      bedtimeTarget: bedtimeTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(bedtimeTarget),
      weightUnit: Value(weightUnit),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      notifyDayBefore: serializer.fromJson<bool>(json['notifyDayBefore']),
      notifyBedtime: serializer.fromJson<bool>(json['notifyBedtime']),
      notifyMorning: serializer.fromJson<bool>(json['notifyMorning']),
      bedtimeTarget: serializer.fromJson<String?>(json['bedtimeTarget']),
      weightUnit: serializer.fromJson<String>(json['weightUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'notifyDayBefore': serializer.toJson<bool>(notifyDayBefore),
      'notifyBedtime': serializer.toJson<bool>(notifyBedtime),
      'notifyMorning': serializer.toJson<bool>(notifyMorning),
      'bedtimeTarget': serializer.toJson<String?>(bedtimeTarget),
      'weightUnit': serializer.toJson<String>(weightUnit),
    };
  }

  AppSetting copyWith({
    int? id,
    bool? notifyDayBefore,
    bool? notifyBedtime,
    bool? notifyMorning,
    Value<String?> bedtimeTarget = const Value.absent(),
    String? weightUnit,
  }) => AppSetting(
    id: id ?? this.id,
    notifyDayBefore: notifyDayBefore ?? this.notifyDayBefore,
    notifyBedtime: notifyBedtime ?? this.notifyBedtime,
    notifyMorning: notifyMorning ?? this.notifyMorning,
    bedtimeTarget: bedtimeTarget.present
        ? bedtimeTarget.value
        : this.bedtimeTarget,
    weightUnit: weightUnit ?? this.weightUnit,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      notifyDayBefore: data.notifyDayBefore.present
          ? data.notifyDayBefore.value
          : this.notifyDayBefore,
      notifyBedtime: data.notifyBedtime.present
          ? data.notifyBedtime.value
          : this.notifyBedtime,
      notifyMorning: data.notifyMorning.present
          ? data.notifyMorning.value
          : this.notifyMorning,
      bedtimeTarget: data.bedtimeTarget.present
          ? data.bedtimeTarget.value
          : this.bedtimeTarget,
      weightUnit: data.weightUnit.present
          ? data.weightUnit.value
          : this.weightUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('notifyDayBefore: $notifyDayBefore, ')
          ..write('notifyBedtime: $notifyBedtime, ')
          ..write('notifyMorning: $notifyMorning, ')
          ..write('bedtimeTarget: $bedtimeTarget, ')
          ..write('weightUnit: $weightUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    notifyDayBefore,
    notifyBedtime,
    notifyMorning,
    bedtimeTarget,
    weightUnit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.notifyDayBefore == this.notifyDayBefore &&
          other.notifyBedtime == this.notifyBedtime &&
          other.notifyMorning == this.notifyMorning &&
          other.bedtimeTarget == this.bedtimeTarget &&
          other.weightUnit == this.weightUnit);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<bool> notifyDayBefore;
  final Value<bool> notifyBedtime;
  final Value<bool> notifyMorning;
  final Value<String?> bedtimeTarget;
  final Value<String> weightUnit;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.notifyDayBefore = const Value.absent(),
    this.notifyBedtime = const Value.absent(),
    this.notifyMorning = const Value.absent(),
    this.bedtimeTarget = const Value.absent(),
    this.weightUnit = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.notifyDayBefore = const Value.absent(),
    this.notifyBedtime = const Value.absent(),
    this.notifyMorning = const Value.absent(),
    this.bedtimeTarget = const Value.absent(),
    this.weightUnit = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<bool>? notifyDayBefore,
    Expression<bool>? notifyBedtime,
    Expression<bool>? notifyMorning,
    Expression<String>? bedtimeTarget,
    Expression<String>? weightUnit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notifyDayBefore != null) 'notify_day_before': notifyDayBefore,
      if (notifyBedtime != null) 'notify_bedtime': notifyBedtime,
      if (notifyMorning != null) 'notify_morning': notifyMorning,
      if (bedtimeTarget != null) 'bedtime_target': bedtimeTarget,
      if (weightUnit != null) 'weight_unit': weightUnit,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? notifyDayBefore,
    Value<bool>? notifyBedtime,
    Value<bool>? notifyMorning,
    Value<String?>? bedtimeTarget,
    Value<String>? weightUnit,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      notifyDayBefore: notifyDayBefore ?? this.notifyDayBefore,
      notifyBedtime: notifyBedtime ?? this.notifyBedtime,
      notifyMorning: notifyMorning ?? this.notifyMorning,
      bedtimeTarget: bedtimeTarget ?? this.bedtimeTarget,
      weightUnit: weightUnit ?? this.weightUnit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notifyDayBefore.present) {
      map['notify_day_before'] = Variable<bool>(notifyDayBefore.value);
    }
    if (notifyBedtime.present) {
      map['notify_bedtime'] = Variable<bool>(notifyBedtime.value);
    }
    if (notifyMorning.present) {
      map['notify_morning'] = Variable<bool>(notifyMorning.value);
    }
    if (bedtimeTarget.present) {
      map['bedtime_target'] = Variable<String>(bedtimeTarget.value);
    }
    if (weightUnit.present) {
      map['weight_unit'] = Variable<String>(weightUnit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('notifyDayBefore: $notifyDayBefore, ')
          ..write('notifyBedtime: $notifyBedtime, ')
          ..write('notifyMorning: $notifyMorning, ')
          ..write('bedtimeTarget: $bedtimeTarget, ')
          ..write('weightUnit: $weightUnit')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkoutDaysTable workoutDays = $WorkoutDaysTable(this);
  late final $PlannedExercisesTable plannedExercises = $PlannedExercisesTable(
    this,
  );
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $SetLogsTable setLogs = $SetLogsTable(this);
  late final $PersonalRecordsTable personalRecords = $PersonalRecordsTable(
    this,
  );
  late final $RoutineItemsTable routineItems = $RoutineItemsTable(this);
  late final $RoutineChecksTable routineChecks = $RoutineChecksTable(this);
  late final $MealPrepTasksTable mealPrepTasks = $MealPrepTasksTable(this);
  late final $MealPrepChecksTable mealPrepChecks = $MealPrepChecksTable(this);
  late final $BodyLogsTable bodyLogs = $BodyLogsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workoutDays,
    plannedExercises,
    workoutSessions,
    setLogs,
    personalRecords,
    routineItems,
    routineChecks,
    mealPrepTasks,
    mealPrepChecks,
    bodyLogs,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_days',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('planned_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('set_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routine_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_checks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'meal_prep_tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('meal_prep_checks', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WorkoutDaysTableCreateCompanionBuilder =
    WorkoutDaysCompanion Function({
      Value<int> id,
      required int weekday,
      required String title,
      Value<String?> usualTime,
      Value<bool> isRestDay,
    });
typedef $$WorkoutDaysTableUpdateCompanionBuilder =
    WorkoutDaysCompanion Function({
      Value<int> id,
      Value<int> weekday,
      Value<String> title,
      Value<String?> usualTime,
      Value<bool> isRestDay,
    });

final class $$WorkoutDaysTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutDaysTable, WorkoutDay> {
  $$WorkoutDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlannedExercisesTable, List<PlannedExercise>>
  _plannedExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.plannedExercises,
    aliasName: 'workout_days__id__planned_exercises__workout_day_id',
  );

  $$PlannedExercisesTableProcessedTableManager get plannedExercisesRefs {
    final manager = $$PlannedExercisesTableTableManager(
      $_db,
      $_db.plannedExercises,
    ).filter((f) => f.workoutDayId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _plannedExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutSessionsTable, List<WorkoutSession>>
  _workoutSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSessions,
    aliasName: 'workout_days__id__workout_sessions__workout_day_id',
  );

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionsRefs {
    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.workoutDayId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutDaysTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutDaysTable> {
  $$WorkoutDaysTableFilterComposer({
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

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usualTime => $composableBuilder(
    column: $table.usualTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRestDay => $composableBuilder(
    column: $table.isRestDay,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> plannedExercisesRefs(
    Expression<bool> Function($$PlannedExercisesTableFilterComposer f) f,
  ) {
    final $$PlannedExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedExercises,
      getReferencedColumn: (t) => t.workoutDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannedExercisesTableFilterComposer(
            $db: $db,
            $table: $db.plannedExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutSessionsRefs(
    Expression<bool> Function($$WorkoutSessionsTableFilterComposer f) f,
  ) {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.workoutDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutDaysTable> {
  $$WorkoutDaysTableOrderingComposer({
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

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usualTime => $composableBuilder(
    column: $table.usualTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRestDay => $composableBuilder(
    column: $table.isRestDay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutDaysTable> {
  $$WorkoutDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get usualTime =>
      $composableBuilder(column: $table.usualTime, builder: (column) => column);

  GeneratedColumn<bool> get isRestDay =>
      $composableBuilder(column: $table.isRestDay, builder: (column) => column);

  Expression<T> plannedExercisesRefs<T extends Object>(
    Expression<T> Function($$PlannedExercisesTableAnnotationComposer a) f,
  ) {
    final $$PlannedExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedExercises,
      getReferencedColumn: (t) => t.workoutDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannedExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.plannedExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutSessionsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSessionsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.workoutDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutDaysTable,
          WorkoutDay,
          $$WorkoutDaysTableFilterComposer,
          $$WorkoutDaysTableOrderingComposer,
          $$WorkoutDaysTableAnnotationComposer,
          $$WorkoutDaysTableCreateCompanionBuilder,
          $$WorkoutDaysTableUpdateCompanionBuilder,
          (WorkoutDay, $$WorkoutDaysTableReferences),
          WorkoutDay,
          PrefetchHooks Function({
            bool plannedExercisesRefs,
            bool workoutSessionsRefs,
          })
        > {
  $$WorkoutDaysTableTableManager(_$AppDatabase db, $WorkoutDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> usualTime = const Value.absent(),
                Value<bool> isRestDay = const Value.absent(),
              }) => WorkoutDaysCompanion(
                id: id,
                weekday: weekday,
                title: title,
                usualTime: usualTime,
                isRestDay: isRestDay,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int weekday,
                required String title,
                Value<String?> usualTime = const Value.absent(),
                Value<bool> isRestDay = const Value.absent(),
              }) => WorkoutDaysCompanion.insert(
                id: id,
                weekday: weekday,
                title: title,
                usualTime: usualTime,
                isRestDay: isRestDay,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutDaysTable, WorkoutDay>(table),
                  $$WorkoutDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({plannedExercisesRefs = false, workoutSessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (plannedExercisesRefs) db.plannedExercises,
                    if (workoutSessionsRefs) db.workoutSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (plannedExercisesRefs)
                        await $_getPrefetchedData<
                          WorkoutDay,
                          $WorkoutDaysTable,
                          PlannedExercise
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutDaysTableReferences
                              ._plannedExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).plannedExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutDayId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workoutSessionsRefs)
                        await $_getPrefetchedData<
                          WorkoutDay,
                          $WorkoutDaysTable,
                          WorkoutSession
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutDaysTableReferences
                              ._workoutSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutDayId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutDaysTable,
      WorkoutDay,
      $$WorkoutDaysTableFilterComposer,
      $$WorkoutDaysTableOrderingComposer,
      $$WorkoutDaysTableAnnotationComposer,
      $$WorkoutDaysTableCreateCompanionBuilder,
      $$WorkoutDaysTableUpdateCompanionBuilder,
      (WorkoutDay, $$WorkoutDaysTableReferences),
      WorkoutDay,
      PrefetchHooks Function({
        bool plannedExercisesRefs,
        bool workoutSessionsRefs,
      })
    >;
typedef $$PlannedExercisesTableCreateCompanionBuilder =
    PlannedExercisesCompanion Function({
      Value<int> id,
      required int workoutDayId,
      required String name,
      Value<int> targetSets,
      Value<int> orderIndex,
    });
typedef $$PlannedExercisesTableUpdateCompanionBuilder =
    PlannedExercisesCompanion Function({
      Value<int> id,
      Value<int> workoutDayId,
      Value<String> name,
      Value<int> targetSets,
      Value<int> orderIndex,
    });

final class $$PlannedExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $PlannedExercisesTable, PlannedExercise> {
  $$PlannedExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutDaysTable _workoutDayIdTable(_$AppDatabase db) => db
      .workoutDays
      .createAlias('planned_exercises__workout_day_id__workout_days__id');

  $$WorkoutDaysTableProcessedTableManager get workoutDayId {
    final $_column = $_itemColumn<int>('workout_day_id')!;

    final manager = $$WorkoutDaysTableTableManager(
      $_db,
      $_db.workoutDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlannedExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $PlannedExercisesTable> {
  $$PlannedExercisesTableFilterComposer({
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

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutDaysTableFilterComposer get workoutDayId {
    final $$WorkoutDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutDayId,
      referencedTable: $db.workoutDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDaysTableFilterComposer(
            $db: $db,
            $table: $db.workoutDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlannedExercisesTable> {
  $$PlannedExercisesTableOrderingComposer({
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

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutDaysTableOrderingComposer get workoutDayId {
    final $$WorkoutDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutDayId,
      referencedTable: $db.workoutDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDaysTableOrderingComposer(
            $db: $db,
            $table: $db.workoutDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlannedExercisesTable> {
  $$PlannedExercisesTableAnnotationComposer({
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

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$WorkoutDaysTableAnnotationComposer get workoutDayId {
    final $$WorkoutDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutDayId,
      referencedTable: $db.workoutDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlannedExercisesTable,
          PlannedExercise,
          $$PlannedExercisesTableFilterComposer,
          $$PlannedExercisesTableOrderingComposer,
          $$PlannedExercisesTableAnnotationComposer,
          $$PlannedExercisesTableCreateCompanionBuilder,
          $$PlannedExercisesTableUpdateCompanionBuilder,
          (PlannedExercise, $$PlannedExercisesTableReferences),
          PlannedExercise,
          PrefetchHooks Function({bool workoutDayId})
        > {
  $$PlannedExercisesTableTableManager(
    _$AppDatabase db,
    $PlannedExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlannedExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlannedExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlannedExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workoutDayId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetSets = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => PlannedExercisesCompanion(
                id: id,
                workoutDayId: workoutDayId,
                name: name,
                targetSets: targetSets,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workoutDayId,
                required String name,
                Value<int> targetSets = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => PlannedExercisesCompanion.insert(
                id: id,
                workoutDayId: workoutDayId,
                name: name,
                targetSets: targetSets,
                orderIndex: orderIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlannedExercisesTable, PlannedExercise>(table),
                  $$PlannedExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutDayId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workoutDayId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.workoutDayId,
                        referencedTable: $$PlannedExercisesTableReferences
                            ._workoutDayIdTable(db),
                        referencedColumn: $$PlannedExercisesTableReferences
                            ._workoutDayIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlannedExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlannedExercisesTable,
      PlannedExercise,
      $$PlannedExercisesTableFilterComposer,
      $$PlannedExercisesTableOrderingComposer,
      $$PlannedExercisesTableAnnotationComposer,
      $$PlannedExercisesTableCreateCompanionBuilder,
      $$PlannedExercisesTableUpdateCompanionBuilder,
      (PlannedExercise, $$PlannedExercisesTableReferences),
      PlannedExercise,
      PrefetchHooks Function({bool workoutDayId})
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      required int workoutDayId,
      required DateTime date,
      Value<String?> notes,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      Value<int> workoutDayId,
      Value<DateTime> date,
      Value<String?> notes,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutDaysTable _workoutDayIdTable(_$AppDatabase db) => db
      .workoutDays
      .createAlias('workout_sessions__workout_day_id__workout_days__id');

  $$WorkoutDaysTableProcessedTableManager get workoutDayId {
    final $_column = $_itemColumn<int>('workout_day_id')!;

    final manager = $$WorkoutDaysTableTableManager(
      $_db,
      $_db.workoutDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SetLogsTable, List<SetLog>> _setLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setLogs,
    aliasName: 'workout_sessions__id__set_logs__session_id',
  );

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager(
      $_db,
      $_db.setLogs,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutDaysTableFilterComposer get workoutDayId {
    final $$WorkoutDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutDayId,
      referencedTable: $db.workoutDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDaysTableFilterComposer(
            $db: $db,
            $table: $db.workoutDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> setLogsRefs(
    Expression<bool> Function($$SetLogsTableFilterComposer f) f,
  ) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableFilterComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutDaysTableOrderingComposer get workoutDayId {
    final $$WorkoutDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutDayId,
      referencedTable: $db.workoutDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDaysTableOrderingComposer(
            $db: $db,
            $table: $db.workoutDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$WorkoutDaysTableAnnotationComposer get workoutDayId {
    final $$WorkoutDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutDayId,
      referencedTable: $db.workoutDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> setLogsRefs<T extends Object>(
    Expression<T> Function($$SetLogsTableAnnotationComposer a) f,
  ) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({bool workoutDayId, bool setLogsRefs})
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workoutDayId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                workoutDayId: workoutDayId,
                date: date,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workoutDayId,
                required DateTime date,
                Value<String?> notes = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                workoutDayId: workoutDayId,
                date: date,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, WorkoutSession>(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutDayId = false, setLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (setLogsRefs) db.setLogs],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workoutDayId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.workoutDayId,
                        referencedTable: $$WorkoutSessionsTableReferences
                            ._workoutDayIdTable(db),
                        referencedColumn: $$WorkoutSessionsTableReferences
                            ._workoutDayIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setLogsRefs)
                    await $_getPrefetchedData<
                      WorkoutSession,
                      $WorkoutSessionsTable,
                      SetLog
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutSessionsTableReferences
                          ._setLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).setLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({bool workoutDayId, bool setLogsRefs})
    >;
typedef $$SetLogsTableCreateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  required int sessionId,
  required String exerciseName,
  required int setNumber,
  required double weightKg,
  required int reps,
  Value<double?> rpe,
  Value<bool> isPr,
});
typedef $$SetLogsTableUpdateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<String> exerciseName,
  Value<int> setNumber,
  Value<double> weightKg,
  Value<int> reps,
  Value<double?> rpe,
  Value<bool> isPr,
});

final class $$SetLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SetLogsTable, SetLog> {
  $$SetLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('set_logs__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SetLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableFilterComposer({
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

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPr => $composableBuilder(
    column: $table.isPr,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableOrderingComposer({
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

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPr => $composableBuilder(
    column: $table.isPr,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<bool> get isPr =>
      $composableBuilder(column: $table.isPr, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetLogsTable,
          SetLog,
          $$SetLogsTableFilterComposer,
          $$SetLogsTableOrderingComposer,
          $$SetLogsTableAnnotationComposer,
          $$SetLogsTableCreateCompanionBuilder,
          $$SetLogsTableUpdateCompanionBuilder,
          (SetLog, $$SetLogsTableReferences),
          SetLog,
          PrefetchHooks Function({bool sessionId})
        > {
  $$SetLogsTableTableManager(_$AppDatabase db, $SetLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<bool> isPr = const Value.absent(),
              }) => SetLogsCompanion(
                id: id,
                sessionId: sessionId,
                exerciseName: exerciseName,
                setNumber: setNumber,
                weightKg: weightKg,
                reps: reps,
                rpe: rpe,
                isPr: isPr,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String exerciseName,
                required int setNumber,
                required double weightKg,
                required int reps,
                Value<double?> rpe = const Value.absent(),
                Value<bool> isPr = const Value.absent(),
              }) => SetLogsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseName: exerciseName,
                setNumber: setNumber,
                weightKg: weightKg,
                reps: reps,
                rpe: rpe,
                isPr: isPr,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SetLogsTable, SetLog>(table),
                  $$SetLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$SetLogsTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$SetLogsTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SetLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetLogsTable,
      SetLog,
      $$SetLogsTableFilterComposer,
      $$SetLogsTableOrderingComposer,
      $$SetLogsTableAnnotationComposer,
      $$SetLogsTableCreateCompanionBuilder,
      $$SetLogsTableUpdateCompanionBuilder,
      (SetLog, $$SetLogsTableReferences),
      SetLog,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$PersonalRecordsTableCreateCompanionBuilder =
    PersonalRecordsCompanion Function({
      Value<int> id,
      required String exerciseName,
      required double weightKg,
      required int reps,
      required DateTime achievedAt,
      Value<String?> photoPath,
    });
typedef $$PersonalRecordsTableUpdateCompanionBuilder =
    PersonalRecordsCompanion Function({
      Value<int> id,
      Value<String> exerciseName,
      Value<double> weightKg,
      Value<int> reps,
      Value<DateTime> achievedAt,
      Value<String?> photoPath,
    });

class $$PersonalRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableFilterComposer({
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

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PersonalRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonalRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);
}

class $$PersonalRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalRecordsTable,
          PersonalRecord,
          $$PersonalRecordsTableFilterComposer,
          $$PersonalRecordsTableOrderingComposer,
          $$PersonalRecordsTableAnnotationComposer,
          $$PersonalRecordsTableCreateCompanionBuilder,
          $$PersonalRecordsTableUpdateCompanionBuilder,
          (
            PersonalRecord,
            BaseReferences<
              _$AppDatabase,
              $PersonalRecordsTable,
              PersonalRecord
            >,
          ),
          PersonalRecord,
          PrefetchHooks Function()
        > {
  $$PersonalRecordsTableTableManager(
    _$AppDatabase db,
    $PersonalRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<DateTime> achievedAt = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
              }) => PersonalRecordsCompanion(
                id: id,
                exerciseName: exerciseName,
                weightKg: weightKg,
                reps: reps,
                achievedAt: achievedAt,
                photoPath: photoPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String exerciseName,
                required double weightKg,
                required int reps,
                required DateTime achievedAt,
                Value<String?> photoPath = const Value.absent(),
              }) => PersonalRecordsCompanion.insert(
                id: id,
                exerciseName: exerciseName,
                weightKg: weightKg,
                reps: reps,
                achievedAt: achievedAt,
                photoPath: photoPath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PersonalRecordsTable, PersonalRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PersonalRecordsTable,
                    PersonalRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonalRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalRecordsTable,
      PersonalRecord,
      $$PersonalRecordsTableFilterComposer,
      $$PersonalRecordsTableOrderingComposer,
      $$PersonalRecordsTableAnnotationComposer,
      $$PersonalRecordsTableCreateCompanionBuilder,
      $$PersonalRecordsTableUpdateCompanionBuilder,
      (
        PersonalRecord,
        BaseReferences<_$AppDatabase, $PersonalRecordsTable, PersonalRecord>,
      ),
      PersonalRecord,
      PrefetchHooks Function()
    >;
typedef $$RoutineItemsTableCreateCompanionBuilder =
    RoutineItemsCompanion Function({
      Value<int> id,
      required String label,
      required String category,
      Value<String?> defaultTime,
      Value<int> orderIndex,
      Value<bool> isActive,
    });
typedef $$RoutineItemsTableUpdateCompanionBuilder =
    RoutineItemsCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<String> category,
      Value<String?> defaultTime,
      Value<int> orderIndex,
      Value<bool> isActive,
    });

final class $$RoutineItemsTableReferences
    extends BaseReferences<_$AppDatabase, $RoutineItemsTable, RoutineItem> {
  $$RoutineItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineChecksTable, List<RoutineCheck>>
  _routineChecksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineChecks,
    aliasName: 'routine_items__id__routine_checks__routine_item_id',
  );

  $$RoutineChecksTableProcessedTableManager get routineChecksRefs {
    final manager = $$RoutineChecksTableTableManager(
      $_db,
      $_db.routineChecks,
    ).filter((f) => f.routineItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_routineChecksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutineItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultTime => $composableBuilder(
    column: $table.defaultTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> routineChecksRefs(
    Expression<bool> Function($$RoutineChecksTableFilterComposer f) f,
  ) {
    final $$RoutineChecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineChecks,
      getReferencedColumn: (t) => t.routineItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineChecksTableFilterComposer(
            $db: $db,
            $table: $db.routineChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultTime => $composableBuilder(
    column: $table.defaultTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutineItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get defaultTime => $composableBuilder(
    column: $table.defaultTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> routineChecksRefs<T extends Object>(
    Expression<T> Function($$RoutineChecksTableAnnotationComposer a) f,
  ) {
    final $$RoutineChecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineChecks,
      getReferencedColumn: (t) => t.routineItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineChecksTableAnnotationComposer(
            $db: $db,
            $table: $db.routineChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineItemsTable,
          RoutineItem,
          $$RoutineItemsTableFilterComposer,
          $$RoutineItemsTableOrderingComposer,
          $$RoutineItemsTableAnnotationComposer,
          $$RoutineItemsTableCreateCompanionBuilder,
          $$RoutineItemsTableUpdateCompanionBuilder,
          (RoutineItem, $$RoutineItemsTableReferences),
          RoutineItem,
          PrefetchHooks Function({bool routineChecksRefs})
        > {
  $$RoutineItemsTableTableManager(_$AppDatabase db, $RoutineItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> defaultTime = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => RoutineItemsCompanion(
                id: id,
                label: label,
                category: category,
                defaultTime: defaultTime,
                orderIndex: orderIndex,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String label,
                required String category,
                Value<String?> defaultTime = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => RoutineItemsCompanion.insert(
                id: id,
                label: label,
                category: category,
                defaultTime: defaultTime,
                orderIndex: orderIndex,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutineItemsTable, RoutineItem>(table),
                  $$RoutineItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineChecksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routineChecksRefs) db.routineChecks,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineChecksRefs)
                    await $_getPrefetchedData<
                      RoutineItem,
                      $RoutineItemsTable,
                      RoutineCheck
                    >(
                      currentTable: table,
                      referencedTable: $$RoutineItemsTableReferences
                          ._routineChecksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RoutineItemsTableReferences(
                            db,
                            table,
                            p0,
                          ).routineChecksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.routineItemId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoutineItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineItemsTable,
      RoutineItem,
      $$RoutineItemsTableFilterComposer,
      $$RoutineItemsTableOrderingComposer,
      $$RoutineItemsTableAnnotationComposer,
      $$RoutineItemsTableCreateCompanionBuilder,
      $$RoutineItemsTableUpdateCompanionBuilder,
      (RoutineItem, $$RoutineItemsTableReferences),
      RoutineItem,
      PrefetchHooks Function({bool routineChecksRefs})
    >;
typedef $$RoutineChecksTableCreateCompanionBuilder =
    RoutineChecksCompanion Function({
      Value<int> id,
      required int routineItemId,
      required DateTime date,
      Value<bool> isDone,
      Value<DateTime?> doneAt,
    });
typedef $$RoutineChecksTableUpdateCompanionBuilder =
    RoutineChecksCompanion Function({
      Value<int> id,
      Value<int> routineItemId,
      Value<DateTime> date,
      Value<bool> isDone,
      Value<DateTime?> doneAt,
    });

final class $$RoutineChecksTableReferences
    extends BaseReferences<_$AppDatabase, $RoutineChecksTable, RoutineCheck> {
  $$RoutineChecksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutineItemsTable _routineItemIdTable(_$AppDatabase db) => db
      .routineItems
      .createAlias('routine_checks__routine_item_id__routine_items__id');

  $$RoutineItemsTableProcessedTableManager get routineItemId {
    final $_column = $_itemColumn<int>('routine_item_id')!;

    final manager = $$RoutineItemsTableTableManager(
      $_db,
      $_db.routineItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutineChecksTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineChecksTable> {
  $$RoutineChecksTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutineItemsTableFilterComposer get routineItemId {
    final $$RoutineItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineItemId,
      referencedTable: $db.routineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemsTableFilterComposer(
            $db: $db,
            $table: $db.routineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineChecksTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineChecksTable> {
  $$RoutineChecksTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutineItemsTableOrderingComposer get routineItemId {
    final $$RoutineItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineItemId,
      referencedTable: $db.routineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemsTableOrderingComposer(
            $db: $db,
            $table: $db.routineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineChecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineChecksTable> {
  $$RoutineChecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<DateTime> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

  $$RoutineItemsTableAnnotationComposer get routineItemId {
    final $$RoutineItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineItemId,
      referencedTable: $db.routineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.routineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineChecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineChecksTable,
          RoutineCheck,
          $$RoutineChecksTableFilterComposer,
          $$RoutineChecksTableOrderingComposer,
          $$RoutineChecksTableAnnotationComposer,
          $$RoutineChecksTableCreateCompanionBuilder,
          $$RoutineChecksTableUpdateCompanionBuilder,
          (RoutineCheck, $$RoutineChecksTableReferences),
          RoutineCheck,
          PrefetchHooks Function({bool routineItemId})
        > {
  $$RoutineChecksTableTableManager(_$AppDatabase db, $RoutineChecksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineChecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineChecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineChecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> routineItemId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
              }) => RoutineChecksCompanion(
                id: id,
                routineItemId: routineItemId,
                date: date,
                isDone: isDone,
                doneAt: doneAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int routineItemId,
                required DateTime date,
                Value<bool> isDone = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
              }) => RoutineChecksCompanion.insert(
                id: id,
                routineItemId: routineItemId,
                date: date,
                isDone: isDone,
                doneAt: doneAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutineChecksTable, RoutineCheck>(table),
                  $$RoutineChecksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (routineItemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.routineItemId,
                        referencedTable: $$RoutineChecksTableReferences
                            ._routineItemIdTable(db),
                        referencedColumn: $$RoutineChecksTableReferences
                            ._routineItemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoutineChecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineChecksTable,
      RoutineCheck,
      $$RoutineChecksTableFilterComposer,
      $$RoutineChecksTableOrderingComposer,
      $$RoutineChecksTableAnnotationComposer,
      $$RoutineChecksTableCreateCompanionBuilder,
      $$RoutineChecksTableUpdateCompanionBuilder,
      (RoutineCheck, $$RoutineChecksTableReferences),
      RoutineCheck,
      PrefetchHooks Function({bool routineItemId})
    >;
typedef $$MealPrepTasksTableCreateCompanionBuilder =
    MealPrepTasksCompanion Function({
      Value<int> id,
      required String label,
      required int weekday,
      Value<bool> isActive,
    });
typedef $$MealPrepTasksTableUpdateCompanionBuilder =
    MealPrepTasksCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<int> weekday,
      Value<bool> isActive,
    });

final class $$MealPrepTasksTableReferences
    extends BaseReferences<_$AppDatabase, $MealPrepTasksTable, MealPrepTask> {
  $$MealPrepTasksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$MealPrepChecksTable, List<MealPrepCheck>>
  _mealPrepChecksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealPrepChecks,
    aliasName: 'meal_prep_tasks__id__meal_prep_checks__meal_prep_task_id',
  );

  $$MealPrepChecksTableProcessedTableManager get mealPrepChecksRefs {
    final manager = $$MealPrepChecksTableTableManager(
      $_db,
      $_db.mealPrepChecks,
    ).filter((f) => f.mealPrepTaskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealPrepChecksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealPrepTasksTableFilterComposer
    extends Composer<_$AppDatabase, $MealPrepTasksTable> {
  $$MealPrepTasksTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mealPrepChecksRefs(
    Expression<bool> Function($$MealPrepChecksTableFilterComposer f) f,
  ) {
    final $$MealPrepChecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPrepChecks,
      getReferencedColumn: (t) => t.mealPrepTaskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPrepChecksTableFilterComposer(
            $db: $db,
            $table: $db.mealPrepChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealPrepTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPrepTasksTable> {
  $$MealPrepTasksTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealPrepTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPrepTasksTable> {
  $$MealPrepTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> mealPrepChecksRefs<T extends Object>(
    Expression<T> Function($$MealPrepChecksTableAnnotationComposer a) f,
  ) {
    final $$MealPrepChecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPrepChecks,
      getReferencedColumn: (t) => t.mealPrepTaskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPrepChecksTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPrepChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealPrepTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealPrepTasksTable,
          MealPrepTask,
          $$MealPrepTasksTableFilterComposer,
          $$MealPrepTasksTableOrderingComposer,
          $$MealPrepTasksTableAnnotationComposer,
          $$MealPrepTasksTableCreateCompanionBuilder,
          $$MealPrepTasksTableUpdateCompanionBuilder,
          (MealPrepTask, $$MealPrepTasksTableReferences),
          MealPrepTask,
          PrefetchHooks Function({bool mealPrepChecksRefs})
        > {
  $$MealPrepTasksTableTableManager(_$AppDatabase db, $MealPrepTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPrepTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPrepTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPrepTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MealPrepTasksCompanion(
                id: id,
                label: label,
                weekday: weekday,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String label,
                required int weekday,
                Value<bool> isActive = const Value.absent(),
              }) => MealPrepTasksCompanion.insert(
                id: id,
                label: label,
                weekday: weekday,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealPrepTasksTable, MealPrepTask>(table),
                  $$MealPrepTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealPrepChecksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mealPrepChecksRefs) db.mealPrepChecks,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealPrepChecksRefs)
                    await $_getPrefetchedData<
                      MealPrepTask,
                      $MealPrepTasksTable,
                      MealPrepCheck
                    >(
                      currentTable: table,
                      referencedTable: $$MealPrepTasksTableReferences
                          ._mealPrepChecksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MealPrepTasksTableReferences(
                            db,
                            table,
                            p0,
                          ).mealPrepChecksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.mealPrepTaskId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MealPrepTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealPrepTasksTable,
      MealPrepTask,
      $$MealPrepTasksTableFilterComposer,
      $$MealPrepTasksTableOrderingComposer,
      $$MealPrepTasksTableAnnotationComposer,
      $$MealPrepTasksTableCreateCompanionBuilder,
      $$MealPrepTasksTableUpdateCompanionBuilder,
      (MealPrepTask, $$MealPrepTasksTableReferences),
      MealPrepTask,
      PrefetchHooks Function({bool mealPrepChecksRefs})
    >;
typedef $$MealPrepChecksTableCreateCompanionBuilder =
    MealPrepChecksCompanion Function({
      Value<int> id,
      required int mealPrepTaskId,
      required DateTime weekStart,
      Value<bool> isDone,
    });
typedef $$MealPrepChecksTableUpdateCompanionBuilder =
    MealPrepChecksCompanion Function({
      Value<int> id,
      Value<int> mealPrepTaskId,
      Value<DateTime> weekStart,
      Value<bool> isDone,
    });

final class $$MealPrepChecksTableReferences
    extends BaseReferences<_$AppDatabase, $MealPrepChecksTable, MealPrepCheck> {
  $$MealPrepChecksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MealPrepTasksTable _mealPrepTaskIdTable(_$AppDatabase db) => db
      .mealPrepTasks
      .createAlias('meal_prep_checks__meal_prep_task_id__meal_prep_tasks__id');

  $$MealPrepTasksTableProcessedTableManager get mealPrepTaskId {
    final $_column = $_itemColumn<int>('meal_prep_task_id')!;

    final manager = $$MealPrepTasksTableTableManager(
      $_db,
      $_db.mealPrepTasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealPrepTaskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealPrepChecksTableFilterComposer
    extends Composer<_$AppDatabase, $MealPrepChecksTable> {
  $$MealPrepChecksTableFilterComposer({
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

  ColumnFilters<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  $$MealPrepTasksTableFilterComposer get mealPrepTaskId {
    final $$MealPrepTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealPrepTaskId,
      referencedTable: $db.mealPrepTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPrepTasksTableFilterComposer(
            $db: $db,
            $table: $db.mealPrepTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealPrepChecksTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPrepChecksTable> {
  $$MealPrepChecksTableOrderingComposer({
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

  ColumnOrderings<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  $$MealPrepTasksTableOrderingComposer get mealPrepTaskId {
    final $$MealPrepTasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealPrepTaskId,
      referencedTable: $db.mealPrepTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPrepTasksTableOrderingComposer(
            $db: $db,
            $table: $db.mealPrepTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealPrepChecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPrepChecksTable> {
  $$MealPrepChecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  $$MealPrepTasksTableAnnotationComposer get mealPrepTaskId {
    final $$MealPrepTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealPrepTaskId,
      referencedTable: $db.mealPrepTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPrepTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPrepTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealPrepChecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealPrepChecksTable,
          MealPrepCheck,
          $$MealPrepChecksTableFilterComposer,
          $$MealPrepChecksTableOrderingComposer,
          $$MealPrepChecksTableAnnotationComposer,
          $$MealPrepChecksTableCreateCompanionBuilder,
          $$MealPrepChecksTableUpdateCompanionBuilder,
          (MealPrepCheck, $$MealPrepChecksTableReferences),
          MealPrepCheck,
          PrefetchHooks Function({bool mealPrepTaskId})
        > {
  $$MealPrepChecksTableTableManager(
    _$AppDatabase db,
    $MealPrepChecksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPrepChecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPrepChecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPrepChecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mealPrepTaskId = const Value.absent(),
                Value<DateTime> weekStart = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
              }) => MealPrepChecksCompanion(
                id: id,
                mealPrepTaskId: mealPrepTaskId,
                weekStart: weekStart,
                isDone: isDone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mealPrepTaskId,
                required DateTime weekStart,
                Value<bool> isDone = const Value.absent(),
              }) => MealPrepChecksCompanion.insert(
                id: id,
                mealPrepTaskId: mealPrepTaskId,
                weekStart: weekStart,
                isDone: isDone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealPrepChecksTable, MealPrepCheck>(table),
                  $$MealPrepChecksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealPrepTaskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mealPrepTaskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mealPrepTaskId,
                        referencedTable: $$MealPrepChecksTableReferences
                            ._mealPrepTaskIdTable(db),
                        referencedColumn: $$MealPrepChecksTableReferences
                            ._mealPrepTaskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealPrepChecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealPrepChecksTable,
      MealPrepCheck,
      $$MealPrepChecksTableFilterComposer,
      $$MealPrepChecksTableOrderingComposer,
      $$MealPrepChecksTableAnnotationComposer,
      $$MealPrepChecksTableCreateCompanionBuilder,
      $$MealPrepChecksTableUpdateCompanionBuilder,
      (MealPrepCheck, $$MealPrepChecksTableReferences),
      MealPrepCheck,
      PrefetchHooks Function({bool mealPrepTaskId})
    >;
typedef $$BodyLogsTableCreateCompanionBuilder = BodyLogsCompanion Function({
  Value<int> id,
  required DateTime date,
  required double weightKg,
  Value<String?> photoPath,
  Value<String?> note,
});
typedef $$BodyLogsTableUpdateCompanionBuilder = BodyLogsCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<double> weightKg,
  Value<String?> photoPath,
  Value<String?> note,
});

class $$BodyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $BodyLogsTable> {
  $$BodyLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyLogsTable> {
  $$BodyLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyLogsTable> {
  $$BodyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$BodyLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyLogsTable,
          BodyLog,
          $$BodyLogsTableFilterComposer,
          $$BodyLogsTableOrderingComposer,
          $$BodyLogsTableAnnotationComposer,
          $$BodyLogsTableCreateCompanionBuilder,
          $$BodyLogsTableUpdateCompanionBuilder,
          (BodyLog, BaseReferences<_$AppDatabase, $BodyLogsTable, BodyLog>),
          BodyLog,
          PrefetchHooks Function()
        > {
  $$BodyLogsTableTableManager(_$AppDatabase db, $BodyLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => BodyLogsCompanion(
                id: id,
                date: date,
                weightKg: weightKg,
                photoPath: photoPath,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required double weightKg,
                Value<String?> photoPath = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => BodyLogsCompanion.insert(
                id: id,
                date: date,
                weightKg: weightKg,
                photoPath: photoPath,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyLogsTable, BodyLog>(table),
                  BaseReferences<_$AppDatabase, $BodyLogsTable, BodyLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyLogsTable,
      BodyLog,
      $$BodyLogsTableFilterComposer,
      $$BodyLogsTableOrderingComposer,
      $$BodyLogsTableAnnotationComposer,
      $$BodyLogsTableCreateCompanionBuilder,
      $$BodyLogsTableUpdateCompanionBuilder,
      (BodyLog, BaseReferences<_$AppDatabase, $BodyLogsTable, BodyLog>),
      BodyLog,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<bool> notifyDayBefore,
      Value<bool> notifyBedtime,
      Value<bool> notifyMorning,
      Value<String?> bedtimeTarget,
      Value<String> weightUnit,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<bool> notifyDayBefore,
      Value<bool> notifyBedtime,
      Value<bool> notifyMorning,
      Value<String?> bedtimeTarget,
      Value<String> weightUnit,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
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

  ColumnFilters<bool> get notifyDayBefore => $composableBuilder(
    column: $table.notifyDayBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyBedtime => $composableBuilder(
    column: $table.notifyBedtime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyMorning => $composableBuilder(
    column: $table.notifyMorning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bedtimeTarget => $composableBuilder(
    column: $table.bedtimeTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
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

  ColumnOrderings<bool> get notifyDayBefore => $composableBuilder(
    column: $table.notifyDayBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyBedtime => $composableBuilder(
    column: $table.notifyBedtime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyMorning => $composableBuilder(
    column: $table.notifyMorning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bedtimeTarget => $composableBuilder(
    column: $table.bedtimeTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get notifyDayBefore => $composableBuilder(
    column: $table.notifyDayBefore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyBedtime => $composableBuilder(
    column: $table.notifyBedtime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyMorning => $composableBuilder(
    column: $table.notifyMorning,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bedtimeTarget => $composableBuilder(
    column: $table.bedtimeTarget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> notifyDayBefore = const Value.absent(),
                Value<bool> notifyBedtime = const Value.absent(),
                Value<bool> notifyMorning = const Value.absent(),
                Value<String?> bedtimeTarget = const Value.absent(),
                Value<String> weightUnit = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                notifyDayBefore: notifyDayBefore,
                notifyBedtime: notifyBedtime,
                notifyMorning: notifyMorning,
                bedtimeTarget: bedtimeTarget,
                weightUnit: weightUnit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> notifyDayBefore = const Value.absent(),
                Value<bool> notifyBedtime = const Value.absent(),
                Value<bool> notifyMorning = const Value.absent(),
                Value<String?> bedtimeTarget = const Value.absent(),
                Value<String> weightUnit = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                notifyDayBefore: notifyDayBefore,
                notifyBedtime: notifyBedtime,
                notifyMorning: notifyMorning,
                bedtimeTarget: bedtimeTarget,
                weightUnit: weightUnit,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkoutDaysTableTableManager get workoutDays =>
      $$WorkoutDaysTableTableManager(_db, _db.workoutDays);
  $$PlannedExercisesTableTableManager get plannedExercises =>
      $$PlannedExercisesTableTableManager(_db, _db.plannedExercises);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db, _db.setLogs);
  $$PersonalRecordsTableTableManager get personalRecords =>
      $$PersonalRecordsTableTableManager(_db, _db.personalRecords);
  $$RoutineItemsTableTableManager get routineItems =>
      $$RoutineItemsTableTableManager(_db, _db.routineItems);
  $$RoutineChecksTableTableManager get routineChecks =>
      $$RoutineChecksTableTableManager(_db, _db.routineChecks);
  $$MealPrepTasksTableTableManager get mealPrepTasks =>
      $$MealPrepTasksTableTableManager(_db, _db.mealPrepTasks);
  $$MealPrepChecksTableTableManager get mealPrepChecks =>
      $$MealPrepChecksTableTableManager(_db, _db.mealPrepChecks);
  $$BodyLogsTableTableManager get bodyLogs =>
      $$BodyLogsTableTableManager(_db, _db.bodyLogs);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
