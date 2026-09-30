import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_14/models/booking.dart';
import 'package:flutter_application_14/models/bus.dart';
import 'package:flutter_application_14/models/search_record.dart';
import 'package:flutter_application_14/services/booking_service.dart';
import 'package:flutter_application_14/services/settings_service.dart';
import 'package:flutter_application_14/theme/app_theme.dart';

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

  group('models', () {
    test('Bus round trips through its row map', () {
      const Bus bus = Bus(
        routeId: 1,
        busId: 2,
        name: 'Shaheen Express',
        from: 'Kohat',
        to: 'pindi',
        time: '16 Hours Service',
        price: 'Rs. 1000',
      );

      final Bus restored = Bus.fromMap(<String, dynamic>{
        'route_id': 1,
        'bus_id': 2,
        'name': 'Shaheen Express',
        'origin': 'Kohat',
        'destination': 'pindi',
        'time': '16 Hours Service',
        'price': 'Rs. 1000',
      });

      expect(restored.name, bus.name);
      expect(restored.from, bus.from);
      expect(restored.to, bus.to);
      expect(restored.time, bus.time);
      expect(restored.price, bus.price);
      expect(bus.toMap()['origin'], 'Kohat');
      expect(bus.toMap()['destination'], 'pindi');
    });

    test('Booking round trips through its row map', () {
      const Booking booking = Booking(
        passengerName: 'Ali Khan',
        phone: '03001234567',
        seatNumber: 12,
        createdAt: '2026-09-30T10:00:00.000',
      );

      final Booking restored = Booking.fromMap(booking.toMap());
      expect(restored.passengerName, 'Ali Khan');
      expect(restored.phone, '03001234567');
      expect(restored.seatNumber, 12);
      expect(booking.copyWithId(9).id, 9);
    });

    test('SearchRecord keeps the home search fields', () {
      const SearchRecord record = SearchRecord(
        origin: 'Kohat',
        destination: 'pindi',
        date: '01/01/2026',
        returnDate: '02/01/2026',
        createdAt: 'now',
      );

      final SearchRecord restored = SearchRecord.fromMap(record.toMap());
      expect(restored.origin, 'Kohat');
      expect(restored.destination, 'pindi');
      expect(restored.date, '01/01/2026');
      expect(restored.returnDate, '02/01/2026');
    });
  });

  group('database safety', () {
    test('settings fall back to defaults when the database is unavailable',
        () async {
      final SettingsService settings = SettingsService.instance;

      await settings.load();

      expect(settings.notificationsEnabled, isTrue);
      expect(settings.darkModeEnabled, isFalse);
      expect(settings.languageCode, 'en');

      await settings.setDarkMode(true);
      expect(settings.darkModeEnabled, isTrue);

      await settings.setNotifications(false);
      expect(settings.notificationsEnabled, isFalse);

      await settings.setLanguage('ur');
      expect(settings.languageCode, 'ur');
    });

    test('services return empty results instead of throwing', () async {
      expect(await BookingService.instance.getBookedSeatNumbers(), isEmpty);
      expect(await BookingService.instance.getBookings(), isEmpty);
      expect(await BookingService.instance.deleteBooking(1), isFalse);
    });
  });

  group('theme', () {
    testWidgets('light mode keeps the original white surfaces',
        (WidgetTester tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light,
        home: Builder(builder: (BuildContext context) {
          ctx = context;
          return const SizedBox.shrink();
        }),
      ));

      expect(AppTheme.light.brightness, Brightness.light);
      expect(AppColors.isDark(ctx), isFalse);
      expect(AppColors.surface(ctx), Colors.white);
      expect(AppColors.tintedSurface(ctx), Colors.green.shade50);
    });

    testWidgets('dark mode swaps surfaces to readable dark colours',
        (WidgetTester tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.dark,
        home: Builder(builder: (BuildContext context) {
          ctx = context;
          return const SizedBox.shrink();
        }),
      ));

      expect(AppColors.isDark(ctx), isTrue);
      expect(AppColors.surface(ctx), isNot(Colors.white));
      expect(AppColors.tintedSurface(ctx), isNot(Colors.green.shade50));
    });
  });
}
