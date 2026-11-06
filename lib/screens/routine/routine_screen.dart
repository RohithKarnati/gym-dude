import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers/hydration_providers.dart';
import '../../providers/notification_helper.dart';
import '../../providers/routine_providers.dart';
import '../../providers/shopping_providers.dart';
import '../../services/notification_service.dart';
import '../../utils/recurrence.dart';
import '../../widgets/hydration_card.dart';
import '../../widgets/text_input_dialog.dart';

/// Routine tab: user-defined lists (tabs) of recurring checklist tasks and
/// shopping lists. The "+" at the end of the tab bar adds a new list.
class RoutineScreen extends ConsumerWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(routineListsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Routine')),
      body: listsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (lists) {
          if (lists.isEmpty) {
            return _NoListsState(
              onCreate: () => _showNewListDialog(context, ref),
            );
          }
          return _RoutineTabs(lists: lists);
        },
      ),
    );
  }
}

// --- Category helpers (sub-grouping within a checklist list) ------------------

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

// --- Dynamic tabs shell ------------------------------------------------------

class _RoutineTabs extends ConsumerStatefulWidget {
  const _RoutineTabs({required this.lists});
  final List<RoutineList> lists;

  @override
  ConsumerState<_RoutineTabs> createState() => _RoutineTabsState();
}

