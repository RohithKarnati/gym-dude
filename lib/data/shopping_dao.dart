import 'package:drift/drift.dart';

import 'database.dart';

/// Access to the shopping / "to buy" list ([ShoppingItems]).
class ShoppingDao {
  ShoppingDao(this.db);

  final AppDatabase db;

  /// Items in a list: unbought first, then bought; stable order within each.
  Stream<List<ShoppingItem>> watchItems(int listId) {
    final q = db.select(db.shoppingItems)
      ..where((t) => t.listId.equals(listId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.isBought),
        (t) => OrderingTerm(expression: t.orderIndex),
      ]);
    return q.watch();
  }

  Future<void> addItem(int listId, String label) async {
    final trimmed = label.trim();
    if (trimmed.isEmpty) return;
    final all = await (db.select(db.shoppingItems)
          ..where((t) => t.listId.equals(listId)))
        .get();
    final nextOrder = all.isEmpty ? 0 : all.length;
    await db.into(db.shoppingItems).insert(
          ShoppingItemsCompanion.insert(
            listId: Value(listId),
            label: trimmed,
            orderIndex: Value(nextOrder),
          ),
        );
  }

  Future<void> setBought(int id, bool bought) async {
    await (db.update(db.shoppingItems)..where((t) => t.id.equals(id)))
        .write(ShoppingItemsCompanion(isBought: Value(bought)));
  }

  Future<void> deleteItem(int id) async {
    await (db.delete(db.shoppingItems)..where((t) => t.id.equals(id))).go();
  }

  /// Remove all bought items in a list.
  Future<void> clearBought(int listId) async {
    await (db.delete(db.shoppingItems)
          ..where((t) => t.isBought.equals(true) & t.listId.equals(listId)))
        .go();
  }
}
