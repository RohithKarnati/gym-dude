import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/shopping_dao.dart';
import 'database_provider.dart';

final shoppingDaoProvider = Provider<ShoppingDao>((ref) {
  return ShoppingDao(ref.watch(databaseProvider));
});

final shoppingItemsProvider =
    StreamProvider.family<List<ShoppingItem>, int>((ref, listId) {
  return ref.watch(shoppingDaoProvider).watchItems(listId);
});
