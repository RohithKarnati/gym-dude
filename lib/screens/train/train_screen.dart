import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../placeholder_view.dart';

class TrainScreen extends ConsumerWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Train')),
      body: const PlaceholderView(
        icon: Icons.fitness_center_outlined,
        title: 'Plan & log',
        features: [
          'Weekly split plan editor (F1)',
          'Session logger with previous numbers (F2)',
          'PR celebration overlay (F3)',
          'PR history + shareable card (F4)',
        ],
      ),
    );
  }
}
