import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/routine_dao.dart';
import '../utils/recurrence.dart';
import 'database_provider.dart';

final routineDaoProvider = Provider<RoutineDao>((ref) {
  return RoutineDao(ref.watch(databaseProvider));
});

/// User-defined lists (tabs), ordered.
final routineListsProvider = StreamProvider<List<RoutineList>>((ref) {
  return ref.watch(routineDaoProvider).watchLists();
});

/// Active checklist tasks in one list.
final listItemsProvider =
    StreamProvider.family<List<RoutineItem>, int>((ref, listId) {
  return ref.watch(routineDaoProvider).watchItemsForList(listId);
});

/// All active checklist tasks across all lists (reminders, progress).
final allRoutineItemsProvider = StreamProvider<List<RoutineItem>>((ref) {
  return ref.watch(routineDaoProvider).watchActiveItems();
});

/// Today's completion rows.
final routineChecksTodayProvider = StreamProvider<List<RoutineCheck>>((ref) {
  return ref.watch(routineDaoProvider).watchChecksForDay(DateTime.now());
});

/// Set of routine-item ids completed today (for quick lookup).
final doneTodayIdsProvider = Provider<Set<int>>((ref) {
  final checks = ref.watch(routineChecksTodayProvider).value ?? const [];
  return {for (final c in checks) if (c.isDone) c.routineItemId};
});

/// (done, total) for *today's scheduled* tasks — drives the home progress ring.
typedef Progress = ({int done, int total});

final dailyProgressProvider = Provider<Progress>((ref) {
  final items = ref.watch(allRoutineItemsProvider).value ?? const [];
  final done = ref.watch(doneTodayIdsProvider);
  final today = items.where((i) => isScheduledToday(i.daysMask)).toList();
  final doneCount = today.where((i) => done.contains(i.id)).length;
  return (done: doneCount, total: today.length);
});
