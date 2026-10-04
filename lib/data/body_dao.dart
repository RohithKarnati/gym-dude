import 'package:drift/drift.dart';

import 'database.dart';

/// Reactive data access for bodyweight + progress photos (F7).
class BodyDao {
  BodyDao(this.db);

  final AppDatabase db;

  /// Oldest first — convenient for the trend chart.
  Stream<List<BodyLog>> watchLogs() {
    final q = db.select(db.bodyLogs)
      ..orderBy([(t) => OrderingTerm(expression: t.date)]);
    return q.watch();
  }

  Future<void> addLog({
    required DateTime date,
    required double weightKg,
    String? photoPath,
    String? note,
  }) async {
    await db.into(db.bodyLogs).insert(
          BodyLogsCompanion.insert(
            date: DateTime(date.year, date.month, date.day),
            weightKg: weightKg,
            photoPath: Value(photoPath),
            note: Value(note),
          ),
        );
  }

  Future<void> deleteLog(int id) async {
    await (db.delete(db.bodyLogs)..where((t) => t.id.equals(id))).go();
  }
}
