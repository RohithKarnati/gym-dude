import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/database.dart';
import '../../data/workout_dao.dart';
import '../../providers/workout_providers.dart';

/// Session logger (F2) + PR detection & celebration (F3): log sets per planned
/// exercise, with last session's numbers / current PR shown inline. Beating a
/// record fires confetti, a haptic, and a "🎉 NEW PR" card.
class SessionLoggerScreen extends ConsumerStatefulWidget {
  const SessionLoggerScreen({
    super.key,
    required this.sessionId,
    required this.dayId,
    required this.dayTitle,
  });

  final int sessionId;
  final int dayId;
  final String dayTitle;

  @override
  ConsumerState<SessionLoggerScreen> createState() =>
      _SessionLoggerScreenState();
}

class _SessionLoggerScreenState extends ConsumerState<SessionLoggerScreen> {
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _celebrate(String exerciseName, PrResult pr) {
    HapticFeedback.heavyImpact();
    _confetti.play();
    showDialog<void>(
      context: context,
      builder: (_) => _PrCelebrationCard(exerciseName: exerciseName, pr: pr),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exAsync = ref.watch(exercisesProvider(widget.dayId));
    final dateStr = DateFormat('EEE, d MMM').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dayTitle.isEmpty ? "Today's workout" : widget.dayTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                dateStr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          exAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (exercises) {
              if (exercises.isEmpty) {
                return const Center(child: Text('No exercises planned.'));
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
                itemCount: exercises.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, i) => _ExerciseLogCard(
                  sessionId: widget.sessionId,
                  exercise: exercises[i],
                  onPr: (pr) => _celebrate(exercises[i].name, pr),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 28,
              emissionFrequency: 0.06,
              gravity: 0.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseLogCard extends ConsumerStatefulWidget {
  const _ExerciseLogCard({
    required this.sessionId,
    required this.exercise,
    required this.onPr,
  });

  final int sessionId;
  final PlannedExercise exercise;
  final void Function(PrResult) onPr;

  @override
  ConsumerState<_ExerciseLogCard> createState() => _ExerciseLogCardState();
}

class _ExerciseLogCardState extends ConsumerState<_ExerciseLogCard> {
  final _weightCtrl = TextEditingController();
  final _repsCtrl = TextEditingController();
  final _rpeCtrl = TextEditingController();

  @override
  void dispose() {
    _weightCtrl.dispose();
    _repsCtrl.dispose();
    _rpeCtrl.dispose();
    super.dispose();
  }

  ExerciseInSession get _key =>
      (sessionId: widget.sessionId, exerciseName: widget.exercise.name);

  Future<void> _addSet() async {
    final weight = double.tryParse(_weightCtrl.text.trim());
    final reps = int.tryParse(_repsCtrl.text.trim());
    final rpe = _rpeCtrl.text.trim().isEmpty
        ? null
        : double.tryParse(_rpeCtrl.text.trim());
    if (weight == null || reps == null || reps <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a weight and reps.')),
      );
      return;
    }
    final pr = await ref.read(workoutDaoProvider).addSetLog(
          sessionId: widget.sessionId,
          exerciseName: widget.exercise.name,
          weightKg: weight,
          reps: reps,
          rpe: rpe,
        );
    if (pr != null) {
      widget.onPr(pr);
    } else {
      HapticFeedback.lightImpact();
    }
    _repsCtrl.clear();
    _rpeCtrl.clear();
    // Keep the weight for convenient repeat sets.
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final setsAsync = ref.watch(exerciseSetLogsProvider(_key));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.exercise.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                setsAsync.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  data: (sets) => Text(
                    '${sets.length}/${widget.exercise.targetSets} sets',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _TargetBanner(
              sessionId: widget.sessionId,
              exerciseName: widget.exercise.name,
            ),
            const SizedBox(height: 12),
            setsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(8),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Error: $e'),
              data: (sets) => Column(
                children: [
                  for (final s in sets)
                    _LoggedSetRow(
                      set: s,
                      onDelete: () =>
                          ref.read(workoutDaoProvider).deleteSetLog(s.id),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _SetInputRow(
              weightCtrl: _weightCtrl,
              repsCtrl: _repsCtrl,
              rpeCtrl: _rpeCtrl,
              onAdd: _addSet,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the current PR to beat (F3) or last session's best; falls back to an
/// encouraging prompt when there's no history yet.
class _TargetBanner extends ConsumerWidget {
  const _TargetBanner({required this.sessionId, required this.exerciseName});

  final int sessionId;
  final String exerciseName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final pr = ref.watch(exercisePrProvider(exerciseName)).value;
    final prev = ref
        .watch(beatThisTargetProvider(
            (sessionId: sessionId, exerciseName: exerciseName)))
        .value;

    final String text;
    if (pr != null) {
      text = '🎯 PR to beat: ${_fmt(pr.weightKg)} kg × ${pr.reps}';
    } else if (prev != null) {
      text = '🎯 Beat this: ${_fmt(prev.weightKg)} kg × ${prev.reps}';
    } else {
      text = 'No previous data — set the bar! 💪';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: scheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LoggedSetRow extends StatelessWidget {
  const _LoggedSetRow({required this.set, required this.onDelete});

  final SetLog set;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: set.isPr ? scheme.tertiaryContainer : scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${set.setNumber}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_fmt(set.weightKg)} kg × ${set.reps}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          if (set.rpe != null) ...[
            const SizedBox(width: 8),
            Text('RPE ${_fmt(set.rpe!)}',
                style: TextStyle(color: scheme.onSurfaceVariant)),
          ],
          if (set.isPr) ...[
            const SizedBox(width: 8),
            Text('🎉 PR',
                style: TextStyle(
                    color: scheme.tertiary, fontWeight: FontWeight.w700)),
          ],
          const Spacer(),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.close, size: 18, color: scheme.onSurfaceVariant),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _SetInputRow extends StatelessWidget {
  const _SetInputRow({
    required this.weightCtrl,
    required this.repsCtrl,
    required this.rpeCtrl,
    required this.onAdd,
  });

  final TextEditingController weightCtrl;
  final TextEditingController repsCtrl;
  final TextEditingController rpeCtrl;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: _numField(weightCtrl, 'kg', decimal: true)),
        const SizedBox(width: 8),
        Expanded(flex: 2, child: _numField(repsCtrl, 'reps')),
        const SizedBox(width: 8),
        Expanded(flex: 2, child: _numField(rpeCtrl, 'RPE', decimal: true)),
        const SizedBox(width: 4),
        IconButton.filled(
          icon: const Icon(Icons.add),
          onPressed: onAdd,
          tooltip: 'Add set',
        ),
      ],
    );
  }

  Widget _numField(TextEditingController c, String label,
      {bool decimal = false}) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _PrCelebrationCard extends StatelessWidget {
  const _PrCelebrationCard({required this.exerciseName, required this.pr});

  final String exerciseName;
  final PrResult pr;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final prev = pr.previous;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 8),
            Text(
              'NEW PR!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              exerciseName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (prev != null) ...[
                  _StatBlock(
                    label: 'Old',
                    value: '${_fmt(prev.weightKg)} × ${prev.reps}',
                    emphasized: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.arrow_forward, color: scheme.onSurfaceVariant),
                  ),
                ],
                _StatBlock(
                  label: 'New',
                  value: '${_fmt(pr.weightKg)} × ${pr.reps}',
                  emphasized: true,
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Nice! 💪'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.label,
    required this.value,
    required this.emphasized,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(label, style: TextStyle(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasized ? 24 : 18,
            fontWeight: FontWeight.w800,
            color: emphasized ? scheme.primary : scheme.onSurface,
          ),
        ),
      ],
    );
  }
}

String _fmt(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
