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
  TextColumn get category =>
      text().withDefault(const Constant('Other'))(); // Chest | Back | Legs | ...
  IntColumn get targetSets => integer().withDefault(const Constant(3))();
  RealColumn get targetWeightKg => real().nullable()(); // planned working weight
  /// Cardio logging mode: null = strength (weight × reps); otherwise one of
  /// 'distance' (km), 'duration' (minutes), 'count' (e.g. skips).
  TextColumn get cardioMetric => text().nullable()();
  /// Whether a new best set should be detected and celebrated as a personal
  /// record. On by default; turn off for exercises you don't want PR noise on
  /// (warm-ups, machine/accessory work). Sets still log normally either way.
  BoolColumn get trackPr => boolean().withDefault(const Constant(true))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
}

/// An actual training session instance.
class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutDayId => integer().references(WorkoutDays, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  /// Set when the user taps "Finish workout"; null while still in progress.
  DateTimeColumn get completedAt => dateTime().nullable()();
}

/// One logged set within a session.
class SetLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId =>
      integer().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseName => text()(); // denormalized: history survives plan edits
  IntColumn get setNumber => integer()();
  RealColumn get weightKg => real()(); // 0 for cardio
  IntColumn get reps => integer()(); // reused as the "count" for cardio-count
  RealColumn get rpe => real().nullable()(); // optional 1..10
  // Cardio fields (null for strength sets).
  RealColumn get distanceKm => real().nullable()();
  IntColumn get durationSec => integer().nullable()();
  BoolColumn get isPr => boolean().withDefault(const Constant(false))();
}

/// Current best per exercise (fast lookup + celebration source).
class PersonalRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exerciseName => text()();
  TextColumn get category =>
      text().withDefault(const Constant('Other'))(); // muscle group, for grouping
  RealColumn get weightKg => real()();
  IntColumn get reps => integer()();
  /// Cardio PR shape (null metric = classic weight × reps record).
  TextColumn get metric => text().nullable()(); // distance | duration | count
  RealColumn get distanceKm => real().nullable()();
  IntColumn get durationSec => integer().nullable()();
  DateTimeColumn get achievedAt => dateTime()();
  TextColumn get photoPath => text().nullable()();
}

/// A user-defined routine tab/list (Daily, Supplements, Meal prep, Groceries…).
class RoutineLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get kind =>
      text().withDefault(const Constant('checklist'))(); // checklist | shopping
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

/// Checklist tasks (recurring). Each belongs to a [RoutineLists] and recurs on
/// the weekdays in [daysMask] (bit 0 = Mon … bit 6 = Sun; 127 = every day).
class RoutineItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get listId => integer().nullable()(); // -> RoutineLists.id
  TextColumn get label => text()(); // "Creatine"
  TextColumn get category => text()(); // meal | supplement | hydration | other
  TextColumn get defaultTime => text().nullable()(); // "HH:mm" reminder time
  IntColumn get daysMask =>
      integer().withDefault(const Constant(127))(); // recurrence, 127 = daily
  // Hydration items (category == 'hydration') carry a goal + reminder frequency
  // instead of a single reminder time. Null for ordinary checklist tasks.
  IntColumn get hydrationGoalMl => integer().nullable()();
  IntColumn get hydrationIntervalMin => integer().nullable()();
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
  TextColumn get reminderTime => text().nullable()(); // "HH:mm" optional reminder
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

/// User-defined workout categories (merged with the built-in presets).
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
}

/// Shopping / "to buy" list items (groceries, supplements, …). Each belongs to
/// a shopping-kind [RoutineLists].
class ShoppingItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get listId => integer().nullable()(); // -> RoutineLists.id
  TextColumn get label => text()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isBought => boolean().withDefault(const Constant(false))();
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
  // --- Hydration reminders (v7) ---
  BoolColumn get hydrationEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get hydrationGoalMl =>
      integer().withDefault(const Constant(3000))();
  IntColumn get hydrationIntervalMin =>
      integer().withDefault(const Constant(120))();
  TextColumn get hydrationStart =>
      text().withDefault(const Constant('08:00'))();
  TextColumn get hydrationEnd => text().withDefault(const Constant('22:00'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// One logged drink, tied to its hydration routine item. A day's intake for an
/// item is the sum of that item's rows for the day.
class HydrationLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().nullable()(); // -> RoutineItems.id
  DateTimeColumn get date => dateTime()(); // day start (midnight)
  IntColumn get amountMl => integer()();
  DateTimeColumn get loggedAt => dateTime()();
}
