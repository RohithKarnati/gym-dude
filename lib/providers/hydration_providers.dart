import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/hydration_dao.dart';
import 'database_provider.dart';
import 'routine_providers.dart';

final hydrationDaoProvider = Provider<HydrationDao>((ref) {
  return HydrationDao(ref.watch(databaseProvider));
});

/// Active routine items that track hydration (category 'hydration' with a goal).
final hydrationItemsProvider = Provider<List<RoutineItem>>((ref) {
  final items = ref.watch(allRoutineItemsProvider).value ?? const [];
  return items
      .where((i) => i.category == 'hydration' && i.hydrationGoalMl != null)
      .toList();
});

/// One hydration item's drinks today (newest first), keyed by item id.
final hydrationLogsTodayProvider =
    StreamProvider.family<List<HydrationLog>, int>((ref, itemId) {
  return ref.watch(hydrationDaoProvider).watchLogsForDay(itemId, DateTime.now());
});

/// One hydration item's total intake today (ml), keyed by item id.
final hydrationIntakeTodayProvider = Provider.family<int, int>((ref, itemId) {
  final logs = ref.watch(hydrationLogsTodayProvider(itemId)).value ?? const [];
  return logs.fold<int>(0, (sum, l) => sum + l.amountMl);
});
