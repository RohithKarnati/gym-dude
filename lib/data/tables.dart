import 'package:drift/drift.dart';

/// The weekly split template. One row per weekday the plan covers.
class WorkoutDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get weekday => integer()(); // 1 = Mon .. 7 = Sun
  TextColumn get title => text()(); // "Chest + Triceps"
  TextColumn get usualTime => text().nullable()(); // "18:30"
  BoolColumn get isRestDay => boolean().withDefault(const Constant(false))();
}

/// Exercises belonging to a [WorkoutDays] entry, kept in display order.
class PlannedExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutDayId =>
      integer().references(WorkoutDays, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()(); // "Barbell Bench Press"
  IntColumn get targetSets => integer().withDefault(const Constant(3))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
}

/// An actual training session instance.
class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutDayId => integer().references(WorkoutDays, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
}

/// One logged set within a session.
class SetLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId =>
      integer().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseName => text()(); // denormalized: history survives plan edits
  IntColumn get setNumber => integer()();
  RealColumn get weightKg => real()();
  IntColumn get reps => integer()();
  RealColumn get rpe => real().nullable()(); // optional 1..10
  BoolColumn get isPr => boolean().withDefault(const Constant(false))();
}

/// Current best per exercise (fast lookup + celebration source).
class PersonalRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exerciseName => text()();
  RealColumn get weightKg => real()();
  IntColumn get reps => integer()();
  DateTimeColumn get achievedAt => dateTime()();
  TextColumn get photoPath => text().nullable()();
}

/// Daily checklist template (recurring items).
class RoutineItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()(); // "Creatine"
  TextColumn get category => text()(); // meal | supplement | hydration | other
  TextColumn get defaultTime => text().nullable()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

/// Per-day completion of a [RoutineItems] entry.
class RoutineChecks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineItemId =>
      integer().references(RoutineItems, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  DateTimeColumn get doneAt => dateTime().nullable()();
}

/// Weekly recurring meal-prep tasks.
class MealPrepTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()(); // "Chop veggies for 3 days"
  IntColumn get weekday => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

/// Per-week completion of a [MealPrepTasks] entry.
class MealPrepChecks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mealPrepTaskId =>
      integer().references(MealPrepTasks, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get weekStart => dateTime()(); // Monday of the week
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
}

/// Weekly bodyweight + optional progress photo.
class BodyLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get weightKg => real()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get note => text().nullable()();
}

/// Single-row app settings (id is always 1).
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get notifyDayBefore => boolean().withDefault(const Constant(false))();
  BoolColumn get notifyBedtime => boolean().withDefault(const Constant(false))();
  BoolColumn get notifyMorning => boolean().withDefault(const Constant(false))();
  TextColumn get bedtimeTarget => text().nullable()();
  TextColumn get weightUnit => text().withDefault(const Constant('kg'))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))(); // system | light | dark
  BoolColumn get hasSeenTour => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
