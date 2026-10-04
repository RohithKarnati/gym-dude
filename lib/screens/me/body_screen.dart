import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/database.dart';
import '../../providers/body_providers.dart';

/// Bodyweight + progress photo + trend (F7).
class BodyScreen extends ConsumerWidget {
  const BodyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(bodyLogsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Body')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Log weight'),
      ),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (logs) {
          if (logs.isEmpty) {
            return const _BodyEmptyState();
          }
          final latest = logs.last;
          final first = logs.first;
          final delta = latest.weightKg - first.weightKg;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
            children: [
              _SummaryCard(latest: latest, delta: delta, count: logs.length),
              if (logs.length >= 2) ...[
                const SizedBox(height: 16),
                _TrendChart(logs: logs),
              ],
              const SizedBox(height: 16),
              Text('History',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              for (final log in logs.reversed)
                _BodyLogTile(
                  log: log,
                  onDelete: () => ref.read(bodyDaoProvider).deleteLog(log.id),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard(
      {required this.latest, required this.delta, required this.count});

  final BodyLog latest;
  final double delta;
  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final up = delta > 0;
    final flat = delta.abs() < 0.05;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current',
                    style: TextStyle(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text('${_fmt(latest.weightKg)} kg',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const Spacer(),
            if (!flat)
              Row(
                children: [
                  Icon(up ? Icons.trending_up : Icons.trending_down,
                      color: scheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    '${up ? '+' : ''}${_fmt(delta)} kg',
                    style: TextStyle(
                        color: scheme.primary, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.logs});

  final List<BodyLog> logs;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final spots = <FlSpot>[
      for (var i = 0; i < logs.length; i++)
        FlSpot(i.toDouble(), logs[i].weightKg),
    ];
    final weights = logs.map((e) => e.weightKg).toList();
    final minW = weights.reduce((a, b) => a < b ? a : b);
    final maxW = weights.reduce((a, b) => a > b ? a : b);
    final pad = ((maxW - minW) * 0.2).clamp(1.0, 50.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 16, 12),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minY: minW - pad,
              maxY: maxW + pad,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: scheme.surfaceContainerHighest, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (v, meta) => Text(
                      v.toStringAsFixed(0),
                      style: TextStyle(
                          color: scheme.onSurfaceVariant, fontSize: 11),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: (logs.length / 4).ceilToDouble().clamp(1, 999),
                    getTitlesWidget: (v, meta) {
                      final i = v.toInt();
                      if (i < 0 || i >= logs.length) return const SizedBox();
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          DateFormat('d/M').format(logs[i].date),
                          style: TextStyle(
                              color: scheme.onSurfaceVariant, fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: scheme.primary,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (s, _, _, _) => FlDotCirclePainter(
                      radius: 3,
                      color: scheme.primary,
                      strokeWidth: 0,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: scheme.primary.withValues(alpha: 0.12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BodyLogTile extends StatelessWidget {
  const _BodyLogTile({required this.log, required this.onDelete});

  final BodyLog log;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey('body_${log.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline, color: scheme.onErrorContainer),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: log.photoPath != null && File(log.photoPath!).existsSync()
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(File(log.photoPath!),
                      width: 48, height: 48, fit: BoxFit.cover),
                )
              : CircleAvatar(
                  backgroundColor: scheme.surfaceContainerHighest,
                  child: Icon(Icons.monitor_weight_outlined,
                      color: scheme.onSurfaceVariant),
                ),
          title: Text('${_fmt(log.weightKg)} kg',
              style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(DateFormat('EEE, d MMM yyyy').format(log.date) +
              (log.note == null ? '' : ' · ${log.note}')),
        ),
      ),
    );
  }
}

class _BodyEmptyState extends StatelessWidget {
  const _BodyEmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.monitor_weight_outlined,
                size: 56, color: scheme.primary),
            const SizedBox(height: 16),
            Text('Track your bodyweight',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Log weekly to see your trend and progress photos.',
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
  final result = await showDialog<_BodyEntry>(
    context: context,
    builder: (_) => const _AddBodyDialog(),
  );
  if (result == null) return;
  await ref.read(bodyDaoProvider).addLog(
        date: DateTime.now(),
        weightKg: result.weightKg,
        photoPath: result.photoPath,
        note: result.note,
      );
}

class _BodyEntry {
  _BodyEntry({required this.weightKg, this.photoPath, this.note});
  final double weightKg;
  final String? photoPath;
  final String? note;
}

class _AddBodyDialog extends StatefulWidget {
  const _AddBodyDialog();

  @override
  State<_AddBodyDialog> createState() => _AddBodyDialogState();
}

class _AddBodyDialogState extends State<_AddBodyDialog> {
  final _weightCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String? _photoPath;
  bool _picking = false;

  @override
  void dispose() {
    _weightCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    setState(() => _picking = true);
    try {
      final picker = ImagePicker();
      final picked =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked == null) return;
      final dir = await getApplicationDocumentsDirectory();
      final photosDir = Directory(p.join(dir.path, 'progress_photos'));
      if (!photosDir.existsSync()) photosDir.createSync(recursive: true);
      final dest = p.join(photosDir.path,
          'body_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}');
      await File(picked.path).copy(dest);
      if (mounted) setState(() => _photoPath = dest);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log weight'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _weightCtrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              hintText: 'e.g. 78.5',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Note (optional)',
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _picking ? null : _pickPhoto,
            icon: _picking
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(_photoPath == null
                    ? Icons.add_a_photo_outlined
                    : Icons.check_circle_outline),
            label: Text(_photoPath == null ? 'Add progress photo' : 'Photo added'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final w = double.tryParse(_weightCtrl.text.trim());
            if (w == null || w <= 0) return;
            Navigator.pop(
              context,
              _BodyEntry(
                weightKg: w,
                photoPath: _photoPath,
                note: _noteCtrl.text.trim().isEmpty
                    ? null
                    : _noteCtrl.text.trim(),
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

String _fmt(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
