import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/database.dart';
import '../../providers/category_providers.dart';
import '../../providers/workout_providers.dart';
import '../../utils/cardio.dart';
import 'pr_card_screen.dart';

/// PR history (F4): per-exercise best, grouped by muscle group, each with a
/// shareable image card.
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
          // Group by category, in the canonical order (presets + custom);
          // heaviest first within each group.
          final byCategory = <String, List<PersonalRecord>>{};
          for (final pr in prs) {
            final cat = pr.category.isEmpty ? 'Other' : pr.category;
            byCategory.putIfAbsent(cat, () => []).add(pr);
          }
          final order = ref.watch(allCategoriesProvider);
          final sections = <String>[
            for (final c in order) if (byCategory.containsKey(c)) c,
            for (final c in byCategory.keys) if (!order.contains(c)) c,
          ];

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              for (final category in sections) ...[
                _CategoryHeader(
                  category: category,
                  count: byCategory[category]!.length,
                ),
                for (final pr in (byCategory[category]!
                  ..sort((a, b) => b.weightKg.compareTo(a.weightKg))))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PrTile(pr: pr),
                  ),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.category, required this.count});

  final String category;
  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Row(
        children: [
          Text(
            category,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('$count',
                style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ),
        ],
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
                    '${_prValue(pr)}  ·  '
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

String _prValue(PersonalRecord pr) {
  if (pr.metric == null) return '${_fmt(pr.weightKg)} kg × ${pr.reps}';
  return cardioSummary(
    pr.metric!,
    distanceKm: pr.distanceKm,
    durationSec: pr.durationSec,
    count: pr.reps,
  );
}

String _fmt(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
