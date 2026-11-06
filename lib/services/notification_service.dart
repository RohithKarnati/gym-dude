import 'dart:ui' show DartPluginRegistrant;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/database.dart';
import '../data/hydration_dao.dart';
import '../data/routine_dao.dart';

/// Background-isolate handler for notification action buttons (lock screen /
/// app-killed). Runs in its own isolate, so it opens a short-lived database.
@pragma('vm:entry-point')
Future<void> notificationActionBackground(NotificationResponse response) async {
  await NotificationService.handleAction(response, db: null);
}

/// Local-only notifications (F9): day-before workout, bedtime nudge, morning
/// summary, per-task routine reminders (with a "Mark done" action), and smart
/// hydration reminders (with +100/+300/+500 ml actions).
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _inited = false;

  /// The app's live database, set on startup so foreground action taps update
  /// the running UI's streams immediately. Null in the background isolate.
  AppDatabase? _appDb;
  void attachDatabase(AppDatabase db) => _appDb = db;

  // Notification ids.
  static const int _morningBase = 10; // + weekday (10..17), one per weekday
  static const int _idBedtime = 2;
  static const int _idPreview = 999;
  static const int _dayBeforeBase = 100; // + weekday
  static const int _routineBase = 100000; // + itemId*8 + weekday
  static const int _hydrationBase = 200000; // + slot index

  // Action ids.
  static const String _actRoutineDone = 'routine_done';
  static const String _hydratePrefix = 'hydrate_'; // + ml amount

  Future<void> init() async {
    if (_inited) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Fall back to UTC; scheduling still works, just in UTC.
    }
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      settings: const InitializationSettings(android: android),
      onDidReceiveNotificationResponse: (r) => handleAction(r, db: _appDb),
      onDidReceiveBackgroundNotificationResponse: notificationActionBackground,
    );
    _inited = true;
  }

  Future<bool> requestPermission() async {
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? true;
  }

  /// Apply a tapped action button. [db] is the live app DB when in the
  /// foreground isolate, else null (a fresh one is opened and closed).
  static Future<void> handleAction(
    NotificationResponse response, {
    required AppDatabase? db,
  }) async {
    final actionId = response.actionId;
    if (actionId == null) return; // body tap, not an action button

    final owned = db == null;
    if (owned) {
      // Separate isolate: bring up plugins + open our own connection.
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();
    }
    final database = db ?? AppDatabase();
    try {
      if (actionId == _actRoutineDone) {
        final id = int.tryParse(response.payload?.split(':').last ?? '');
        if (id != null) {
          await RoutineDao(database).setRoutineDone(id, DateTime.now(), true);
        }
      } else if (actionId.startsWith(_hydratePrefix)) {
        final ml = int.tryParse(actionId.substring(_hydratePrefix.length));
        final itemId = int.tryParse(response.payload?.split(':').last ?? '');
        if (ml != null && itemId != null) {
          await HydrationDao(database).addDrink(itemId, ml);
        }
      }
    } finally {
      if (owned) await database.close();
    }
  }

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          'gymdude_reminders',
          'Reminders',
          channelDescription: 'Workout and routine reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

  /// Routine reminder with a "Mark done" action button.
  NotificationDetails get _routineDetails => const NotificationDetails(
        android: AndroidNotificationDetails(
          'gymdude_reminders',
          'Reminders',
          channelDescription: 'Workout and routine reminders',
          importance: Importance.high,
          priority: Priority.high,
          actions: [
            AndroidNotificationAction(
              _actRoutineDone,
              'Mark done',
              showsUserInterface: false,
              cancelNotification: true,
            ),
          ],
        ),
      );

  /// Hydration reminder with +100 / +300 / +500 ml quick-log buttons.
  NotificationDetails get _hydrationDetails => const NotificationDetails(
        android: AndroidNotificationDetails(
          'gymdude_hydration',
          'Hydration',
          channelDescription: 'Water intake reminders',
          importance: Importance.high,
          priority: Priority.high,
          actions: [
            AndroidNotificationAction('${_hydratePrefix}100', '+100 ml',
                showsUserInterface: false, cancelNotification: true),
            AndroidNotificationAction('${_hydratePrefix}300', '+300 ml',
                showsUserInterface: false, cancelNotification: true),
            AndroidNotificationAction('${_hydratePrefix}500', '+500 ml',
                showsUserInterface: false, cancelNotification: true),
          ],
        ),
      );

  /// Immediate notification — used for the settings "Send a preview".
  Future<void> showPreview(String title, String body) async {
    await init();
    await _plugin.show(
      id: _idPreview,
      title: title,
      body: body,
      notificationDetails: _details,
    );
  }

  tz.TZDateTime _nextTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var t = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!t.isAfter(now)) t = t.add(const Duration(days: 1));
    return t;
  }

  tz.TZDateTime _nextWeekday(int weekday, int hour, int minute) {
    var t = _nextTime(hour, minute);
    while (t.weekday != weekday) {
      t = t.add(const Duration(days: 1));
    }
    return t;
  }

  Future<void> _daily(
    int id,
    int hour,
    int minute,
    String title,
    String body, {
    NotificationDetails? details,
    String? payload,
  }) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextTime(hour, minute),
      notificationDetails: details ?? _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  Future<void> _weekly(
    int id,
    int weekday,
    int hour,
    int minute,
    String title,
    String body, {
    NotificationDetails? details,
    String? payload,
  }) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextWeekday(weekday, hour, minute),
      notificationDetails: details ?? _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: payload,
    );
  }

  /// Cancel everything and reschedule from the current settings + plan.
  Future<void> reschedule({
    required AppSetting settings,
    required List<WorkoutDay> days,
    List<RoutineItem> routineItems = const [],
  }) async {
    await init();
    await _plugin.cancelAll();

    for (final item in routineItems) {
      // Hydration items (category 'hydration') fire on a frequency across the
      // active window with +ml actions, instead of a single reminder time.
      if (item.category == 'hydration') {
        if (item.hydrationIntervalMin == null) continue;
        final slots = _hydrationSlots(item.hydrationIntervalMin!);
        final everyDay = item.daysMask == 127;
        for (var i = 0; i < slots.length; i++) {
          final s = slots[i];
          if (everyDay) {
            await _daily(
              _hydrationBase + item.id * 1000 + i,
              s.hour,
              s.minute,
              'Time to hydrate 💧',
              'Log your water — ${item.label}.',
              details: _hydrationDetails,
              payload: 'hydration:${item.id}',
            );
          } else {
            for (var w = 1; w <= 7; w++) {
              if ((item.daysMask & (1 << (w - 1))) == 0) continue;
              await _weekly(
                _hydrationBase + item.id * 1000 + i * 8 + w,
                w,
                s.hour,
                s.minute,
                'Time to hydrate 💧',
                'Log your water — ${item.label}.',
                details: _hydrationDetails,
                payload: 'hydration:${item.id}',
              );
            }
          }
        }
        continue;
      }

      // Per-task reminders: one weekly notification per recurring weekday, each
      // with a "Mark done" action carrying the item id.
      final t = _parseTime(item.defaultTime);
      if (t == null) continue;
      for (var w = 1; w <= 7; w++) {
        if ((item.daysMask & (1 << (w - 1))) == 0) continue;
        await _weekly(
          _routineBase + item.id * 8 + w,
          w,
          t.hour,
          t.minute,
          'Reminder',
          item.label,
          details: _routineDetails,
          payload: 'routine:${item.id}',
        );
      }
    }

    if (settings.notifyMorning) {
      // One weekly notification per weekday so each morning shows that day's
      // actual plan — a single daily schedule would freeze yesterday's text.
      final byWeekday = {for (final d in days) d.weekday: d};
      for (var weekday = 1; weekday <= 7; weekday++) {
        await _weekly(
          _morningBase + weekday,
          weekday,
          7,
          30,
          "Today's plan",
          _morningBodyFor(weekday, byWeekday[weekday]),
        );
      }
    }

    if (settings.notifyBedtime) {
      final t = _parseTime(settings.bedtimeTarget) ??
          const TimeOfDay(hour: 22, minute: 30);
      await _daily(_idBedtime, t.hour, t.minute, 'Wind down 😴',
          'Lights out soon — recovery is where the gains happen.');
    }

    if (settings.notifyDayBefore) {
      for (final d
          in days.where((d) => !d.isRestDay && d.usualTime != null)) {
        final eveningBefore = d.weekday == 1 ? 7 : d.weekday - 1;
        await _weekly(
          _dayBeforeBase + d.weekday,
          eveningBefore,
          20,
          0,
          'Tomorrow: ${d.title}',
          'At ${d.usualTime}. Plan your meals & sleep.',
        );
      }
    }
  }

  /// Reminder times across the fixed active window (08:00–22:00) at [intervalMin],
  /// e.g. every 120 min → 08:00, 10:00, …, 22:00. Capped so a tiny interval
  /// can't schedule hundreds of alarms.
  List<TimeOfDay> _hydrationSlots(int intervalMin) {
    final interval = intervalMin < 30 ? 30 : intervalMin;
    const startM = 8 * 60; // 08:00
    const endM = 22 * 60; // 22:00
    final slots = <TimeOfDay>[];
    for (var m = startM; m <= endM && slots.length < 24; m += interval) {
      slots.add(TimeOfDay(hour: m ~/ 60, minute: m % 60));
    }
    return slots;
  }

  String _morningBodyFor(int weekday, WorkoutDay? day) {
    if (day == null) {
      return 'No workout planned today. Stay on your routine 💪';
    }
    if (day.isRestDay) {
      return 'Rest day. Recover well. Don\'t forget your supps 💊';
    }
    final title = day.title.isEmpty ? 'Workout' : day.title;
    return '$title today${day.usualTime == null ? '' : ' at ${day.usualTime}'}. '
        'Don\'t forget creatine 💧';
  }

  static TimeOfDay? _parseTime(String? hhmm) {
    if (hhmm == null || !hhmm.contains(':')) return null;
    final parts = hhmm.split(':');
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }
}
