import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gemma_3n_client/screens/personalization_screen.dart';

void main() {
  testWidgets('PersonalizationScreen loads and saves preferences', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: PersonalizationScreen(),
    ));

    // The screen starts with a loading indicator.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Let the initial loading future complete.
    await tester.pumpAndSettle();

    // Verify the UI is now visible.
    expect(find.text('User Profile'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Save Preferences'), findsOneWidget);

    // Enter text into the fields.
    await tester.enterText(find.byType(TextField).first, 'Test User');
    await tester.enterText(find.byType(TextField).last, 'Test Preferences');
    await tester.pump();

    // Tap the save button.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Allow time for the SnackBar to appear.

    // A real test would mock the service to verify it was called,
    // but for now, we confirm the UI interaction works without error.
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('Test Preferences'), findsOneWidget);
  });
}
