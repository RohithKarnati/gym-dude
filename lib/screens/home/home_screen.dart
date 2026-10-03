import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../placeholder_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gym Dude')),
      body: const PlaceholderView(
        icon: Icons.bolt_outlined,
        title: 'Today at a glance',
        features: [
          "Today's workout + usual time",
          '"Beat this" targets for key lifts',
          'Daily checklist progress ring',
          'Streak chip (days / weeks)',
          'Start today\'s workout',
        ],
      ),
    );
  }
}
