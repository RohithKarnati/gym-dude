import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../placeholder_view.dart';

class RoutineScreen extends ConsumerWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Routine')),
      body: const PlaceholderView(
        icon: Icons.checklist_rtl_outlined,
        title: 'Daily & weekly habits',
        features: [
          'Daily checklist by category (F5)',
          'End-of-day missed summary',
          'Weekly meal-prep tasks (F6)',
        ],
      ),
    );
  }
}
