import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/notification_helper.dart';
import '../../providers/settings_providers.dart';
import '../../services/notification_service.dart';
import 'body_screen.dart';

class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider).value;
    final mode = settings?.themeMode ?? 'system';
    final dao = ref.read(settingsDaoProvider);

    final notifyDayBefore = settings?.notifyDayBefore ?? false;
    final notifyBedtime = settings?.notifyBedtime ?? false;
    final notifyMorning = settings?.notifyMorning ?? false;
    final bedtime = settings?.bedtimeTarget ?? '22:30';

    Future<void> onToggle(Future<void> Function(bool) setter, bool v) async {
      await setter(v);
      if (v) await NotificationService.instance.requestPermission();
      await applyNotificationSchedule(ref);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Me')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // --- Body ---
          Card(
            child: ListTile(
              leading: const Icon(Icons.monitor_weight_outlined),
              title: const Text('Body & progress'),
              subtitle: const Text('Bodyweight, photos, trend'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BodyScreen()),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- Appearance ---
          _SectionTitle('Appearance'),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                  value: 'system',
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto)),
              ButtonSegment(
                  value: 'light',
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode)),
              ButtonSegment(
                  value: 'dark',
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode)),
            ],
            selected: {mode},
            onSelectionChanged: (sel) => dao.setThemeMode(sel.first),
          ),
          const SizedBox(height: 24),

          // --- Notifications (F9) ---
          _SectionTitle('Notifications'),
          const SizedBox(height: 4),
          Text(
            'Opt-in and minimal — never more than a couple a day.',
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Day-before workout'),
            subtitle: const Text('Evening before a training day'),
            value: notifyDayBefore,
            onChanged: (v) => onToggle(dao.setNotifyDayBefore, v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Bedtime nudge'),
            subtitle: Text('Wind-down reminder at $bedtime'),
            value: notifyBedtime,
            onChanged: (v) => onToggle(dao.setNotifyBedtime, v),
          ),
          if (notifyBedtime)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.schedule, size: 18),
                  label: Text('Bedtime: $bedtime'),
                  onPressed: () async {
                    final parts = bedtime.split(':');
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: int.tryParse(parts[0]) ?? 22,
                        minute: int.tryParse(parts.length > 1 ? parts[1] : '') ?? 30,
                      ),
                    );
                    if (picked == null) return;
                    final hhmm =
                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                    await dao.setBedtimeTarget(hhmm);
                    await applyNotificationSchedule(ref);
                  },
                ),
              ),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Morning summary'),
            subtitle: const Text("Today's plan + a nudge, at 7:30am"),
            value: notifyMorning,
            onChanged: (v) => onToggle(dao.setNotifyMorning, v),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('Send a preview'),
            onPressed: () async {
              await NotificationService.instance.requestPermission();
              await NotificationService.instance.showPreview(
                'Gym Dude',
                "Today: don't forget creatine 💧 and beat last time 💪",
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
