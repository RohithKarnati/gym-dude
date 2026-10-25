import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/notification_service.dart';
import 'routine_providers.dart';
import 'settings_providers.dart';
import 'workout_providers.dart';

/// Reads current settings + plan + routine, and (re)schedules all local
/// notifications (global reminders + per-item routine/meal-prep reminders).
Future<void> applyNotificationSchedule(WidgetRef ref) async {
  final settings = await ref.read(settingsDaoProvider).ensureSettings();
  final days = ref.read(allDaysProvider).value ??
      await ref.read(workoutDaoProvider).watchAllDays().first;
  final routineItems = await ref.read(routineDaoProvider).getActiveItems();
  await NotificationService.instance.reschedule(
    settings: settings,
    days: days,
    routineItems: routineItems,
  );
}
