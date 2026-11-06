import 'package:drift/drift.dart';

import 'database.dart';

/// Reactive data access for the unified routine model: user-defined lists (tabs)
/// of checklist tasks with per-task day-of-week recurrence, plus shopping lists.
class RoutineDao {
  RoutineDao(this.db);

  final AppDatabase db;

  static DateTime dayStart(DateTime d) => DateTime(d.year, d.month, d.day);

  // --- Lists (tabs) ---------------------------------------------------------

  Stream<List<RoutineList>> watchLists() {
    final q = db.select(db.routineLists)
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]);
    return q.watch();
  }

  Future<List<RoutineList>> getLists() {
    final q = db.select(db.routineLists)
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]);
    return q.get();
  }

  /// Guarantee at least a "Daily" checklist list exists; returns its id.
  Future<int> ensureDefaultList() async {
    final lists = await getLists();
    if (lists.isNotEmpty) {
      final daily = lists.firstWhere(
        (l) => l.kind == 'checklist',
        orElse: () => lists.first,
      );
      return daily.id;
    }
    return addList(name: 'Daily', kind: 'checklist');
  }

  Future<int> addList({required String name, required String kind}) async {
    final existing = await getLists();
    final nextOrder = existing.isEmpty ? 0 : existing.last.orderIndex + 1;
    return db.into(db.routineLists).insert(
          RoutineListsCompanion.insert(
            name: name,
            kind: Value(kind),
            orderIndex: Value(nextOrder),
          ),
        );
  }

  Future<void> renameList(int id, String name) async {
    await (db.update(db.routineLists)..where((t) => t.id.equals(id)))
        .write(RoutineListsCompanion(name: Value(name)));
  }

  /// Soft-delete a list (keeps its items/history; they just stop showing).
  Future<void> deactivateList(int id) async {
    await (db.update(db.routineLists)..where((t) => t.id.equals(id)))
        .write(const RoutineListsCompanion(isActive: Value(false)));
  }

  // --- Checklist tasks ------------------------------------------------------

  Stream<List<RoutineItem>> watchItemsForList(int listId) {
    final q = db.select(db.routineItems)
      ..where((t) => t.isActive.equals(true) & t.listId.equals(listId))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]);
    return q.watch();
  }

  /// All active checklist tasks across all lists — drives reminders + progress.
  Future<List<RoutineItem>> getActiveItems() {
    final q = db.select(db.routineItems)
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]);
    return q.get();
  }

  Stream<List<RoutineItem>> watchActiveItems() {
    final q = db.select(db.routineItems)
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]);
    return q.watch();
  }

  Future<void> addItem({
    required int listId,
    required String label,
    required String category,
    int daysMask = 127,
    String? defaultTime,
    int? hydrationGoalMl,
    int? hydrationIntervalMin,
  }) async {
    final existing = await (db.select(db.routineItems)
          ..where((t) => t.listId.equals(listId)))
        .get();
    final nextOrder = existing.isEmpty
        ? 0
        : existing.map((e) => e.orderIndex).reduce((a, b) => a > b ? a : b) + 1;
    await db.into(db.routineItems).insert(
          RoutineItemsCompanion.insert(
            listId: Value(listId),
            label: label,
            category: category,
            daysMask: Value(daysMask),
            defaultTime: Value(defaultTime),
            hydrationGoalMl: Value(hydrationGoalMl),
            hydrationIntervalMin: Value(hydrationIntervalMin),
            orderIndex: Value(nextOrder),
          ),
        );
  }

  Future<void> updateItem({
    required int id,
    required String label,
    required String category,
    required int daysMask,
    String? defaultTime,
    int? hydrationGoalMl,
    int? hydrationIntervalMin,
  }) async {
    await (db.update(db.routineItems)..where((t) => t.id.equals(id))).write(
      RoutineItemsCompanion(
        label: Value(label),
        category: Value(category),
        daysMask: Value(daysMask),
        defaultTime: Value(defaultTime),
        hydrationGoalMl: Value(hydrationGoalMl),
        hydrationIntervalMin: Value(hydrationIntervalMin),
      ),
    );
  }

  Future<void> deactivateItem(int id) async {
    await (db.update(db.routineItems)..where((t) => t.id.equals(id)))
        .write(const RoutineItemsCompanion(isActive: Value(false)));
  }

  /// One-tap seeding of common starter items into [listId] (every day).
  Future<void> seedStarterItems(int listId) async {
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
    var order = 0;
    await db.batch((b) {
      for (final (label, category) in starters) {
        b.insert(
          db.routineItems,
          RoutineItemsCompanion.insert(
            listId: Value(listId),
            label: label,
            category: category,
            orderIndex: Value(order++),
          ),
        );
      }
    });
  }

  // --- Daily checks ---------------------------------------------------------

  Stream<List<RoutineCheck>> watchChecksForDay(DateTime day) {
    final d = dayStart(day);
    final q = db.select(db.routineChecks)..where((t) => t.date.equals(d));
    return q.watch();
  }

  Future<void> setRoutineDone(int itemId, DateTime day, bool done) async {
    final d = dayStart(day);
    final existing = await (db.select(db.routineChecks)
          ..where((t) => t.routineItemId.equals(itemId) & t.date.equals(d)))
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
}
