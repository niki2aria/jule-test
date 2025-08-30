import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gemma_3n_client/screens/settings_screen.dart';

void main() {
  testWidgets('SettingsScreen has a Dark Mode switch that can be toggled', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: SettingsScreen(),
    ));

    // Verify the initial state (switch is off).
    expect(find.text('Dark Mode'), findsOneWidget);
    SwitchListTile switchTile = tester.widget(find.byType(SwitchListTile));
    expect(switchTile.value, isFalse);

    // Tap the switch.
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump(); // Rebuild the widget after the state changes.

    // Verify the switch is now on.
    switchTile = tester.widget(find.byType(SwitchListTile));
    expect(switchTile.value, isTrue);

    // Tap it again to turn it off.
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();

    // Verify the switch is off again.
    switchTile = tester.widget(find.byType(SwitchListTile));
    expect(switchTile.value, isFalse);
  });

  testWidgets('SettingsScreen has an About list tile', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SettingsScreen(),
    ));

    expect(find.text('About'), findsOneWidget);
    // Tapping it would show a dialog, which can also be tested,
    // but for now, we'll just verify its presence.
  });
}
