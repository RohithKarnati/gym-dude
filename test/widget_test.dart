import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gym_dude/app.dart';
import 'package:gym_dude/data/database.dart';
import 'package:gym_dude/providers/workout_providers.dart';

void main() {
  testWidgets('App boots into the 4-tab shell and shows the weekly plan',
      (tester) async {
    // Override the plan stream with a plain, empty stream so the test never
    // touches the real drift database (avoids platform channels, native
    // sqlite and drift's deferred stream-close timers under fake async).
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDaysProvider
              .overrideWith((ref) => Stream.value(const <WorkoutDay>[])),
        ],
        child: const GymDudeApp(),
      ),
    );
    await tester.pump();

    // Bottom navigation destinations are present.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Train'), findsOneWidget);
    expect(find.text('Routine'), findsOneWidget);
    expect(find.text('Me'), findsOneWidget);

    // Switch to the Train tab -> weekly plan screen with 7 weekday rows.
    await tester.tap(find.text('Train'));
    await tester.pump();
    expect(find.widgetWithText(AppBar, 'Weekly plan'), findsOneWidget);
    expect(find.text('Mon'), findsOneWidget);
    expect(find.text('Fri'), findsOneWidget);
  });
}
