import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../placeholder_view.dart';

class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Me')),
      body: const PlaceholderView(
        icon: Icons.person_outline,
        title: 'Body & settings',
        features: [
          'Bodyweight + progress photo + trend (F7)',
          'Notification toggles (F9)',
          'Bedtime target & units',
        ],
      ),
    );
  }
}
