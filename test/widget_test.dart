import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gym_dude/app.dart';

void main() {
  testWidgets('App boots into the 4-tab shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: GymDudeApp()));
    await tester.pumpAndSettle();

    // Bottom navigation destinations are present.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Train'), findsOneWidget);
    expect(find.text('Routine'), findsOneWidget);
    expect(find.text('Me'), findsOneWidget);

    // Tapping a tab switches the visible screen.
    await tester.tap(find.text('Train'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Train'), findsOneWidget);
  });
}
