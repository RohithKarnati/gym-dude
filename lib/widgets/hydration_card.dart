import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../providers/hydration_providers.dart';
import '../utils/recurrence.dart';

/// Default active window for hydration reminders (kept in sync with
/// NotificationService). Reminders fire between these times.
const int kHydrationStartMin = 8 * 60; // 08:00
const int kHydrationEndMin = 22 * 60; // 22:00

/// Preset quick-log volumes (also the three notification action buttons).
const List<int> kHydrationPresets = [100, 300, 500];

/// Home-screen section: a tracker per hydration routine item scheduled today.
/// Renders nothing when there are none.
class HydrationCard extends ConsumerWidget {
  const HydrationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref
        .watch(hydrationItemsProvider)
        .where((i) => isScheduledToday(i.daysMask))
        .toList();
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          HydrationTracker(item: items[i]),
        ],
      ],
    );
  }
}

/// A single hydration item's tracker: ring, intake vs. goal, a live "per
/// reminder" hint, and +ml quick-log buttons. Optionally shows edit/delete.
class HydrationTracker extends ConsumerWidget {
  const HydrationTracker({
    super.key,
    required this.item,
    this.scheduledToday = true,
    this.onEdit,
  });

  final RoutineItem item;
  final bool scheduledToday;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final goal = item.hydrationGoalMl ?? 0;
    final intake = ref.watch(hydrationIntakeTodayProvider(item.id));
    final logs = ref.watch(hydrationLogsTodayProvider(item.id)).value ?? const [];
    final frac = goal == 0 ? 0.0 : (intake / goal).clamp(0.0, 1.0);
    final remaining = (goal - intake).clamp(0, goal);
    final dao = ref.read(hydrationDaoProvider);
    final hint = _hint(remaining);

    return Opacity(
      opacity: scheduledToday ? 1 : 0.55,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 52,
                          height: 52,
                          child: CircularProgressIndicator(
                            value: frac,
                            strokeWidth: 6,
                            backgroundColor: scheme.surfaceContainerHighest,
                          ),
                        ),
                        const Text('💧', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(item.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                            ),
                            if (logs.isNotEmpty)
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'Undo last',
                                icon: Icon(Icons.undo,
                                    size: 18, color: scheme.onSurfaceVariant),
                                onPressed: () => dao.deleteLog(logs.first.id),
                              ),
                            if (onEdit != null)
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.only(left: 8),
                                constraints: const BoxConstraints(),
                                tooltip: 'Edit',
                                icon: Icon(Icons.edit_outlined,
                                    size: 18, color: scheme.onSurfaceVariant),
                                onPressed: onEdit,
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('$intake / $goal ml',
                            style: TextStyle(color: scheme.onSurfaceVariant)),
                        if (hint != null)
                          Text(hint,
                              style: TextStyle(
                                  color: scheme.onSurfaceVariant, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  for (var i = 0; i < kHydrationPresets.length; i++) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: scheduledToday
                            ? () => dao.addDrink(item.id, kHydrationPresets[i])
                            : null,
                        child: Text('+${kHydrationPresets[i]}'),
                      ),
                    ),
                    if (i != kHydrationPresets.length - 1)
                      const SizedBox(width: 8),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// "~X ml per reminder to hit your goal" over the reminders still to come.
  String? _hint(int remaining) {
    if (remaining <= 0) return 'Goal met — nice! 🎉';
    final interval = item.hydrationIntervalMin;
    if (interval == null || interval <= 0) return '$remaining ml to go';
    final slots = _remainingSlots(interval);
    if (slots <= 0) return '$remaining ml to go';
    final per = (remaining / slots / 50).ceil() * 50; // round up to 50 ml
    return '~$per ml per reminder to hit your goal';
  }

  int _remainingSlots(int intervalMin) {
    final interval = intervalMin < 30 ? 30 : intervalMin;
    final now = DateTime.now();
    final nowM = now.hour * 60 + now.minute;
    var count = 0;
    for (var m = kHydrationStartMin;
        m <= kHydrationEndMin && count < 48;
        m += interval) {
      if (m >= nowM) count++;
    }
    return count;
  }
}
