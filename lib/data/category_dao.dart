import 'package:drift/drift.dart';

import 'database.dart';

/// Access to user-defined [Categories] (merged with built-in presets in the UI).
class CategoryDao {
  CategoryDao(this.db);

  final AppDatabase db;

  Stream<List<Category>> watchCustom() {
    final q = db.select(db.categories)
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]);
    return q.watch();
  }

  /// Add a custom category; ignores duplicates (unique name).
  Future<void> addCategory(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final existing = await (db.select(db.categories)
          ..where((t) => t.name.equals(trimmed)))
        .getSingleOrNull();
    if (existing != null) return;
    final all = await db.select(db.categories).get();
    final nextOrder = all.isEmpty ? 0 : all.length;
    await db.into(db.categories).insert(
          CategoriesCompanion.insert(name: trimmed, orderIndex: Value(nextOrder)),
        );
  }

  Future<void> deleteCategory(int id) async {
    await (db.delete(db.categories)..where((t) => t.id.equals(id))).go();
  }
}
