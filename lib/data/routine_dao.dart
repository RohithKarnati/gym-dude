import 'package:drift/drift.dart';

import 'database.dart';

/// Reactive data access for the daily checklist (F5) and weekly meal-prep (F6).
class RoutineDao {
  RoutineDao(this.db);

  final AppDatabase db;

  static DateTime dayStart(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime mondayOf(DateTime d) {
    final day = dayStart(d);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  // --- Daily checklist items (F5) ------------------------------------------

  Stream<List<RoutineItem>> watchActiveItems() {
    final q = db.select(db.routineItems)
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]);
    return q.watch();
  }

  Future<List<RoutineItem>> getActiveItems() {
    final q = db.select(db.routineItems)
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]);
    return q.get();
  }

  Future<void> addItem({
    required String label,
    required String category,
    String? defaultTime,
  }) async {
    final existing = await getActiveItems();
    final nextOrder =
        existing.isEmpty ? 0 : existing.last.orderIndex + 1;
    await db.into(db.routineItems).insert(
          RoutineItemsCompanion.insert(
            label: label,
            category: category,
            defaultTime: Value(defaultTime),
            orderIndex: Value(nextOrder),
          ),
        );
  }

  Future<void> updateItem({
    required int id,
    required String label,
    required String category,
  }) async {
    await (db.update(db.routineItems)..where((t) => t.id.equals(id))).write(
      RoutineItemsCompanion(label: Value(label), category: Value(category)),
    );
  }

  /// Soft-delete: keeps historical checks intact.
  Future<void> deactivateItem(int id) async {
    await (db.update(db.routineItems)..where((t) => t.id.equals(id)))
        .write(const RoutineItemsCompanion(isActive: Value(false)));
  }

  /// One-tap seeding of common starter items for first-run.
  Future<void> seedStarterItems() async {
    const starters = [
      ('Drink 3L water', 'hydration'),
      ('Breakfast', 'meal'),
      ('Lunch', 'meal'),
      ('Dinner', 'meal'),
      ('Whey protein', 'supplement'),
      ('Creatine', 'supplement'),
      ('Fish oil', 'supplement'),
      ('Multivitamin', 'supplement'),
    ];
    final existing = await getActiveItems();
    var order = existing.isEmpty ? 0 : existing.last.orderIndex + 1;
    await db.batch((b) {
      for (final (label, category) in starters) {
        b.insert(
          db.routineItems,
          RoutineItemsCompanion.insert(
            label: label,
            category: category,
            orderIndex: Value(order++),
          ),
        );
      }
    });
  }

  // --- Daily checks (F5) ----------------------------------------------------

  Stream<List<RoutineCheck>> watchChecksForDay(DateTime day) {
    final d = dayStart(day);
    final q = db.select(db.routineChecks)..where((t) => t.date.equals(d));
    return q.watch();
  }

  Future<void> setRoutineDone(int itemId, DateTime day, bool done) async {
    final d = dayStart(day);
    final existing = await (db.select(db.routineChecks)
          ..where(
              (t) => t.routineItemId.equals(itemId) & t.date.equals(d)))
        .getSingleOrNull();
    if (existing == null) {
      await db.into(db.routineChecks).insert(
            RoutineChecksCompanion.insert(
              routineItemId: itemId,
              date: d,
              isDone: Value(done),
              doneAt: Value(done ? DateTime.now() : null),
            ),
          );
    } else {
      await (db.update(db.routineChecks)..where((t) => t.id.equals(existing.id)))
          .write(RoutineChecksCompanion(
        isDone: Value(done),
        doneAt: Value(done ? DateTime.now() : null),
      ));
    }
  }

  // --- Weekly meal-prep tasks (F6) -----------------------------------------

  Stream<List<MealPrepTask>> watchActiveTasks() {
    final q = db.select(db.mealPrepTasks)
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.weekday)]);
    return q.watch();
  }

  Future<void> addMealPrepTask({
    required String label,
    required int weekday,
  }) async {
    await db.into(db.mealPrepTasks).insert(
          MealPrepTasksCompanion.insert(label: label, weekday: weekday),
        );
  }

  Future<void> deactivateMealPrepTask(int id) async {
    await (db.update(db.mealPrepTasks)..where((t) => t.id.equals(id)))
        .write(const MealPrepTasksCompanion(isActive: Value(false)));
  }

  Stream<List<MealPrepCheck>> watchMealPrepChecksForWeek(DateTime weekStart) {
    final w = dayStart(weekStart);
    final q = db.select(db.mealPrepChecks)..where((t) => t.weekStart.equals(w));
    return q.watch();
  }

  Future<void> setMealPrepDone(int taskId, DateTime weekStart, bool done) async {
    final w = dayStart(weekStart);
    final existing = await (db.select(db.mealPrepChecks)
          ..where(
              (t) => t.mealPrepTaskId.equals(taskId) & t.weekStart.equals(w)))
        .getSingleOrNull();
    if (existing == null) {
      await db.into(db.mealPrepChecks).insert(
            MealPrepChecksCompanion.insert(
              mealPrepTaskId: taskId,
              weekStart: w,
              isDone: Value(done),
            ),
          );
    } else {
      await (db.update(db.mealPrepChecks)
            ..where((t) => t.id.equals(existing.id)))
          .write(MealPrepChecksCompanion(isDone: Value(done)));
    }
  }
}
