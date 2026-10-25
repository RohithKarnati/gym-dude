import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_dude/data/database.dart';
import 'package:gym_dude/data/routine_dao.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

/// The schema exactly as it stood at v5 (before the v6 routine redesign and the
/// v7 cardio/hydration work). Dates are stored as integers, matching drift's
/// default DateTime mapping.
const _v5Ddl = '''
CREATE TABLE workout_days (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, weekday INTEGER NOT NULL, title TEXT NOT NULL, usual_time TEXT, is_rest_day INTEGER NOT NULL DEFAULT 0);
CREATE TABLE planned_exercises (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, workout_day_id INTEGER NOT NULL, name TEXT NOT NULL, category TEXT NOT NULL DEFAULT 'Other', target_sets INTEGER NOT NULL DEFAULT 3, target_weight_kg REAL, order_index INTEGER NOT NULL DEFAULT 0);
CREATE TABLE workout_sessions (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, workout_day_id INTEGER NOT NULL, date INTEGER NOT NULL, notes TEXT);
CREATE TABLE set_logs (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, session_id INTEGER NOT NULL, exercise_name TEXT NOT NULL, set_number INTEGER NOT NULL, weight_kg REAL NOT NULL, reps INTEGER NOT NULL, rpe REAL, is_pr INTEGER NOT NULL DEFAULT 0);
CREATE TABLE personal_records (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, exercise_name TEXT NOT NULL, category TEXT NOT NULL DEFAULT 'Other', weight_kg REAL NOT NULL, reps INTEGER NOT NULL, achieved_at INTEGER NOT NULL, photo_path TEXT);
CREATE TABLE routine_items (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, label TEXT NOT NULL, category TEXT NOT NULL, default_time TEXT, order_index INTEGER NOT NULL DEFAULT 0, is_active INTEGER NOT NULL DEFAULT 1);
CREATE TABLE routine_checks (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, routine_item_id INTEGER NOT NULL, date INTEGER NOT NULL, is_done INTEGER NOT NULL DEFAULT 0, done_at INTEGER);
CREATE TABLE meal_prep_tasks (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, label TEXT NOT NULL, weekday INTEGER NOT NULL, reminder_time TEXT, is_active INTEGER NOT NULL DEFAULT 1);
CREATE TABLE meal_prep_checks (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, meal_prep_task_id INTEGER NOT NULL, week_start INTEGER NOT NULL, is_done INTEGER NOT NULL DEFAULT 0);
CREATE TABLE body_logs (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, date INTEGER NOT NULL, weight_kg REAL NOT NULL, photo_path TEXT, note TEXT);
CREATE TABLE app_settings (id INTEGER NOT NULL DEFAULT 1 PRIMARY KEY, notify_day_before INTEGER NOT NULL DEFAULT 0, notify_bedtime INTEGER NOT NULL DEFAULT 0, notify_morning INTEGER NOT NULL DEFAULT 0, bedtime_target TEXT, weight_unit TEXT NOT NULL DEFAULT 'kg', theme_mode TEXT NOT NULL DEFAULT 'system', has_seen_tour INTEGER NOT NULL DEFAULT 0);
CREATE TABLE categories (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL UNIQUE, order_index INTEGER NOT NULL DEFAULT 0);
CREATE TABLE shopping_items (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, label TEXT NOT NULL, order_index INTEGER NOT NULL DEFAULT 0, is_bought INTEGER NOT NULL DEFAULT 0);
''';

