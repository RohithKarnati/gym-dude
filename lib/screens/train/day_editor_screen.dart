import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/workout_dao.dart';
import '../../providers/category_providers.dart';
import '../../providers/notification_helper.dart';
import '../../providers/workout_providers.dart';
import '../../utils/cardio.dart';
import '../../utils/weekdays.dart';
import '../../widgets/text_input_dialog.dart';

/// Plan editor for a single weekday (F1): title, usual time, rest toggle,
/// and the ordered list of planned exercises.
class DayEditorScreen extends ConsumerStatefulWidget {
  const DayEditorScreen({super.key, required this.weekday, this.existing});

  final int weekday;
  final WorkoutDay? existing;

  @override
  ConsumerState<DayEditorScreen> createState() => _DayEditorScreenState();
}

class _DayEditorScreenState extends ConsumerState<DayEditorScreen> {
  late final TextEditingController _titleCtrl;
  TimeOfDay? _time;
  bool _isRest = false;
  int? _dayId;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _isRest = e?.isRestDay ?? false;
    _dayId = e?.id;
    _time = _parseTime(e?.usualTime);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  static TimeOfDay? _parseTime(String? hhmm) {
    if (hhmm == null || !hhmm.contains(':')) return null;
    final parts = hhmm.split(':');
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String? get _timeString => _time == null
      ? null
      : '${_time!.hour.toString().padLeft(2, '0')}:'
          '${_time!.minute.toString().padLeft(2, '0')}';

  WorkoutDao get _dao => ref.read(workoutDaoProvider);

  /// Ensure the day row exists, persisting current form values. Returns its id.
  Future<int> _ensureDay() async {
    final id = await _dao.upsertDay(
      weekday: widget.weekday,
      title: _titleCtrl.text.trim(),
      usualTime: _timeString,
      isRestDay: _isRest,
    );
    if (_dayId != id && mounted) {
      setState(() => _dayId = id);
    } else {
      _dayId = id;
    }
    return id;
  }

  Future<void> _save() async {
    await _ensureDay();
    // Plan changed → refresh day-before + morning reminders to match.
    await applyNotificationSchedule(ref);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plan saved')),
    );
    Navigator.of(context).pop();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 18, minute: 30),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _addOrEditExercise({PlannedExercise? exercise}) async {
    final result = await showDialog<_ExerciseInput>(
      context: context,
      builder: (_) => _ExerciseDialog(existing: exercise),
    );
    if (result == null) return;
    final dayId = await _ensureDay();
    if (exercise == null) {
      await _dao.addExercise(
        workoutDayId: dayId,
        name: result.name,
        category: result.category,
        targetSets: result.targetSets,
        targetWeightKg: result.targetWeightKg,
        cardioMetric: result.cardioMetric,
        trackPr: result.trackPr,
      );
    } else {
      await _dao.updateExercise(
        id: exercise.id,
        name: result.name,
        category: result.category,
        targetSets: result.targetSets,
        targetWeightKg: result.targetWeightKg,
        cardioMetric: result.cardioMetric,
        trackPr: result.trackPr,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(weekdayName(widget.weekday)),
        actions: [
          TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Rest day'),
            subtitle: const Text('No workout planned for this day'),
            value: _isRest,
            onChanged: (v) => setState(() => _isRest = v),
          ),
          if (!_isRest) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _titleCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Workout title',
                hintText: 'e.g. Chest + Triceps',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: const Text('Usual time'),
              subtitle: Text(_timeString ?? 'Not set'),
              trailing: _time == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _time = null),
                    ),
              onTap: _pickTime,
            ),
            const Divider(height: 32),
            Row(
              children: [
                Text(
                  'Exercises',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _addOrEditExercise(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (_dayId == null)
              Text(
                'No exercises yet. Tap “Add” to create your first one.',
                style: TextStyle(color: scheme.onSurfaceVariant),
              )
            else
              _ExerciseList(
                dayId: _dayId!,
                onEdit: (e) => _addOrEditExercise(exercise: e),
                onDelete: (e) => _dao.deleteExercise(e.id),
                onReorder: _dao.reorderExercises,
              ),
          ],
        ],
      ),
    );
  }
}

class _ExerciseList extends ConsumerWidget {
  const _ExerciseList({
    required this.dayId,
    required this.onEdit,
    required this.onDelete,
    required this.onReorder,
  });

