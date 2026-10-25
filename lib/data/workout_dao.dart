import 'package:drift/drift.dart';

import 'database.dart';

/// Outcome of logging a set that beat the exercise's existing record.
class PrResult {
  PrResult({
    required this.previous,
    required this.weightKg,
    required this.reps,
    this.metric,
    this.distanceKm,
    this.durationSec,
  });

  /// The record that was beaten (null only when this is handled silently).
  final PersonalRecord? previous;
  final double weightKg;
  final int reps;

  /// Cardio shape (null = classic weight × reps PR).
  final String? metric; // distance | duration | count
  final double? distanceKm;
  final int? durationSec;
}

/// Reactive data access for the plan + logging core loop (F1 / F2).
///
/// Written as plain Dart over drift's generated API, so no extra codegen
/// is needed when these queries change.
class WorkoutDao {
  WorkoutDao(this.db);

  final AppDatabase db;

  // --- Weekly plan (F1) -----------------------------------------------------

  /// All configured days, ordered Mon..Sun.
  Stream<List<WorkoutDay>> watchAllDays() {
    final q = db.select(db.workoutDays)
      ..orderBy([(t) => OrderingTerm(expression: t.weekday)]);
    return q.watch();
  }

  Future<WorkoutDay?> getDayForWeekday(int weekday) {
    final q = db.select(db.workoutDays)
      ..where((t) => t.weekday.equals(weekday))
      ..limit(1);
    return q.getSingleOrNull();
  }

  Future<WorkoutDay?> getDayById(int id) {
    final q = db.select(db.workoutDays)..where((t) => t.id.equals(id));
    return q.getSingleOrNull();
  }

  /// Create (if missing) or update the plan entry for a weekday.
  /// Returns the day's id.
  Future<int> upsertDay({
    required int weekday,
    required String title,
    String? usualTime,
    required bool isRestDay,
  }) async {
    final existing = await getDayForWeekday(weekday);
    if (existing == null) {
      return db.into(db.workoutDays).insert(
            WorkoutDaysCompanion.insert(
              weekday: weekday,
              title: title,
              usualTime: Value(usualTime),
              isRestDay: Value(isRestDay),
            ),
          );
    }
    await (db.update(db.workoutDays)..where((t) => t.id.equals(existing.id)))
        .write(
      WorkoutDaysCompanion(
        title: Value(title),
        usualTime: Value(usualTime),
        isRestDay: Value(isRestDay),
      ),
    );
    return existing.id;
  }

  // --- Planned exercises (F1) ----------------------------------------------

