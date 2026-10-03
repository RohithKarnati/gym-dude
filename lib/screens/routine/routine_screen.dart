import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/routine_dao.dart';
import '../../providers/routine_providers.dart';
import '../../utils/weekdays.dart';

/// Routine tab: daily checklist (F5) + weekly meal-prep tasks (F6).
class RoutineScreen extends ConsumerWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Routine'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Daily'),
              Tab(text: 'Meal prep'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DailyTab(),
            _MealPrepTab(),
          ],
        ),
      ),
    );
  }
}

// --- Category helpers --------------------------------------------------------

const List<String> _categoryOrder = ['hydration', 'meal', 'supplement', 'other'];

String _categoryLabel(String c) => switch (c) {
      'hydration' => 'Hydration',
      'meal' => 'Meals',
      'supplement' => 'Supplements',
      _ => 'Other',
    };

IconData _categoryIcon(String c) => switch (c) {
      'hydration' => Icons.water_drop_outlined,
      'meal' => Icons.restaurant_outlined,
      'supplement' => Icons.medication_outlined,
      _ => Icons.check_circle_outline,
    };

// --- Daily tab (F5) ----------------------------------------------------------

class _DailyTab extends ConsumerWidget {
  const _DailyTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(routineItemsProvider);
    final doneIds = ref.watch(doneTodayIdsProvider);
    final dao = ref.read(routineDaoProvider);

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (items) {
        if (items.isEmpty) {
          return _DailyEmptyState(
            onSeed: dao.seedStarterItems,
            onAdd: () => _showAddItemDialog(context, ref),
          );
        }

        // Group by category in a stable order.
        final byCategory = <String, List<RoutineItem>>{};
        for (final item in items) {
          byCategory.putIfAbsent(item.category, () => []).add(item);
        }
        final categories = [
          ..._categoryOrder.where(byCategory.containsKey),
          ...byCategory.keys.where((c) => !_categoryOrder.contains(c)),
        ];

        final total = items.length;
        final done = items.where((i) => doneIds.contains(i.id)).length;
        final missed = items.where((i) => !doneIds.contains(i.id)).toList();
        final isEvening = DateTime.now().hour >= 20;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            _ProgressCard(done: done, total: total),
            if (isEvening && missed.isNotEmpty) ...[
              const SizedBox(height: 12),
              _MissedCard(count: missed.length),
            ],
            const SizedBox(height: 8),
            for (final category in categories) ...[
              const SizedBox(height: 12),
              _CategoryHeader(category: category),
              const SizedBox(height: 4),
              for (final item in byCategory[category]!)
                _RoutineTile(
                  item: item,
                  done: doneIds.contains(item.id),
                  onToggle: (v) =>
                      dao.setRoutineDone(item.id, DateTime.now(), v),
                  onDelete: () => dao.deactivateItem(item.id),
                ),
            ],
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _showAddItemDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add item'),
            ),
          ],
        );
      },
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final frac = total == 0 ? 0.0 : done / total;
    final allDone = total > 0 && done == total;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      value: frac,
                      strokeWidth: 6,
                      backgroundColor: scheme.surfaceContainerHighest,
                    ),
                  ),
                  Text('$done/$total',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    allDone ? 'All done today! 🎉' : "Today's checklist",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    allDone
                        ? 'Nice consistency.'
                        : '${total - done} to go — keep it up.',
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

class _MissedCard extends StatelessWidget {
  const _MissedCard({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.nightlight_outlined, color: scheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "You still have $count item${count == 1 ? '' : 's'} left today.",
              style: TextStyle(
                  color: scheme.onErrorContainer, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(_categoryIcon(category), size: 18, color: scheme.primary),
        const SizedBox(width: 8),
        Text(
          _categoryLabel(category),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.primary,
              ),
        ),
      ],
    );
  }
}

class _RoutineTile extends StatelessWidget {
  const _RoutineTile({
    required this.item,
    required this.done,
    required this.onToggle,
    required this.onDelete,
  });

