import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../services/backup_service.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    WorkoutDays,
    PlannedExercises,
    WorkoutSessions,
    SetLogs,
    PersonalRecords,
    RoutineItems,
    RoutineChecks,
    MealPrepTasks,
    MealPrepChecks,
    BodyLogs,
    AppSettings,
    Categories,
    ShoppingItems,
    RoutineLists,
    HydrationLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test / in-memory constructor.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Seed the default lists for a fresh install.
          await customStatement(
              "INSERT INTO routine_lists (name, kind, order_index, is_active) "
              "VALUES ('Daily', 'checklist', 0, 1), ('Shop', 'shopping', 1, 1)");
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Added in v2: user-selectable theme mode.
            await m.addColumn(appSettings, appSettings.themeMode);
          }
          if (from < 3) {
            // Added in v3: first-run tour completion flag.
            await m.addColumn(appSettings, appSettings.hasSeenTour);
          }
          if (from < 4) {
            // Added in v4: exercise category + target weight, and PR category.
            await m.addColumn(plannedExercises, plannedExercises.category);
            await m.addColumn(
                plannedExercises, plannedExercises.targetWeightKg);
            await m.addColumn(personalRecords, personalRecords.category);
          }
          if (from < 5) {
            // Added in v5: custom categories, shopping list, meal-prep reminders.
            await m.createTable(categories);
            await m.createTable(shoppingItems);
            await m.addColumn(mealPrepTasks, mealPrepTasks.reminderTime);
          }
          if (from < 6) {
            // v6: unified routine model — user-defined lists (tabs) + per-task
            // day-of-week recurrence. Meal prep folds into checklist tasks.
            await m.createTable(routineLists);
            await m.addColumn(routineItems, routineItems.listId);
            await m.addColumn(routineItems, routineItems.daysMask);
            await m.addColumn(shoppingItems, shoppingItems.listId);

            // Create the core lists and reassign existing data first, so this
            // critical step can't be skipped by a later failure.
            await customStatement(
                "INSERT INTO routine_lists (name, kind, order_index, is_active) "
                "VALUES ('Daily', 'checklist', 0, 1), ('Shop', 'shopping', 1, 1)");
            await customStatement(
                "UPDATE routine_items SET list_id = "
                "(SELECT id FROM routine_lists WHERE name = 'Daily'), "
                "days_mask = 127 WHERE list_id IS NULL");
            await customStatement(
                "UPDATE shopping_items SET list_id = "
                "(SELECT id FROM routine_lists WHERE name = 'Shop') "
                "WHERE list_id IS NULL");

            // Fold active meal-prep tasks into a Meal prep checklist list.
            // (meal_prep_tasks has no order_index column — use a literal 0.)
            final mp = await customSelect(
                    'SELECT COUNT(*) AS c FROM meal_prep_tasks WHERE is_active = 1')
                .getSingle();
            if ((mp.data['c'] as int) > 0) {
              await customStatement(
                  "INSERT INTO routine_lists (name, kind, order_index, is_active) "
                  "VALUES ('Meal prep', 'checklist', 2, 1)");
              await customStatement(
                  "INSERT INTO routine_items "
                  "(label, category, default_time, days_mask, order_index, is_active, list_id) "
                  "SELECT label, 'other', reminder_time, (1 << (weekday - 1)), "
                  "0, 1, "
                  "(SELECT id FROM routine_lists WHERE name = 'Meal prep') "
                  "FROM meal_prep_tasks WHERE is_active = 1");
            }
          }
          if (from < 7) {
            // v7: cardio metrics, finish-workout timestamp, hydration.
            await m.addColumn(plannedExercises, plannedExercises.cardioMetric);
            await m.addColumn(workoutSessions, workoutSessions.completedAt);
            await m.addColumn(setLogs, setLogs.distanceKm);
            await m.addColumn(setLogs, setLogs.durationSec);
            await m.addColumn(personalRecords, personalRecords.metric);
            await m.addColumn(personalRecords, personalRecords.distanceKm);
            await m.addColumn(personalRecords, personalRecords.durationSec);
            await m.addColumn(appSettings, appSettings.hydrationEnabled);
            await m.addColumn(appSettings, appSettings.hydrationGoalMl);
            await m.addColumn(appSettings, appSettings.hydrationIntervalMin);
            await m.addColumn(appSettings, appSettings.hydrationStart);
            await m.addColumn(appSettings, appSettings.hydrationEnd);
            await m.createTable(hydrationLogs);
          }
          if (from < 8) {
            // v8: hydration moves onto the routine item (category == 'hydration')
            // — a per-item goal + reminder frequency — and each drink links to
            // the item it belongs to. The v7 app_settings hydration columns are
            // now dormant.
            await m.addColumn(routineItems, routineItems.hydrationGoalMl);
            await m.addColumn(
                routineItems, routineItems.hydrationIntervalMin);
            // hydration_logs.item_id: only add it when coming *from* v7 — for
            // any earlier version the v7 step's createTable(hydrationLogs) above
            // already builds the table with item_id (it uses the current schema).
            if (from == 7) {
              await m.addColumn(hydrationLogs, hydrationLogs.itemId);
            }
          }
          if (from < 9) {
            // v9: per-exercise "track as PR" flag (defaults true, so existing
            // exercises keep firing PRs exactly as before).
            await m.addColumn(plannedExercises, plannedExercises.trackPr);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    // Apply a pending manual-backup restore before opening the connection.
    BackupService.applyPendingImport(dbFolder.path);
    final file = File(p.join(dbFolder.path, 'gym_dude.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