  Stream<List<PlannedExercise>> watchExercises(int workoutDayId) {
    final q = db.select(db.plannedExercises)
      ..where((t) => t.workoutDayId.equals(workoutDayId))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]);
    return q.watch();
  }

  Future<List<PlannedExercise>> getExercises(int workoutDayId) {
    final q = db.select(db.plannedExercises)
      ..where((t) => t.workoutDayId.equals(workoutDayId))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]);
    return q.get();
  }

  Future<void> addExercise({
    required int workoutDayId,
    required String name,
    required int targetSets,
    String category = 'Other',
    double? targetWeightKg,
    String? cardioMetric,
    bool trackPr = true,
  }) async {
    final existing = await getExercises(workoutDayId);
    final nextOrder = existing.isEmpty ? 0 : existing.last.orderIndex + 1;
    await db.into(db.plannedExercises).insert(
          PlannedExercisesCompanion.insert(
            workoutDayId: workoutDayId,
            name: name,
            category: Value(category),
            targetSets: Value(targetSets),
            targetWeightKg: Value(targetWeightKg),
            cardioMetric: Value(cardioMetric),
            trackPr: Value(trackPr),
            orderIndex: Value(nextOrder),
          ),
        );
  }

  Future<void> updateExercise({
    required int id,
    required String name,
    required int targetSets,
    String category = 'Other',
    double? targetWeightKg,
    String? cardioMetric,
    bool trackPr = true,
  }) async {
    await (db.update(db.plannedExercises)..where((t) => t.id.equals(id))).write(
      PlannedExercisesCompanion(
        name: Value(name),
        category: Value(category),
        targetSets: Value(targetSets),
        targetWeightKg: Value(targetWeightKg),
        cardioMetric: Value(cardioMetric),
        trackPr: Value(trackPr),
      ),
    );
  }

  Future<void> deleteExercise(int id) async {
    await (db.delete(db.plannedExercises)..where((t) => t.id.equals(id))).go();
  }

  /// Persist a new ordering (list is in the desired display order).
  Future<void> reorderExercises(List<PlannedExercise> ordered) async {
    await db.batch((b) {
      for (var i = 0; i < ordered.length; i++) {
        b.update(
          db.plannedExercises,
          PlannedExercisesCompanion(orderIndex: Value(i)),
          where: (t) => t.id.equals(ordered[i].id),
        );
      }
    });
  }

  // --- Sessions + set logs (F2) --------------------------------------------

  /// Find today's session for a day, or create one.
  Future<WorkoutSession> startOrGetTodaySession(int workoutDayId) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final existingQuery = db.select(db.workoutSessions)
      ..where((t) =>
          t.workoutDayId.equals(workoutDayId) &
          t.date.isBiggerOrEqualValue(start) &
          t.date.isSmallerThanValue(end))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
      ..limit(1);
    final existing = await existingQuery.getSingleOrNull();
    if (existing != null) return existing;

    final id = await db.into(db.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            workoutDayId: workoutDayId,
            date: now,
          ),
        );
    return (db.select(db.workoutSessions)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  /// All sessions, newest first — drives streak/stats (F8).
  Stream<List<WorkoutSession>> watchAllSessions() {
    final q = db.select(db.workoutSessions)
      ..orderBy(
          [(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]);
    return q.watch();
  }

  /// Mark a session finished (F: "Finish workout").
  Future<void> finishSession(int sessionId) async {
    await (db.update(db.workoutSessions)..where((t) => t.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(completedAt: Value(DateTime.now())));
  }

  /// All sets in a session (any exercise) — used for the finish summary.
  Future<List<SetLog>> getSetLogsForSession(int sessionId) {
    final q = db.select(db.setLogs)
      ..where((t) => t.sessionId.equals(sessionId))
      ..orderBy([(t) => OrderingTerm(expression: t.setNumber)]);
    return q.get();
  }

  Stream<List<SetLog>> watchSetLogs(int sessionId) {
    final q = db.select(db.setLogs)
      ..where((t) => t.sessionId.equals(sessionId))
      ..orderBy([(t) => OrderingTerm(expression: t.setNumber)]);
    return q.watch();
  }

  Stream<List<SetLog>> watchSetLogsForExercise(
    int sessionId,
    String exerciseName,
  ) {
    final q = db.select(db.setLogs)
      ..where((t) =>
          t.sessionId.equals(sessionId) & t.exerciseName.equals(exerciseName))
      ..orderBy([(t) => OrderingTerm(expression: t.setNumber)]);
    return q.watch();
  }

  /// Log a set. Detects a new personal record (F3): returns a [PrResult] (which
  /// drives the celebration) only when the top-set **weight** goes up.
  ///
  /// Rules:
  /// - Heavier weight than the current best → celebrated PR (returns a result,
  ///   flags the set).
  /// - More reps at the same weight → still updates the tracked best so the
  ///   "beat this" target stays accurate, but **no celebration** (returns null).
  /// - The very first set for an exercise seeds the record silently.
  Future<PrResult?> addSetLog({
    required int sessionId,
    required String exerciseName,
    required double weightKg,
    required int reps,
    double? rpe,
    String category = 'Other',
    String? metric, // null = strength; distance | duration | count for cardio
    double? distanceKm,
    int? durationSec,
    bool trackPr = true,
  }) async {
    final prior = await (db.select(db.setLogs)
          ..where((t) =>
              t.sessionId.equals(sessionId) &
              t.exerciseName.equals(exerciseName)))
        .get();
    final nextSetNumber = prior.length + 1;

    // PR tracking disabled for this exercise: log the set plainly, never flag
    // it, celebrate it, or touch the personal-records table.
    if (!trackPr) {
      await db.into(db.setLogs).insert(
            SetLogsCompanion.insert(
              sessionId: sessionId,
              exerciseName: exerciseName,
              setNumber: nextSetNumber,
              weightKg: weightKg,
              reps: reps,
              rpe: Value(rpe),
              distanceKm: Value(distanceKm),
              durationSec: Value(durationSec),
              isPr: const Value(false),
            ),
          );
      return null;
    }

    final storedPr = await getPr(exerciseName);
    // A record of a different shape (switched strength<->cardio, or metric
    // changed) doesn't compare — treat as the first of its kind.
    final existingPr = (storedPr != null && storedPr.metric == metric)
        ? storedPr
        : null;
    final isFirstEver = existingPr == null;

    bool beats = false; // celebrate + flag the set
    bool silentImprove = false; // update tracked best, no celebration
    if (existingPr != null) {
      if (metric == null) {
        if (weightKg > existingPr.weightKg) {
          beats = true;
        } else if (weightKg == existingPr.weightKg && reps > existingPr.reps) {
          silentImprove = true;
        }
      } else {
        beats = _cardioBeats(metric, existingPr, distanceKm, durationSec, reps);
      }
    }
    final isPr = beats;

    await db.into(db.setLogs).insert(
          SetLogsCompanion.insert(
            sessionId: sessionId,
            exerciseName: exerciseName,
            setNumber: nextSetNumber,
            weightKg: weightKg,
            reps: reps,
            rpe: Value(rpe),
            distanceKm: Value(distanceKm),
            durationSec: Value(durationSec),
            isPr: Value(isPr),
          ),
        );

    if (isFirstEver || beats || silentImprove) {
      await _upsertPr(exerciseName, weightKg, reps, category,
          metric: metric, distanceKm: distanceKm, durationSec: durationSec);
    }
    if (beats) {
      return PrResult(
        previous: existingPr,
        weightKg: weightKg,
        reps: reps,
        metric: metric,
        distanceKm: distanceKm,
        durationSec: durationSec,
      );
    }
    return null;
  }

  /// Cardio PR rule: more distance (tie → faster time), more duration, or a
  /// higher count all count as beating the record.
  bool _cardioBeats(
    String metric,
    PersonalRecord pr,
    double? distanceKm,
    int? durationSec,
    int count,
  ) {
    switch (metric) {
      case 'distance':
        final best = pr.distanceKm ?? 0;
        final d = distanceKm ?? 0;
        if (d > best) return true;
        // Same distance, faster time (both times known).
        return d == best &&
            durationSec != null &&
            pr.durationSec != null &&
            durationSec < pr.durationSec!;
      case 'duration':
        return (durationSec ?? 0) > (pr.durationSec ?? 0);
      case 'count':
        return count > pr.reps;
    }
    return false;
  }

  Future<void> _upsertPr(
    String exerciseName,
    double weightKg,
    int reps,
    String category, {
    String? metric,
    double? distanceKm,
    int? durationSec,
  }) async {
    final existing = await getPr(exerciseName);
    if (existing == null) {
      await db.into(db.personalRecords).insert(
            PersonalRecordsCompanion.insert(
              exerciseName: exerciseName,
              category: Value(category),
              weightKg: weightKg,
              reps: reps,
              metric: Value(metric),
              distanceKm: Value(distanceKm),
              durationSec: Value(durationSec),
              achievedAt: DateTime.now(),
            ),
          );
    } else {
      await (db.update(db.personalRecords)
            ..where((t) => t.id.equals(existing.id)))
          .write(
        PersonalRecordsCompanion(
          category: Value(category),
          weightKg: Value(weightKg),
          reps: Value(reps),
          metric: Value(metric),
          distanceKm: Value(distanceKm),
          durationSec: Value(durationSec),
          achievedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<PersonalRecord?> getPr(String exerciseName) {
    final q = db.select(db.personalRecords)
      ..where((t) => t.exerciseName.equals(exerciseName))
      ..limit(1);
    return q.getSingleOrNull();
  }

  Stream<PersonalRecord?> watchPr(String exerciseName) {
    final q = db.select(db.personalRecords)
      ..where((t) => t.exerciseName.equals(exerciseName))
      ..limit(1);
    return q.watchSingleOrNull();
  }

  /// All personal records, most recent first (F4 history).
  Stream<List<PersonalRecord>> watchAllPrs() {
    final q = db.select(db.personalRecords)
      ..orderBy([
        (t) => OrderingTerm(expression: t.achievedAt, mode: OrderingMode.desc)
      ]);
    return q.watch();
  }

  Future<void> deleteSetLog(int id) async {
    await (db.delete(db.setLogs)..where((t) => t.id.equals(id))).go();
  }

  /// The best previous set for an exercise (heaviest weight, then most reps),
  /// excluding the current session. Drives the "🎯 beat this" target (F2).
  /// Until PRs are tracked (M2), this is the target.
  Future<SetLog?> bestPreviousSet(
    String exerciseName, {
    required int excludeSessionId,
  }) async {
    final q = db.select(db.setLogs)
      ..where((t) =>
          t.exerciseName.equals(exerciseName) &
          t.sessionId.equals(excludeSessionId).not())
      ..orderBy([
        (t) => OrderingTerm(expression: t.weightKg, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.reps, mode: OrderingMode.desc),
      ])
      ..limit(1);
    return q.getSingleOrNull();
  }
}
