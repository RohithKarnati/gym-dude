import 'package:drift/drift.dart';

import 'database.dart';
import 'routine_dao.dart';

/// Reactive data access for hydration logging (v8). Hydration lives on a routine
/// item (category == 'hydration'); each drink is a row tied to that item, and a
/// day's intake is the sum of that item's rows. When the day's intake reaches
/// the item's goal, the item's routine check is ticked automatically so it flows
/// through the normal "done today" progress.
class HydrationDao {
  HydrationDao(this.db);

  final AppDatabase db;

  static DateTime dayStart(DateTime d) => DateTime(d.year, d.month, d.day);

  /// An item's drinks for a day, newest first.
  Stream<List<HydrationLog>> watchLogsForDay(int itemId, DateTime day) {
    final d = dayStart(day);
    final q = db.select(db.hydrationLogs)
      ..where((t) => t.itemId.equals(itemId) & t.date.equals(d))
      ..orderBy(
          [(t) => OrderingTerm(expression: t.loggedAt, mode: OrderingMode.desc)]);
    return q.watch();
  }

  Future<int> getIntakeForDay(int itemId, DateTime day) async {
    final logs = await (db.select(db.hydrationLogs)
          ..where((t) => t.itemId.equals(itemId) & t.date.equals(dayStart(day))))
        .get();
    return logs.fold<int>(0, (sum, l) => sum + l.amountMl);
  }

  Future<void> addDrink(int itemId, int amountMl, {DateTime? at}) async {
    final now = at ?? DateTime.now();
    await db.into(db.hydrationLogs).insert(
          HydrationLogsCompanion.insert(
            itemId: Value(itemId),
            date: dayStart(now),
            amountMl: amountMl,
            loggedAt: now,
          ),
        );
    await syncCheck(itemId, now);
  }

  Future<void> deleteLog(int id) async {
    final log = await (db.select(db.hydrationLogs)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await (db.delete(db.hydrationLogs)..where((t) => t.id.equals(id))).go();
    if (log?.itemId != null) await syncCheck(log!.itemId!, log.date);
  }

  Future<void> clearDay(int itemId, DateTime day) async {
    final d = dayStart(day);
    await (db.delete(db.hydrationLogs)
          ..where((t) => t.itemId.equals(itemId) & t.date.equals(d)))
        .go();
    await syncCheck(itemId, day);
  }

  /// Mark the item done/undone for the day based on goal vs. intake.
  /// Public so the item editor can re-sync when a goal is set/changed.
  Future<void> syncCheck(int itemId, DateTime day) async {
    final item = await (db.select(db.routineItems)
          ..where((t) => t.id.equals(itemId)))
        .getSingleOrNull();
    final goal = item?.hydrationGoalMl;
    if (goal == null || goal <= 0) return;
    final total = await getIntakeForDay(itemId, day);
    await RoutineDao(db).setRoutineDone(itemId, day, total >= goal);
  }
}
