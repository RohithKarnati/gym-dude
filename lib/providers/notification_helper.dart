import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/notification_service.dart';
import 'settings_providers.dart';
import 'workout_providers.dart';

/// Reads current settings + plan and (re)schedules all local notifications.
Future<void> applyNotificationSchedule(WidgetRef ref) async {
  final settings = await ref.read(settingsDaoProvider).ensureSettings();
  final days = ref.read(allDaysProvider).value ??
      await ref.read(workoutDaoProvider).watchAllDays().first;
  await NotificationService.instance.reschedule(settings: settings, days: days);
}