class _RoutineTabsState extends ConsumerState<_RoutineTabs>
    with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: widget.lists.length, vsync: this);
  }

  @override
  void didUpdateWidget(covariant _RoutineTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lists.length != widget.lists.length) {
      final keep = _controller.index.clamp(0, widget.lists.length - 1);
      _controller.dispose();
      _controller =
          TabController(length: widget.lists.length, vsync: this, initialIndex: keep);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  RoutineList get _current => widget.lists[_controller.index];

  Future<void> _renameCurrent() async {
    final list = _current;
    final name = await showDialog<String>(
      context: context,
      builder: (_) => TextInputDialog(
        title: 'Rename list',
        initial: list.name,
        confirmLabel: 'Save',
      ),
    );
    if (name == null || name.isEmpty) return;
    await ref.read(routineDaoProvider).renameList(list.id, name);
  }

  Future<void> _deleteCurrent() async {
    if (widget.lists.length <= 1) return;
    final list = _current;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete "${list.name}"?'),
        content: const Text('Its items are hidden (history is kept).'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(routineDaoProvider).deactivateList(list.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TabBar(
                controller: _controller,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [for (final l in widget.lists) Tab(text: l.name)],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'List options',
              onSelected: (v) {
                if (v == 'new') _showNewListDialog(context, ref);
                if (v == 'rename') _renameCurrent();
                if (v == 'delete') _deleteCurrent();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'new',
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 20),
                      SizedBox(width: 12),
                      Text('Add new list'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(value: 'rename', child: Text('Rename list')),
                PopupMenuItem(
                  value: 'delete',
                  enabled: widget.lists.length > 1,
                  child: const Text('Delete list'),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              for (final l in widget.lists)
                l.kind == 'shopping'
                    ? _ShopTab(key: ValueKey('shop_${l.id}'), list: l)
                    : _ChecklistTab(key: ValueKey('cl_${l.id}'), list: l),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Checklist list ----------------------------------------------------------

class _ChecklistTab extends ConsumerWidget {
  const _ChecklistTab({super.key, required this.list});
  final RoutineList list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(listItemsProvider(list.id));
    final doneIds = ref.watch(doneTodayIdsProvider);
    final dao = ref.read(routineDaoProvider);

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (items) {
        if (items.isEmpty) {
          return _ChecklistEmptyState(
            onSeed: () => dao.seedStarterItems(list.id),
            onAdd: () => _showTaskDialog(context, ref, list.id),
          );
        }

        final todayItems =
            items.where((i) => isScheduledToday(i.daysMask)).toList();
        final total = todayItems.length;
        final done = todayItems.where((i) => doneIds.contains(i.id)).length;

        final byCategory = <String, List<RoutineItem>>{};
        for (final item in items) {
          byCategory.putIfAbsent(item.category, () => []).add(item);
        }
        final categories = [
          ..._categoryOrder.where(byCategory.containsKey),
          ...byCategory.keys.where((c) => !_categoryOrder.contains(c)),
        ];
        final missed = todayItems.where((i) => !doneIds.contains(i.id)).length;
        final isEvening = DateTime.now().hour >= 20;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            _ProgressCard(done: done, total: total),
            if (isEvening && missed > 0) ...[
              const SizedBox(height: 12),
              _MissedCard(count: missed),
            ],
            const SizedBox(height: 8),
            for (final category in categories) ...[
              const SizedBox(height: 12),
              _CategoryHeader(category: category),
              const SizedBox(height: 4),
              for (final item in byCategory[category]!)
                if (item.category == 'hydration' &&
                    item.hydrationGoalMl != null)
                  Dismissible(
                    key: ValueKey('hyd_${item.id}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => dao.deactivateItem(item.id),
                    background: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.delete_outline,
                          color: Theme.of(context).colorScheme.onErrorContainer),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: HydrationTracker(
                        item: item,
                        scheduledToday: isScheduledToday(item.daysMask),
                        onEdit: () =>
                            _showTaskDialog(context, ref, list.id, item),
                      ),
                    ),
                  )
                else
                  _TaskTile(
                    item: item,
                    done: doneIds.contains(item.id),
                    scheduledToday: isScheduledToday(item.daysMask),
                    onToggle: (v) =>
                        dao.setRoutineDone(item.id, DateTime.now(), v),
                    onDelete: () => dao.deactivateItem(item.id),
                    onEdit: () => _showTaskDialog(context, ref, list.id, item),
                  ),
            ],
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _showTaskDialog(context, ref, list.id),
              icon: const Icon(Icons.add),
              label: const Text('Add task'),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                      value: total == 0 ? 0 : frac,
                      strokeWidth: 6,
                      backgroundColor: scheme.surfaceContainerHighest,
                    ),
                  ),
                  Text('$done/$total',
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
                  Text("Today's tasks",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    total == 0
                        ? 'Nothing scheduled today.'
                        : done == total
                            ? 'All done today! 🎉'
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
          const Text('🌙', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You still have $count item${count == 1 ? '' : 's'} left today.',
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

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.item,
    required this.done,
    required this.scheduledToday,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  final RoutineItem item;
  final bool done;
  final bool scheduledToday;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final subtitle = [
      recurrenceLabel(item.daysMask),
      if (item.defaultTime != null) '⏰ ${item.defaultTime}',
    ].join(' · ');

    return Dismissible(
      key: ValueKey('task_${item.id}'),
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
      child: Opacity(
        opacity: scheduledToday ? 1 : 0.55,
        child: CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          controlAffinity: ListTileControlAffinity.leading,
          value: scheduledToday && done,
          // Only today's tasks are checkable.
          onChanged: scheduledToday ? (v) => onToggle(v ?? false) : null,
          title: Text(
            item.label,
            style: TextStyle(
              decoration:
                  (scheduledToday && done) ? TextDecoration.lineThrough : null,
              color: (scheduledToday && done)
                  ? scheme.onSurfaceVariant
                  : scheme.onSurface,
            ),
          ),
          subtitle: Text(subtitle),
          secondary: IconButton(
            icon: Icon(Icons.edit_outlined, color: scheme.onSurfaceVariant),
            tooltip: 'Edit',
            onPressed: onEdit,
          ),
        ),
      ),
    );
  }
}

class _ChecklistEmptyState extends StatelessWidget {
  const _ChecklistEmptyState({required this.onSeed, required this.onAdd});
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
            Text('No tasks yet',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Add recurring tasks with their own days + reminder.',
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant)),
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

// --- Shopping list -----------------------------------------------------------

class _ShopTab extends ConsumerWidget {
  const _ShopTab({super.key, required this.list});
  final RoutineList list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final itemsAsync = ref.watch(shoppingItemsProvider(list.id));
    final dao = ref.read(shoppingDaoProvider);

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (items) {
        final boughtCount = items.where((i) => i.isBought).length;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Row(
              children: [
                Text('To buy',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                if (boughtCount > 0)
                  TextButton.icon(
                    onPressed: () => dao.clearBought(list.id),
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: Text('Clear $boughtCount'),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                        size: 56, color: scheme.primary),
                    const SizedBox(height: 12),
                    Text('Nothing to buy yet',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text('Add groceries, supplements, anything to pick up.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: scheme.onSurfaceVariant)),
                  ],
                ),
              )
            else
              for (final item in items)
                Dismissible(
                  key: ValueKey('shop_item_${item.id}'),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => dao.deleteItem(item.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.delete_outline,
                        color: scheme.onErrorContainer),
                  ),
                  child: CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: item.isBought,
                    onChanged: (v) => dao.setBought(item.id, v ?? false),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        decoration:
                            item.isBought ? TextDecoration.lineThrough : null,
                        color: item.isBought
                            ? scheme.onSurfaceVariant
                            : scheme.onSurface,
                      ),
                    ),
                  ),
                ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _showAddShopDialog(context, ref, list.id),
              icon: const Icon(Icons.add),
              label: const Text('Add item'),
            ),
          ],
        );
      },
    );
  }
}

