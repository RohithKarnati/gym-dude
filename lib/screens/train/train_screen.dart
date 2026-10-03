import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers/workout_providers.dart';
import '../../utils/weekdays.dart';
import 'day_editor_screen.dart';
import 'session_logger_screen.dart';

/// Train tab: the weekly split overview (F1) + entry to today's session (F2).
class TrainScreen extends ConsumerWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysAsync = ref.watch(allDaysProvider);
    final today = todayWeekday();

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly plan')),
      body: daysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (days) {
          final byWeekday = {for (final d in days) d.weekday: d};
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            itemCount: 7,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final weekday = i + 1;
              return _DayCard(
                weekday: weekday,
                day: byWeekday[weekday],
                isToday: weekday == today,
              );
            },
          );
        },
      ),
    );
  }
}

class _DayCard extends ConsumerWidget {
  const _DayCard({
    required this.weekday,
    required this.day,
    required this.isToday,
  });

  final int weekday;
  final WorkoutDay? day;
  final bool isToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final configured = day != null;
    final isRest = day?.isRestDay ?? false;

    String subtitle;
    if (!configured) {
      subtitle = 'Tap to set up';
    } else if (isRest) {
      subtitle = 'Rest day';
    } else {
      subtitle = day!.title.isEmpty ? 'Untitled' : day!.title;
    }

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openEditor(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isToday
                          ? scheme.primary
                          : scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      weekdayShort(weekday),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isToday ? scheme.onPrimary : scheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                subtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: configured && !isRest
                                          ? scheme.onSurface
                                          : scheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                            if (isToday) ...[
                              const SizedBox(width: 8),
                              _Pill(
                                label: 'Today',
                                color: scheme.primary,
                                onColor: scheme.onPrimary,
                              ),
                            ],
                          ],
                        ),
                        if (configured && !isRest)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              day!.usualTime == null
                                  ? 'No time set'
                                  : 'Usual time ${day!.usualTime}',
                              style: TextStyle(color: scheme.onSurfaceVariant),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
                ],
              ),
              if (configured && !isRest) _ExerciseSummary(dayId: day!.id),
              if (isToday && configured && !isRest) ...[
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => _startSession(context),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Start today's workout"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _openEditor(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DayEditorScreen(weekday: weekday, existing: day),
      ),
    );
  }

  Future<void> _startSession(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final dao = ProviderScope.containerOf(context).read(workoutDaoProvider);
    final exercises = await dao.getExercises(day!.id);
    if (exercises.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Add some exercises to this day first.')),
      );
      return;
    }
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

class _ExerciseSummary extends ConsumerWidget {
  const _ExerciseSummary({required this.dayId});

  final int dayId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final exAsync = ref.watch(exercisesProvider(dayId));
    return exAsync.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (exercises) {
        if (exercises.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, left: 58),
            child: Text(
              'No exercises yet',
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8, left: 58),
          child: Text(
            exercises.map((e) => e.name).join(' · '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color, required this.onColor});

  final String label;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: onColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
