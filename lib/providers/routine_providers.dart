import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/routine_dao.dart';
import 'database_provider.dart';

final routineDaoProvider = Provider<RoutineDao>((ref) {
  return RoutineDao(ref.watch(databaseProvider));
});

// --- Daily checklist (F5) ---------------------------------------------------

final routineItemsProvider = StreamProvider<List<RoutineItem>>((ref) {
  return ref.watch(routineDaoProvider).watchActiveItems();
});

/// Today's completion rows.
final routineChecksTodayProvider =
    StreamProvider<List<RoutineCheck>>((ref) {
  return ref.watch(routineDaoProvider).watchChecksForDay(DateTime.now());
});

/// Set of routine-item ids completed today (for quick lookup).
final doneTodayIdsProvider = Provider<Set<int>>((ref) {
  final checks = ref.watch(routineChecksTodayProvider).value ?? const [];
  return {for (final c in checks) if (c.isDone) c.routineItemId};
});

/// (done, total) for today's checklist — drives the home progress ring.
typedef Progress = ({int done, int total});

final dailyProgressProvider = Provider<Progress>((ref) {
  final items = ref.watch(routineItemsProvider).value ?? const [];
  final done = ref.watch(doneTodayIdsProvider);
  final total = items.length;
  final doneCount = items.where((i) => done.contains(i.id)).length;
  return (done: doneCount, total: total);
});

// --- Weekly meal-prep (F6) --------------------------------------------------

final mealPrepTasksProvider = StreamProvider<List<MealPrepTask>>((ref) {
  return ref.watch(routineDaoProvider).watchActiveTasks();
});

final mealPrepChecksThisWeekProvider =
    StreamProvider<List<MealPrepCheck>>((ref) {
  final weekStart = RoutineDao.mondayOf(DateTime.now());
  return ref.watch(routineDaoProvider).watchMealPrepChecksForWeek(weekStart);
});

final mealPrepDoneIdsProvider = Provider<Set<int>>((ref) {
  final checks = ref.watch(mealPrepChecksThisWeekProvider).value ?? const [];
  return {for (final c in checks) if (c.isDone) c.mealPrepTaskId};
});