class _NoListsState extends StatelessWidget {
  const _NoListsState({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Create your first list'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('New list'),
          ),
        ],
      ),
    );
  }
}

// --- Dialogs -----------------------------------------------------------------

Future<void> _showNewListDialog(BuildContext context, WidgetRef ref) async {
  final result = await showDialog<({String name, String kind})>(
    context: context,
    builder: (_) => const _NewListDialog(),
  );
  if (result == null) return;
  await ref
      .read(routineDaoProvider)
      .addList(name: result.name, kind: result.kind);
}

class _NewListDialog extends StatefulWidget {
  const _NewListDialog();
  @override
  State<_NewListDialog> createState() => _NewListDialogState();
}

class _NewListDialogState extends State<_NewListDialog> {
  final _ctrl = TextEditingController();
  String _kind = 'checklist';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New list'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ctrl,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'e.g. Supplements, Groceries',
            ),
          ),
          const SizedBox(height: 20),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                  value: 'checklist',
                  label: Text('Checklist'),
                  icon: Icon(Icons.checklist)),
              ButtonSegment(
                  value: 'shopping',
                  label: Text('Shopping'),
                  icon: Icon(Icons.shopping_cart_outlined)),
            ],
            selected: {_kind},
            onSelectionChanged: (s) => setState(() => _kind = s.first),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final name = _ctrl.text.trim();
            if (name.isEmpty) return;
            Navigator.pop(context, (name: name, kind: _kind));
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

Future<void> _showAddShopDialog(
    BuildContext context, WidgetRef ref, int listId) async {
  final label = await showDialog<String>(
    context: context,
    builder: (_) => const TextInputDialog(
      title: 'Add to buy',
      hint: 'e.g. Chicken breast',
    ),
  );
  if (label == null || label.isEmpty) return;
  await ref.read(shoppingDaoProvider).addItem(listId, label);
}

Future<void> _showTaskDialog(
  BuildContext context,
  WidgetRef ref,
  int listId, [
  RoutineItem? existing,
]) async {
  final result = await showDialog<_TaskInput>(
    context: context,
    builder: (_) => _TaskDialog(existing: existing),
  );
  if (result == null) return;
  final dao = ref.read(routineDaoProvider);
  if (existing == null) {
    await dao.addItem(
      listId: listId,
      label: result.label,
      category: result.category,
      daysMask: result.daysMask,
      defaultTime: result.time,
      hydrationGoalMl: result.hydrationGoalMl,
      hydrationIntervalMin: result.hydrationIntervalMin,
    );
  } else {
    await dao.updateItem(
      id: existing.id,
      label: result.label,
      category: result.category,
      daysMask: result.daysMask,
      defaultTime: result.time,
      hydrationGoalMl: result.hydrationGoalMl,
      hydrationIntervalMin: result.hydrationIntervalMin,
    );
    // Re-sync the "done" state to goal vs. intake (e.g. a previously-checked
    // task just became a hydration tracker, or the goal changed).
    if (result.hydrationGoalMl != null) {
      await ref
          .read(hydrationDaoProvider)
          .syncCheck(existing.id, DateTime.now());
    }
  }
  // Hydration items and timed tasks both schedule notifications.
  if (result.time != null || result.hydrationIntervalMin != null) {
    await NotificationService.instance.requestPermission();
  }
  await applyNotificationSchedule(ref);
}

class _TaskInput {
  _TaskInput(
    this.label,
    this.category,
    this.daysMask,
    this.time, {
    this.hydrationGoalMl,
    this.hydrationIntervalMin,
  });
  final String label;
  final String category;
  final int daysMask;
  final String? time;
  final int? hydrationGoalMl;
  final int? hydrationIntervalMin;
}

