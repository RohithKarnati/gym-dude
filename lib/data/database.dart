import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test / in-memory constructor.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
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
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'gym_dude.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
