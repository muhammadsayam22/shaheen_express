import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Theme definition for the Shaheen Express app.
///
/// The light theme is identical to the theme the app shipped with, so the
/// existing screens keep their exact current look.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(primarySwatch: Colors.red);

  static ThemeData get dark => ThemeData.dark();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      GlobalMaterialLocalizations.delegates;
}

/// Surface colours that stay pixel identical to the original design in light
/// mode and switch to readable dark surfaces when dark mode is enabled.
class AppColors {
  AppColors._();

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color surface(BuildContext context) =>
      isDark(context) ? const Color(0xFF212121) : Colors.white;

  static Color tintedSurface(BuildContext context) =>
      isDark(context) ? const Color(0xFF14351A) : Colors.green.shade50;

  static Gradient gradient(BuildContext context) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Colors.green.shade50, surface(context)],
      );
}