void main() {
  test('v5 → v9 upgrade preserves data, reshapes routine, adds new columns',
      () async {
    final dir = await Directory.systemTemp.createTemp('gymdude_mig');
    final file = File(p.join(dir.path, 'gym_dude.sqlite'));

    // --- 1. Hand-build a populated v5 database. ---
    final raw = sqlite3.open(file.path);
    raw.execute(_v5Ddl);
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    raw.execute(
        "INSERT INTO workout_days (weekday, title) VALUES (1, 'Chest')");
    raw.execute(
        "INSERT INTO planned_exercises (workout_day_id, name, category, target_sets, target_weight_kg) "
        "VALUES (1, 'Bench Press', 'Chest', 3, 40.0)");
    raw.execute(
        "INSERT INTO workout_sessions (workout_day_id, date) VALUES (1, $now)");
    raw.execute(
        "INSERT INTO set_logs (session_id, exercise_name, set_number, weight_kg, reps, is_pr) "
        "VALUES (1, 'Bench Press', 1, 40.0, 10, 1)");
    raw.execute(
        "INSERT INTO personal_records (exercise_name, category, weight_kg, reps, achieved_at) "
        "VALUES ('Bench Press', 'Chest', 40.0, 10, $now)");
    raw.execute(
        "INSERT INTO routine_items (label, category, default_time, order_index, is_active) "
        "VALUES ('Creatine', 'supplement', '09:00', 0, 1)");
    raw.execute(
        "INSERT INTO routine_checks (routine_item_id, date, is_done) VALUES (1, $now, 1)");
    raw.execute(
        "INSERT INTO meal_prep_tasks (label, weekday, reminder_time, is_active) "
        "VALUES ('Chop veggies', 1, '18:00', 1)");
    raw.execute("INSERT INTO shopping_items (label) VALUES ('Eggs')");
    raw.execute("INSERT INTO categories (name) VALUES ('Forearms')");
    raw.execute(
        "INSERT INTO app_settings (id, theme_mode, has_seen_tour) VALUES (1, 'dark', 1)");
    raw.execute('PRAGMA user_version = 5');
    raw.close();

    // --- 2. Open with the current code → runs onUpgrade 5 → 6 → 7 → 8 → 9. ---
    final db = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });

    // --- 3. Assert. ---
    // Strength data preserved; new v7 columns defaulted to null.
    final exercises = await db.select(db.plannedExercises).get();
    expect(exercises, hasLength(1));
    expect(exercises.single.name, 'Bench Press');
    expect(exercises.single.cardioMetric, isNull);
    // v9: PR tracking defaults on, so existing exercises keep firing PRs.
    expect(exercises.single.trackPr, isTrue);

    final sessions = await db.select(db.workoutSessions).get();
    expect(sessions.single.completedAt, isNull);

    final setLogs = await db.select(db.setLogs).get();
    expect(setLogs.single.distanceKm, isNull);
    expect(setLogs.single.durationSec, isNull);

    final prs = await db.select(db.personalRecords).get();
    expect(prs.single.weightKg, 40.0);
    expect(prs.single.metric, isNull);

    // Routine redesign (v6): Daily, Shop, Meal prep lists created.
    final lists = await RoutineDao(db).getLists();
    final listNames = lists.map((l) => l.name).toSet();
    expect(listNames, containsAll(<String>{'Daily', 'Shop', 'Meal prep'}));

    final dailyId = lists.firstWhere((l) => l.name == 'Daily').id;
    final shopId = lists.firstWhere((l) => l.name == 'Shop').id;
    final mealPrepId = lists.firstWhere((l) => l.name == 'Meal prep').id;

    final items = await db.select(db.routineItems).get();
    final creatine = items.firstWhere((i) => i.label == 'Creatine');
    expect(creatine.listId, dailyId);
    expect(creatine.daysMask, 127); // reassigned to "every day"

    // Meal-prep task folded into a routine item on Monday only (bit 0 = 1).
    final chop = items.firstWhere((i) => i.label == 'Chop veggies');
    expect(chop.listId, mealPrepId);
    expect(chop.daysMask, 1);
    expect(chop.defaultTime, '18:00');

    final shopping = await db.select(db.shoppingItems).get();
    expect(shopping.single.listId, shopId);

    // Settings carried over; new hydration columns got their defaults.
    final settings = await db.select(db.appSettings).getSingle();
    expect(settings.themeMode, 'dark');
    expect(settings.hasSeenTour, true);
    expect(settings.hydrationEnabled, false);
    expect(settings.hydrationGoalMl, 3000);
    expect(settings.hydrationIntervalMin, 120);
    expect(settings.hydrationStart, '08:00');

    // Custom category survived.
    final cats = await db.select(db.categories).get();
    expect(cats.map((c) => c.name), contains('Forearms'));

    // v7 hydration table exists and is empty.
    final hydration = await db.select(db.hydrationLogs).get();
    expect(hydration, isEmpty);

    // v8: routine items gained nullable hydration config (null for old rows).
    expect(creatine.hydrationGoalMl, isNull);
    expect(creatine.hydrationIntervalMin, isNull);
  });
}
