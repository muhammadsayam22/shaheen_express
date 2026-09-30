// Basic smoke test for the Shaheen Express application.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_14/main.dart';

void main() {
  testWidgets('Shaheen Express launches the splash screen',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const ShaheenExpress());

    // The splash screen is the initial route of the application.
    expect(find.text('WELCOME TO SHAHEEN EXPRESS'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Tear the widget tree down before the splash navigation timer fires,
    // then advance the clock so the test finishes without pending timers.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 9));
  });
}
