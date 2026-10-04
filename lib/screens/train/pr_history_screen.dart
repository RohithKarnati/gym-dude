import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/database.dart';
import '../../providers/workout_providers.dart';
import 'pr_card_screen.dart';

/// PR history (F4): per-exercise best, with a shareable image card.
class PrHistoryScreen extends ConsumerWidget {
  const PrHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prsAsync = ref.watch(allPrsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Personal records')),
      body: prsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (prs) {
          if (prs.isEmpty) {
            return const _PrEmptyState();
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            itemCount: prs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _PrTile(pr: prs[i]),
          );
        },
      ),
    );
  }
}

class _PrTile extends StatelessWidget {
  const _PrTile({required this.pr});

  final PersonalRecord pr;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: scheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('🏆', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pr.exerciseName,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    '${_fmt(pr.weightKg)} kg × ${pr.reps}  ·  '
                    '${DateFormat('d MMM yyyy').format(pr.achievedAt)}',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.ios_share),
              tooltip: 'Share',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PrCardScreen(pr: pr)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrEmptyState extends StatelessWidget {
  const _PrEmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text('No PRs yet',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Beat a logged set to set your first record.',
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

String _fmt(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
