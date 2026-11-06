import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_dude/data/database.dart';
import 'package:gym_dude/data/workout_dao.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late WorkoutDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = WorkoutDao(db);
  });
  tearDown(() => db.close());

  Future<int> newSession() async {
    final dayId = await db.into(db.workoutDays).insert(
        WorkoutDaysCompanion.insert(weekday: 1, title: 'Chest'));
    return db.into(db.workoutSessions).insert(
        WorkoutSessionsCompanion.insert(
            workoutDayId: dayId, date: DateTime.now()));
  }

  test('trackPr: true (default) detects and records a PR', () async {
    final s = await newSession();
    await dao.addSetLog(
        sessionId: s, exerciseName: 'Bench', weightKg: 60, reps: 5); // seed
    final pr = await dao.addSetLog(
        sessionId: s, exerciseName: 'Bench', weightKg: 70, reps: 5); // beat

    expect(pr, isNotNull, reason: 'heavier top set should celebrate a PR');
    expect(await dao.getPr('Bench'), isNotNull);
    expect((await dao.getPr('Bench'))!.weightKg, 70);
  });

  test('trackPr: false never celebrates and never writes a PR', () async {
    final s = await newSession();
    final first = await dao.addSetLog(
        sessionId: s,
        exerciseName: 'Warmup',
        weightKg: 60,
        reps: 5,
        trackPr: false);
    final heavier = await dao.addSetLog(
        sessionId: s,
        exerciseName: 'Warmup',
        weightKg: 999,
        reps: 5,
        trackPr: false);

    expect(first, isNull);
    expect(heavier, isNull, reason: 'no celebration when PR tracking is off');
    expect(await dao.getPr('Warmup'), isNull,
        reason: 'no personal record row should be created');

    // The sets themselves are still logged, just never flagged as a PR.
    final sets = await db.select(db.setLogs).get();
    expect(sets, hasLength(2));
    expect(sets.every((l) => l.isPr == false), isTrue);
  });
}