TimeOfDay? _parseTimeOfDay(String? hhmm) {
  if (hhmm == null || !hhmm.contains(':')) return null;
  final parts = hhmm.split(':');
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts.length > 1 ? parts[1] : '');
  if (h == null || m == null) return null;
  return TimeOfDay(hour: h, minute: m);
}

String _timeToString(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

class _TaskDialog extends StatefulWidget {
  const _TaskDialog({this.existing});
  final RoutineItem? existing;

  @override
  State<_TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<_TaskDialog> {
  static const int _defaultGoalMl = 3000;
  static const int _defaultIntervalMin = 120;

  late final TextEditingController _ctrl;
  late String _category;
  late int _daysMask;
  TimeOfDay? _time;
  late int _goalMl;
  late int _intervalMin;

  bool get _isHydration => _category == 'hydration';

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.existing?.label ?? '');
    final existingCat = widget.existing?.category;
    _category =
        _categoryOrder.contains(existingCat) ? existingCat! : 'supplement';
    _daysMask = widget.existing?.daysMask ?? everyDayMask;
    _time = _parseTimeOfDay(widget.existing?.defaultTime);
    _goalMl = widget.existing?.hydrationGoalMl ?? _defaultGoalMl;
    _intervalMin = widget.existing?.hydrationIntervalMin ?? _defaultIntervalMin;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggleDay(int weekday) {
    final bit = 1 << (weekday - 1);
    setState(() {
      if ((_daysMask & bit) != 0) {
        _daysMask &= ~bit;
      } else {
        _daysMask |= bit;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit task' : 'Add task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: [
                for (final c in _categoryOrder)
                  DropdownMenuItem(value: c, child: Text(_categoryLabel(c))),
              ],
              onChanged: (v) => setState(() => _category = v ?? 'other'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Repeat',
                    style: Theme.of(context).textTheme.labelLarge),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() => _daysMask = everyDayMask),
                  child: const Text('Every day'),
                ),
              ],
            ),
            Wrap(
              spacing: 6,
              children: [
                for (var w = 1; w <= 7; w++)
                  FilterChip(
                    label: Text(dayAbbrev(w)),
                    selected: isScheduledOn(_daysMask, w),
                    onSelected: (_) => _toggleDay(w),
                    showCheckmark: false,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (_isHydration) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.local_drink_outlined),
                title: const Text('Daily goal'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filledTonal(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.remove),
                      onPressed: _goalMl > 500
                          ? () => setState(() => _goalMl -= 250)
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${(_goalMl / 1000).toStringAsFixed(_goalMl % 1000 == 0 ? 0 : 2)} L',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton.filledTonal(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.add),
                      onPressed: _goalMl < 8000
                          ? () => setState(() => _goalMl += 250)
                          : null,
                    ),
                  ],
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.timelapse_outlined),
                title: const Text('Remind every'),
                trailing: DropdownButton<int>(
                  value: const [60, 90, 120, 180, 240, 360].contains(_intervalMin)
                      ? _intervalMin
                      : 120,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(value: 60, child: Text('1 h')),
                    DropdownMenuItem(value: 90, child: Text('1.5 h')),
                    DropdownMenuItem(value: 120, child: Text('2 h')),
                    DropdownMenuItem(value: 180, child: Text('3 h')),
                    DropdownMenuItem(value: 240, child: Text('4 h')),
                    DropdownMenuItem(value: 360, child: Text('6 h')),
                  ],
                  onChanged: (v) =>
                      setState(() => _intervalMin = v ?? _defaultIntervalMin),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Reminders between 08:00 and 22:00, with +100 / +300 / +500 ml '
                  'buttons. Logs on the Home & Routine water card.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ] else
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Reminder'),
                subtitle: Text(_time == null ? 'None' : _timeToString(_time!)),
                trailing: _time == null
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _time = null),
                      ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
                  );
                  if (picked != null) setState(() => _time = picked);
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final label = _ctrl.text.trim();
            if (label.isEmpty) return;
            final mask = _daysMask == 0 ? everyDayMask : _daysMask;
            Navigator.pop(
              context,
              _isHydration
                  ? _TaskInput(label, _category, mask, null,
                      hydrationGoalMl: _goalMl,
                      hydrationIntervalMin: _intervalMin)
                  : _TaskInput(label, _category, mask,
                      _time == null ? null : _timeToString(_time!)),
            );
          },
          child: Text(isEdit ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
