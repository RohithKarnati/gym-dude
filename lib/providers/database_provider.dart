import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';

/// App-wide singleton handle to the on-device drift database.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
