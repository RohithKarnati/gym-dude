import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Manual, user-driven backup & restore (MVP-2). Complements Android Auto
/// Backup by being cross-device-portable, user-triggered, and — unlike Auto
/// Backup — **including progress/PR photos**.
///
/// A backup is a plain `.zip`: the drift database (`gym_dude.sqlite`) at the
/// root plus every image under `photos/`.
///
/// Restore does NOT replace the open database in place — closing the live
/// connection (opened on a background isolate with active stream queries) can
/// hang. Instead it writes the incoming database to a staging file and lets
/// [applyPendingImport] swap it in on the next launch, before the DB opens.
class BackupService {
  BackupService._();

  static const String dbName = 'gym_dude.sqlite';
  static const String _importName = '$dbName.import'; // staging file

  static bool _isImage(String path) {
    final e = path.toLowerCase();
    return e.endsWith('.png') ||
        e.endsWith('.jpg') ||
        e.endsWith('.jpeg') ||
        e.endsWith('.webp');
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// Build a backup zip in the temp dir and return it.
  static Future<File> createBackupZip() async {
    final docs = await getApplicationDocumentsDirectory();
    final tmp = await getTemporaryDirectory();
    final now = DateTime.now();
    final stamp = '${now.year}${_two(now.month)}${_two(now.day)}'
        '-${_two(now.hour)}${_two(now.minute)}';
    final out = File(p.join(tmp.path, 'gymdude-backup-$stamp.zip'));
    if (out.existsSync()) out.deleteSync();

    final encoder = ZipFileEncoder();
    encoder.create(out.path);
    try {
      final dbFile = File(p.join(docs.path, dbName));
      if (dbFile.existsSync()) encoder.addFileSync(dbFile, dbName);
      for (final f in docs.listSync()) {
        if (f is File && _isImage(f.path)) {
          encoder.addFileSync(f, 'photos/${p.basename(f.path)}');
        }
      }
    } finally {
      encoder.closeSync();
    }
    return out;
  }

  /// Export: build the zip and hand it to the OS share sheet.
  static Future<void> exportAndShare() async {
    final zip = await createBackupZip();
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(zip.path)],
        subject: 'Gym Dude backup',
        text: 'Gym Dude backup (database + photos).',
      ),
    );
  }

  /// Stage a restore from a backup zip: validate it, write the incoming
  /// database to a staging file, and restore photos. The database swap happens
  /// on the next launch via [applyPendingImport]; the caller must prompt a
  /// restart. The live database is left untouched (and running).
  static Future<void> stageRestoreFromZip(File zip) async {
    final bytes = await zip.readAsBytes();
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      throw const FormatException("That file isn't a valid .zip backup.");
    }

    final dbEntry = archive.files.firstWhere(
      (e) => e.isFile && p.basename(e.name) == dbName,
      orElse: () => throw const FormatException(
          "That zip isn't a Gym Dude backup (no $dbName inside)."),
    );

    final docs = await getApplicationDocumentsDirectory();
    // Write the DB to the staging file (swapped in on next launch).
    await File(p.join(docs.path, _importName))
        .writeAsBytes(dbEntry.content, flush: true);
    // Photos aren't locked — restore them right away.
    for (final entry in archive.files) {
      if (!entry.isFile) continue;
      final base = p.basename(entry.name);
      if (p.split(entry.name).contains('photos') && _isImage(base)) {
        await File(p.join(docs.path, base))
            .writeAsBytes(entry.content, flush: true);
      }
    }
  }

  /// If a staged import is present in [docsPath], swap it in as the live
  /// database. Called from the DB connection opener, so it runs before any
  /// connection is established. A no-op when there's nothing staged.
  static void applyPendingImport(String docsPath) {
    final staged = File(p.join(docsPath, _importName));
    if (!staged.existsSync()) return;
    final db = File(p.join(docsPath, dbName));
    // Drop any stale journal/WAL side files so they can't corrupt the new DB.
    for (final ext in const ['-journal', '-wal', '-shm']) {
      final side = File('${db.path}$ext');
      if (side.existsSync()) side.deleteSync();
    }
    if (db.existsSync()) db.deleteSync();
    staged.renameSync(db.path);
  }
}