  final int dayId;
  final void Function(PlannedExercise) onEdit;
  final void Function(PlannedExercise) onDelete;
  final Future<void> Function(List<PlannedExercise>) onReorder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final exAsync = ref.watch(exercisesProvider(dayId));
    return exAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('Error: $e'),
      data: (exercises) {
        if (exercises.isEmpty) {
          return Text(
            'No exercises yet. Tap “Add” to create your first one.',
            style: TextStyle(color: scheme.onSurfaceVariant),
          );
        }
        return ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: exercises.length,
          onReorderItem: (oldIndex, newIndex) {
            final list = [...exercises];
            final item = list.removeAt(oldIndex);
            list.insert(newIndex, item);
            onReorder(list);
          },
          itemBuilder: (context, i) {
            final e = exercises[i];
            return Card(
              key: ValueKey(e.id),
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(e.name),
                subtitle: Text(_exerciseSubtitle(e)),
                leading: ReorderableDragStartListener(
                  index: i,
                  child: Icon(Icons.drag_handle, color: scheme.onSurfaceVariant),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => onEdit(e),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => onDelete(e),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ExerciseInput {
  _ExerciseInput(
    this.name,
    this.category,
    this.targetSets,
    this.targetWeightKg,
    this.cardioMetric,
    this.trackPr,
  );
  final String name;
  final String category;
  final int targetSets;
  final double? targetWeightKg;
  final String? cardioMetric; // null = strength
  final bool trackPr;
}

class _ExerciseDialog extends ConsumerStatefulWidget {
  const _ExerciseDialog({this.existing});
  final PlannedExercise? existing;

  @override
  ConsumerState<_ExerciseDialog> createState() => _ExerciseDialogState();
}

class _ExerciseDialogState extends ConsumerState<_ExerciseDialog> {
  static const int _maxSets = 100;
  static const String _addNewValue = '__add_new__';
  static const String _strength = '__strength__';

  late final TextEditingController _nameCtrl;
  late final TextEditingController _weightCtrl;
  late final TextEditingController _setsCtrl;
  late String _category;
  String? _metric; // null = strength (weight × reps)
  bool _trackPr = true;

  @override
  void initState() {
    super.initState();
    _trackPr = widget.existing?.trackPr ?? true;
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _weightCtrl = TextEditingController(
      text: widget.existing?.targetWeightKg == null
          ? ''
          : _fmt(widget.existing!.targetWeightKg!),
    );
    _setsCtrl =
        TextEditingController(text: '${widget.existing?.targetSets ?? 3}');
    final existingCat = widget.existing?.category;
    _category = (existingCat != null && existingCat.isNotEmpty)
        ? existingCat
        : 'Other';
    _metric = widget.existing?.cardioMetric;
  }

  Future<void> _promptNewCategory() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const TextInputDialog(
        title: 'New category',
        hint: 'e.g. Forearms',
      ),
    );
    if (name == null || name.isEmpty) return;
    await ref.read(categoryDaoProvider).addCategory(name);
    if (mounted) setState(() => _category = name);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _weightCtrl.dispose();
    _setsCtrl.dispose();
    super.dispose();
  }

  int get _setsValue => int.tryParse(_setsCtrl.text.trim()) ?? 0;

  void _bumpSets(int delta) {
    final next = (_setsValue + delta).clamp(1, _maxSets);
    setState(() => _setsCtrl.text = '$next');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add exercise' : 'Edit exercise'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'e.g. Barbell Bench Press',
              ),
            ),
            const SizedBox(height: 16),
            Builder(builder: (context) {
              final categories = [...ref.watch(allCategoriesProvider)];
              if (!categories.contains(_category)) categories.add(_category);
              return DropdownButtonFormField<String>(
                initialValue: _category,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  for (final c in categories)
                    DropdownMenuItem(value: c, child: Text(c)),
                  const DropdownMenuItem(
                    value: _addNewValue,
                    child: Text('➕ Add new category…'),
                  ),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  if (v == _addNewValue) {
                    _promptNewCategory();
                  } else {
                    setState(() => _category = v);
                  }
                },
              );
            }),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _metric ?? _strength,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Logging',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: [
                DropdownMenuItem(value: _strength, child: Text(metricLabel(null))),
                for (final m in cardioMetrics)
                  DropdownMenuItem(value: m, child: Text(metricLabel(m))),
              ],
              onChanged: (v) => setState(
                  () => _metric = (v == null || v == _strength) ? null : v),
            ),
            const SizedBox(height: 16),
            if (_metric == null)
              TextField(
                controller: _weightCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Target weight (optional)',
                  suffixText: 'kg',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            if (_metric == null) const SizedBox(height: 20),
            Row(
              children: [
                const Text('Target sets'),
                const Spacer(),
                IconButton.filledTonal(
                  icon: const Icon(Icons.remove),
                  onPressed: _setsValue > 1 ? () => _bumpSets(-1) : null,
                ),
                SizedBox(
                  width: 56,
                  child: TextField(
                    controller: _setsCtrl,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                IconButton.filledTonal(
                  icon: const Icon(Icons.add),
                  onPressed:
                      _setsValue < _maxSets ? () => _bumpSets(1) : null,
                ),
              ],
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text('Track personal records'),
              subtitle: const Text('Celebrate a new PR when you beat your best'),
              value: _trackPr,
              onChanged: (v) => setState(() => _trackPr = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameCtrl.text.trim();
            if (name.isEmpty) return;
            // Cardio exercises don't carry a target weight.
            final weight =
                _metric == null ? double.tryParse(_weightCtrl.text.trim()) : null;
            final sets = _setsValue.clamp(1, _maxSets);
            Navigator.pop(context,
                _ExerciseInput(name, _category, sets, weight, _metric, _trackPr));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

String _exerciseSubtitle(PlannedExercise e) {
  final noPr = e.trackPr ? '' : ' · no PR';
  if (e.cardioMetric != null) {
    return '${e.category} · ${e.targetSets} sets · ${metricLabel(e.cardioMetric)}$noPr';
  }
  if (e.targetWeightKg == null) {
    return '${e.category} · ${e.targetSets} sets$noPr';
  }
  return '${e.category} · ${e.targetSets} sets · ${_fmt(e.targetWeightKg!)} kg$noPr';
}

String _fmt(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
