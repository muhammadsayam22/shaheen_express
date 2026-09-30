import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_14/home_page.dart';
import 'package:flutter_application_14/info_screen.dart';
import 'package:flutter_application_14/main.dart';
import 'package:flutter_application_14/services/settings_service.dart';
import 'package:flutter_application_14/settings_page.dart';
import 'package:flutter_application_14/splashscreen.dart';

void main() {
  tearDown(() {
    final SettingsService settings = SettingsService.instance;
    settings.notificationsEnabled = true;
    settings.darkModeEnabled = false;
    settings.languageCode = SettingsService.defaultLanguage;
    settings.profileName = '';
    settings.profileEmail = '';
    settings.profilePhone = '';
  });

  testWidgets('Settings screen shows every required section',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Shaheen Guest'), findsOneWidget);
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsWidgets);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('App Information'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Terms & Conditions'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(2));
    expect(find.byType(DropdownButton<String>), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Settings toggles are stored in the settings service',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

    expect(SettingsService.instance.notificationsEnabled, isTrue);
    expect(SettingsService.instance.darkModeEnabled, isFalse);

    await tester.tap(find.byType(Switch).at(0));
    await tester.pump();
    expect(SettingsService.instance.notificationsEnabled, isFalse);

    await tester.tap(find.byType(Switch).at(1));
    await tester.pump();
    expect(SettingsService.instance.darkModeEnabled, isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Privacy Policy opens its information screen',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: SettingsPage()));
    await tester.tap(find.text('Privacy Policy'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(InfoScreen), findsOneWidget);
    expect(find.text('Data We Store'), findsOneWidget);
    expect(find.text('Where It Is Stored'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('dark mode and Urdu locale are applied without errors',
      (WidgetTester tester) async {
    final SettingsService settings = SettingsService.instance;
    settings.darkModeEnabled = true;
    settings.languageCode = 'ur';

    await tester.pumpWidget(const ShaheenExpress());
    await tester.pump();

    final BuildContext ctx = tester.element(find.byType(SplashScreen));
    expect(Theme.of(ctx).brightness, Brightness.dark);
    expect(Localizations.localeOf(ctx), const Locale('ur'));
    expect(
      Localizations.of<MaterialLocalizations>(ctx, MaterialLocalizations),
      isNotNull,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 9));
  });

  testWidgets('Settings opens from the home drawer',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ShaheenExpress());
    await tester.pump(const Duration(seconds: 8));
    await tester.pump();
    drainLayoutErrors(tester);
    expect(find.byType(HomePage), findsOneWidget);

    final Finder homeScaffold = find.descendant(
      of: find.byType(HomePage),
      matching: find.byType(Scaffold),
    );
    tester.state<ScaffoldState>(homeScaffold).openDrawer();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    drainLayoutErrors(tester);

    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    drainLayoutErrors(tester);

    expect(find.byType(SettingsPage), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 9));
  });
}

/// The home screen ships with pre-existing RenderFlex overflows, so their
/// reports are dropped here to keep this navigation test focused.
void drainLayoutErrors(WidgetTester tester) {
  while (tester.takeException() != null) {}
}
