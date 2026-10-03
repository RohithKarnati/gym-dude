import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/settings_providers.dart';

class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider).value;
    final mode = settings?.themeMode ?? 'system';

    return Scaffold(
      appBar: AppBar(title: const Text('Me')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(
            'Appearance',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'system',
                label: Text('System'),
                icon: Icon(Icons.brightness_auto),
              ),
              ButtonSegment(
                value: 'light',
                label: Text('Light'),
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment(
                value: 'dark',
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (sel) {
              ref.read(settingsDaoProvider).setThemeMode(sel.first);
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Choose light, dark, or follow your device.',
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
          const Divider(height: 40),
          Text(
            'Coming soon',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          for (final f in const [
            'Bodyweight + progress photo + trend (F7)',
            'Notification toggles (F9)',
            'Bedtime target & units',
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 6, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(f,
                        style: TextStyle(color: scheme.onSurfaceVariant)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
