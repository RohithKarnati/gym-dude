import 'package:drift/drift.dart';

import 'database.dart';

/// Access to the single-row [AppSettings] (id is always 1).
class SettingsDao {
  SettingsDao(this.db);

  final AppDatabase db;

  static const int _rowId = 1;

  Stream<AppSetting?> watchSettings() {
    final q = db.select(db.appSettings)..where((t) => t.id.equals(_rowId));
    return q.watchSingleOrNull();
  }

  Future<AppSetting> _ensureRow() async {
    final q = db.select(db.appSettings)..where((t) => t.id.equals(_rowId));
    final existing = await q.getSingleOrNull();
    if (existing != null) return existing;
    await db.into(db.appSettings).insert(
          AppSettingsCompanion.insert(id: const Value(_rowId)),
        );
    return (db.select(db.appSettings)..where((t) => t.id.equals(_rowId)))
        .getSingle();
  }

  /// Persist the theme mode: 'system' | 'light' | 'dark'.
  Future<void> setThemeMode(String mode) async {
    await _ensureRow();
    await (db.update(db.appSettings)..where((t) => t.id.equals(_rowId)))
        .write(AppSettingsCompanion(themeMode: Value(mode)));
  }

  Future<void> setNotifyDayBefore(bool v) async {
    await _ensureRow();
    await (db.update(db.appSettings)..where((t) => t.id.equals(_rowId)))
        .write(AppSettingsCompanion(notifyDayBefore: Value(v)));
  }

  Future<void> setNotifyBedtime(bool v) async {
    await _ensureRow();
    await (db.update(db.appSettings)..where((t) => t.id.equals(_rowId)))
        .write(AppSettingsCompanion(notifyBedtime: Value(v)));
  }

  Future<void> setNotifyMorning(bool v) async {
    await _ensureRow();
    await (db.update(db.appSettings)..where((t) => t.id.equals(_rowId)))
        .write(AppSettingsCompanion(notifyMorning: Value(v)));
  }

  Future<void> setBedtimeTarget(String? hhmm) async {
    await _ensureRow();
    await (db.update(db.appSettings)..where((t) => t.id.equals(_rowId)))
        .write(AppSettingsCompanion(bedtimeTarget: Value(hhmm)));
  }

  Future<void> setHasSeenTour(bool v) async {
    await _ensureRow();
    await (db.update(db.appSettings)..where((t) => t.id.equals(_rowId)))
        .write(AppSettingsCompanion(hasSeenTour: Value(v)));
  }

  Future<AppSetting> ensureSettings() => _ensureRow();
}
