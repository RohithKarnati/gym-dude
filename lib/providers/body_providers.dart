import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/body_dao.dart';
import '../data/database.dart';
import 'database_provider.dart';

final bodyDaoProvider = Provider<BodyDao>((ref) {
  return BodyDao(ref.watch(databaseProvider));
});

/// Bodyweight logs, oldest first (F7).
final bodyLogsProvider = StreamProvider<List<BodyLog>>((ref) {
  return ref.watch(bodyDaoProvider).watchLogs();
});
