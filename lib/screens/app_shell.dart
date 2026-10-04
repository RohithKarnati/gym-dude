import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/notification_helper.dart';
import '../providers/settings_providers.dart';
import 'home/home_screen.dart';
import 'me/me_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'routine/routine_screen.dart';
import 'train/train_screen.dart';

/// Bottom-nav shell holding the four top-level tabs: Home · Train · Routine · Me.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Keep scheduled reminders in sync with the current plan on each launch.
      applyNotificationSchedule(ref);
      await _maybeShowTour();
    });
  }

  /// Show the first-run tour once, then record that it's been seen.
  Future<void> _maybeShowTour() async {
    final dao = ref.read(settingsDaoProvider);
    final settings = await dao.ensureSettings();
    if (settings.hasSeenTour || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(),
        fullscreenDialog: true,
      ),
    );
    await dao.setHasSeenTour(true);
  }

  static const _tabs = <Widget>[
    HomeScreen(),
    TrainScreen(),
    RoutineScreen(),
    MeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Train',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Routine',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}
