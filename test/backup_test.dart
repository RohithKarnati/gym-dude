import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gym_dude/services/backup_service.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory docs;

  setUp(() async {
    docs = await Directory.systemTemp.createTemp('gymdude_backup');
  });
  tearDown(() async {
    if (await docs.exists()) await docs.delete(recursive: true);
  });

  File dbFile() => File(p.join(docs.path, BackupService.dbName));
  File stagedFile() => File(p.join(docs.path, '${BackupService.dbName}.import'));

  test('applyPendingImport swaps a staged DB in and clears side files', () {
    dbFile().writeAsStringSync('OLD');
    stagedFile().writeAsStringSync('RESTORED');
    // Stale journal/WAL that must not survive the swap.
    File('${dbFile().path}-journal').writeAsStringSync('x');
    File('${dbFile().path}-wal').writeAsStringSync('x');

    BackupService.applyPendingImport(docs.path);

    expect(dbFile().readAsStringSync(), 'RESTORED');
    expect(stagedFile().existsSync(), isFalse, reason: 'staging consumed');
    expect(File('${dbFile().path}-journal').existsSync(), isFalse);
    expect(File('${dbFile().path}-wal').existsSync(), isFalse);
  });

  test('applyPendingImport is a no-op without a staged file', () {
    dbFile().writeAsStringSync('LIVE');
    BackupService.applyPendingImport(docs.path);
    expect(dbFile().readAsStringSync(), 'LIVE');
  });
}
