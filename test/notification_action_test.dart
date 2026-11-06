import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_dude/data/database.dart';
import 'package:gym_dude/data/hydration_dao.dart';
import 'package:gym_dude/data/routine_dao.dart';
import 'package:gym_dude/services/notification_service.dart';
import 'package:path/path.dart' as p;

NotificationResponse _action(String actionId, String payload) =>
    NotificationResponse(
      notificationResponseType:
          NotificationResponseType.selectedNotificationAction,
      actionId: actionId,
      payload: payload,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------------------------
  // 1. Same-connection (foreground isolate) path: parsing + DAO logic only.
  // ---------------------------------------------------------------------------
  group('handleAction — same connection (foreground path)', () {
    late AppDatabase db;
    late RoutineDao routine;
    late HydrationDao hydration;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      routine = RoutineDao(db);
      hydration = HydrationDao(db);
    });
    tearDown(() => db.close());

    test('"Mark done" marks the routine item done for today', () async {
      final listId = await routine.ensureDefaultList();
      await routine.addItem(
          listId: listId, label: 'Creatine', category: 'supplement');
      final items = await routine.getActiveItems();
      final id = items.single.id;

      await NotificationService.handleAction(
        _action('routine_done', 'routine:$id'),
        db: db,
      );

      final checks = await routine.watchChecksForDay(DateTime.now()).first;
      expect(checks.where((c) => c.routineItemId == id && c.isDone), isNotEmpty,
          reason: 'routine item should be checked done for today');
    });

    test('"+300 ml" logs a hydration drink for the item', () async {
      final listId = await routine.ensureDefaultList();
      await routine.addItem(
        listId: listId,
        label: 'Water',
        category: 'hydration',
        hydrationGoalMl: 3000,
        hydrationIntervalMin: 120,
      );
      final id = (await routine.getActiveItems()).single.id;

      await NotificationService.handleAction(
        _action('hydrate_300', 'hydration:$id'),
        db: db,
      );

      expect(await hydration.getIntakeForDay(id, DateTime.now()), 300);
    });
  });

  // ---------------------------------------------------------------------------
  // 2. Cross-connection path: the background isolate opens its OWN connection to
  //    the same file, writes, and closes; then the app (another connection)
  //    reads. This mirrors what actually happens when a lock-screen action fires
  //    with showsUserInterface:false (always handled in the background isolate).
  // ---------------------------------------------------------------------------
  group('handleAction — cross connection (background isolate → app)', () {
    late Directory dir;
    late File file;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('gymdude_notif');
      file = File(p.join(dir.path, 'gym_dude.sqlite'));
    });
    tearDown(() async {
      if (await dir.exists()) await dir.delete(recursive: true);
    });

    test('routine done written by a separate connection is visible to the app',
        () async {
      // App connection seeds an item.
      final app = AppDatabase.forTesting(NativeDatabase(file));
      final listId = await RoutineDao(app).ensureDefaultList();
      await RoutineDao(app)
          .addItem(listId: listId, label: 'Creatine', category: 'supplement');
      final id = (await RoutineDao(app).getActiveItems()).single.id;

      // Background isolate: its own connection to the same file.
      final bg = AppDatabase.forTesting(NativeDatabase(file));
      await NotificationService.handleAction(
        _action('routine_done', 'routine:$id'),
        db: bg,
      );
      await bg.close();

      // App re-queries (as it does on resume via provider invalidation).
      final checks = await RoutineDao(app).watchChecksForDay(DateTime.now()).first;
      expect(checks.where((c) => c.routineItemId == id && c.isDone), isNotEmpty,
          reason: 'app must see the background-written check');
      await app.close();
    });

    test('hydration drink written by a separate connection is visible to the app',
        () async {
      final app = AppDatabase.forTesting(NativeDatabase(file));
      final listId = await RoutineDao(app).ensureDefaultList();
      await RoutineDao(app).addItem(
        listId: listId,
        label: 'Water',
        category: 'hydration',
        hydrationGoalMl: 3000,
        hydrationIntervalMin: 120,
      );
      final id = (await RoutineDao(app).getActiveItems()).single.id;

      final bg = AppDatabase.forTesting(NativeDatabase(file));
      await NotificationService.handleAction(
        _action('hydrate_500', 'hydration:$id'),
        db: bg,
      );
      await bg.close();

      expect(await HydrationDao(app).getIntakeForDay(id, DateTime.now()), 500);
      await app.close();
    });
  });
}
