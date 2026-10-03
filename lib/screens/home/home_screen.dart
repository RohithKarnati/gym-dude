import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/database.dart';
import '../../providers/routine_providers.dart';
import '../../providers/workout_providers.dart';
import '../../utils/weekdays.dart';
import '../train/session_logger_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysAsync = ref.watch(allDaysProvider);
    final stats = ref.watch(trainingStatsProvider).value ??
        TrainingStats.empty;
    final today = todayWeekday();
    final dateStr = DateFormat('EEEE, d MMMM').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Gym Dude')),
      body: daysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (days) {
          WorkoutDay? todayDay;
          for (final d in days) {
            if (d.weekday == today) todayDay = d;
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Text(dateStr,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              _StreakRow(stats: stats),
              const SizedBox(height: 16),
              _TodayCard(day: todayDay),
              const SizedBox(height: 16),
              const _RoutineProgressCard(),
            ],
          );
        },
      ),
    );
  }
}

class _StreakRow extends StatelessWidget {
  const _StreakRow({required this.stats});

  final TrainingStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: '🔥',
            value: '${stats.weekStreak}',
            label: stats.weekStreak == 1 ? 'week streak' : 'weeks in a row',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatChip(
            icon: '🏋️',
            value: '${stats.daysThisWeek}',
            label: stats.daysThisWeek == 1 ? 'day this week' : 'days this week',
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
                Text(label,
                    style: TextStyle(
                        color: scheme.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayCard extends ConsumerWidget {
  const _TodayCard({required this.day});

  final WorkoutDay? day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    if (day == null || day!.isRestDay) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today',
                  style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(
                day == null ? 'No workout planned' : 'Rest day',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                day == null
                    ? 'Set up today in the Train tab.'
                    : 'Recover well. 😴',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    final exAsync = ref.watch(exercisesProvider(day!.id));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today',
                style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              day!.title.isEmpty ? 'Workout' : day!.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (day!.usualTime != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.schedule,
                      size: 16, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(day!.usualTime!,
                      style: TextStyle(color: scheme.onSurfaceVariant)),
                ],
              ),
            ],
            const SizedBox(height: 16),
            exAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => const SizedBox.shrink(),
              data: (exercises) {
                if (exercises.isEmpty) {
                  return Text('No exercises yet — add some in Train.',
                      style: TextStyle(color: scheme.onSurfaceVariant));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final e in exercises) _TargetLine(exerciseName: e.name),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _startSession(context, ref, exercises),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Start today's workout"),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startSession(
    BuildContext context,
    WidgetRef ref,
    List<PlannedExercise> exercises,
  ) async {
    final navigator = Navigator.of(context);
    final dao = ref.read(workoutDaoProvider);
    final session = await dao.startOrGetTodaySession(day!.id);
    navigator.push(
      MaterialPageRoute(
        builder: (_) => SessionLoggerScreen(
          sessionId: session.id,
          dayId: day!.id,
          dayTitle: day!.title,
        ),
      ),
    );
  }
}

/// Daily checklist progress ring on the home screen (F5 glance).
class _RoutineProgressCard extends ConsumerWidget {
  const _RoutineProgressCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final progress = ref.watch(dailyProgressProvider);
    final total = progress.total;
    final done = progress.done;
    final frac = total == 0 ? 0.0 : done / total;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
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
                      value: total == 0 ? 0 : frac,
                      strokeWidth: 6,
                      backgroundColor: scheme.surfaceContainerHighest,
                    ),
                  ),
                  Text(total == 0 ? '—' : '$done/$total',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily routine',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    total == 0
                        ? 'Set it up in the Routine tab.'
                        : done == total
                            ? 'All done today! 🎉'
                            : '${total - done} left today',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One exercise line on the home card with its PR target (F3 "beat this").
class _TargetLine extends ConsumerWidget {
  const _TargetLine({required this.exerciseName});

  final String exerciseName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final pr = ref.watch(exercisePrProvider(exerciseName)).value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(Icons.fitness_center, size: 16, color: scheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(exerciseName,
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          if (pr != null)
            Text(
              '🎯 ${_fmtNum(pr.weightKg)}×${pr.reps}',
              style: TextStyle(
                  color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
            ),
        ],
      ),
    );
  }
}

String _fmtNum(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