  final RoutineItem item;
  final bool done;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey('routine_${item.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline, color: scheme.onErrorContainer),
      ),
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        controlAffinity: ListTileControlAffinity.leading,
        value: done,
        onChanged: (v) => onToggle(v ?? false),
        title: Text(
          item.label,
          style: TextStyle(
            decoration: done ? TextDecoration.lineThrough : null,
            color: done ? scheme.onSurfaceVariant : scheme.onSurface,
          ),
        ),
        subtitle: item.defaultTime == null ? null : Text(item.defaultTime!),
      ),
    );
  }
}

class _DailyEmptyState extends StatelessWidget {
  const _DailyEmptyState({required this.onSeed, required this.onAdd});

  final Future<void> Function() onSeed;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checklist_rtl_outlined, size: 56, color: scheme.primary),
            const SizedBox(height: 16),
            Text('Build your daily routine',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              'Water, meals, supplements — check them off each day.',
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onSeed,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Add starter items'),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add my own'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showAddItemDialog(BuildContext context, WidgetRef ref) async {
  final result = await showDialog<({String label, String category})>(
    context: context,
    builder: (_) => const _AddItemDialog(),
  );
  if (result == null) return;
  await ref
      .read(routineDaoProvider)
      .addItem(label: result.label, category: result.category);
}

class _AddItemDialog extends StatefulWidget {
  const _AddItemDialog();

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final _ctrl = TextEditingController();
  String _category = 'supplement';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ctrl,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Label',
              hintText: 'e.g. Creatine',
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items: [
              for (final c in _categoryOrder)
                DropdownMenuItem(value: c, child: Text(_categoryLabel(c))),
            ],
            onChanged: (v) => setState(() => _category = v ?? 'other'),
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
            final label = _ctrl.text.trim();
            if (label.isEmpty) return;
            Navigator.pop(context, (label: label, category: _category));
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// --- Meal-prep tab (F6) ------------------------------------------------------

class _MealPrepTab extends ConsumerWidget {
  const _MealPrepTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(mealPrepTasksProvider);
    final doneIds = ref.watch(mealPrepDoneIdsProvider);
    final dao = ref.read(routineDaoProvider);

    return tasksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (tasks) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Text(
              'This week',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Recurring prep tasks. Check off as you knock them out.',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            if (tasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text('No prep tasks yet.',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                ),
              )
            else
              for (final task in tasks)
                _MealPrepTile(
                  task: task,
                  done: doneIds.contains(task.id),
                  onToggle: (v) => dao.setMealPrepDone(
                      task.id, RoutineDao.mondayOf(DateTime.now()), v),
                  onDelete: () => dao.deactivateMealPrepTask(task.id),
                ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _showAddTaskDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add prep task'),
            ),
          ],
        );
      },
    );
  }
}

class _MealPrepTile extends StatelessWidget {
  const _MealPrepTile({
    required this.task,
    required this.done,
    required this.onToggle,
    required this.onDelete,
  });

  final MealPrepTask task;
  final bool done;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey('mealprep_${task.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline, color: scheme.onErrorContainer),
      ),
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        controlAffinity: ListTileControlAffinity.leading,
        value: done,
        onChanged: (v) => onToggle(v ?? false),
        title: Text(
          task.label,
          style: TextStyle(
            decoration: done ? TextDecoration.lineThrough : null,
            color: done ? scheme.onSurfaceVariant : scheme.onSurface,
          ),
        ),
        subtitle: Text(weekdayName(task.weekday)),
      ),
    );
  }
}

Future<void> _showAddTaskDialog(BuildContext context, WidgetRef ref) async {
  final result = await showDialog<({String label, int weekday})>(
    context: context,
    builder: (_) => const _AddTaskDialog(),
  );
  if (result == null) return;
  await ref
      .read(routineDaoProvider)
      .addMealPrepTask(label: result.label, weekday: result.weekday);
}

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog();

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _ctrl = TextEditingController();
  int _weekday = DateTime.now().weekday;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add prep task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ctrl,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Task',
              hintText: 'e.g. Chop veggies for 3 days',
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<int>(
            initialValue: _weekday,
            decoration: const InputDecoration(labelText: 'Day'),
            items: [
              for (var d = 1; d <= 7; d++)
                DropdownMenuItem(value: d, child: Text(weekdayName(d))),
            ],
            onChanged: (v) => setState(() => _weekday = v ?? 1),
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
            final label = _ctrl.text.trim();
            if (label.isEmpty) return;
            Navigator.pop(context, (label: label, weekday: _weekday));
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
