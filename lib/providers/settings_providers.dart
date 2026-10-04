import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/settings_dao.dart';
import 'database_provider.dart';

final settingsDaoProvider = Provider<SettingsDao>((ref) {
  return SettingsDao(ref.watch(databaseProvider));
});

/// The app settings row (null until first written).
final settingsProvider = StreamProvider<AppSetting?>((ref) {
  return ref.watch(settingsDaoProvider).watchSettings();
});

/// Current theme mode, defaulting to system until the user picks one.
final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(settingsProvider).value;
  switch (settings?.themeMode) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
});
