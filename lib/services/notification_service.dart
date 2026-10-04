import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/database.dart';

/// Local-only notifications (F9): day-before workout, bedtime nudge, morning
/// summary. All opt-in; scheduling is inexact to avoid exact-alarm permission.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _inited = false;

  // Notification ids.
  static const int _morningBase = 10; // + weekday (10..17), one per weekday
  static const int _idBedtime = 2;
  static const int _idPreview = 999;
  static const int _dayBeforeBase = 100; // + weekday

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
        settings: const InitializationSettings(android: android));
    _inited = true;
  }

  Future<bool> requestPermission() async {
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? true;
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
      int id, int hour, int minute, String title, String body) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextTime(hour, minute),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _weekly(int id, int weekday, int hour, int minute, String title,
      String body) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextWeekday(weekday, hour, minute),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// Cancel everything and reschedule from the current settings + plan.
  Future<void> reschedule({
    required AppSetting settings,
    required List<WorkoutDay> days,
  }) async {
    await init();
    await _plugin.cancelAll();

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
