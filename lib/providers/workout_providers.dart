import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/workout_dao.dart';
import 'database_provider.dart';

final workoutDaoProvider = Provider<WorkoutDao>((ref) {
  return WorkoutDao(ref.watch(databaseProvider));
});

/// All configured plan days (Mon..Sun).
final allDaysProvider = StreamProvider<List<WorkoutDay>>((ref) {
  return ref.watch(workoutDaoProvider).watchAllDays();
});

/// Planned exercises for a given workout day id.
final exercisesProvider =
    StreamProvider.family<List<PlannedExercise>, int>((ref, workoutDayId) {
  return ref.watch(workoutDaoProvider).watchExercises(workoutDayId);
});

/// Logged sets for a session.
final sessionSetLogsProvider =
    StreamProvider.family<List<SetLog>, int>((ref, sessionId) {
  return ref.watch(workoutDaoProvider).watchSetLogs(sessionId);
});

typedef ExerciseInSession = ({int sessionId, String exerciseName});

/// Sets logged for one exercise within the current session.
final exerciseSetLogsProvider =
    StreamProvider.family<List<SetLog>, ExerciseInSession>((ref, key) {
  return ref
      .watch(workoutDaoProvider)
      .watchSetLogsForExercise(key.sessionId, key.exerciseName);
});

/// The "🎯 beat this" target for an exercise: best set from prior sessions.
final beatThisTargetProvider =
    FutureProvider.family<SetLog?, ExerciseInSession>((ref, key) {
  return ref
      .watch(workoutDaoProvider)
      .bestPreviousSet(key.exerciseName, excludeSessionId: key.sessionId);
});

/// The current personal record for an exercise (F3), reactive.
final exercisePrProvider =
    StreamProvider.family<PersonalRecord?, String>((ref, exerciseName) {
  return ref.watch(workoutDaoProvider).watchPr(exerciseName);
});

/// All personal records, most recent first (F4 history).
final allPrsProvider = StreamProvider<List<PersonalRecord>>((ref) {
  return ref.watch(workoutDaoProvider).watchAllPrs();
});

/// Training stats for the home screen (F8): days trained this week and the
/// consecutive-week streak.
class TrainingStats {
  const TrainingStats({required this.daysThisWeek, required this.weekStreak});
  final int daysThisWeek;
  final int weekStreak;

  static const empty = TrainingStats(daysThisWeek: 0, weekStreak: 0);
}

DateTime _mondayOf(DateTime d) {
  final day = DateTime(d.year, d.month, d.day);
  return day.subtract(Duration(days: day.weekday - 1));
}

final trainingStatsProvider = StreamProvider<TrainingStats>((ref) {
  final dao = ref.watch(workoutDaoProvider);
  return dao.watchAllSessions().map((sessions) {
    if (sessions.isEmpty) return TrainingStats.empty;

    // Distinct trained calendar days.
    final trainedDays = <DateTime>{
      for (final s in sessions) DateTime(s.date.year, s.date.month, s.date.day),
    };
    // Weeks (by Monday) that have at least one session.
    final trainedWeeks = <DateTime>{for (final d in trainedDays) _mondayOf(d)};

    final thisMonday = _mondayOf(DateTime.now());
    final nextMonday = thisMonday.add(const Duration(days: 7));
    final daysThisWeek = trainedDays
        .where((d) => !d.isBefore(thisMonday) && d.isBefore(nextMonday))
        .length;

    // Streak: count back from this week; if this week has none yet, the
    // streak is preserved and counted from last week.
    var streak = 0;
    var cursor = thisMonday;
    if (!trainedWeeks.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 7));
    }
    while (trainedWeeks.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 7));
    }

    return TrainingStats(daysThisWeek: daysThisWeek, weekStreak: streak);
  });
});
