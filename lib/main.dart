import 'package:flutter/material.dart';
import 'package:flutter_application_14/bus_list_page.dart';
import 'package:flutter_application_14/services/settings_service.dart';
import 'package:flutter_application_14/settings_page.dart';
import 'package:flutter_application_14/splashscreen.dart';
import 'package:flutter_application_14/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Opens the local SQLite database (creating and seeding it on first run)
  // and restores the saved preferences before the first frame is drawn.
  await SettingsService.instance.load();

  runApp(const ShaheenExpress());
}

class ShaheenExpress extends StatefulWidget {
  const ShaheenExpress({super.key});

  @override
  State<ShaheenExpress> createState() => _ShaheenExpressState();
}

class _ShaheenExpressState extends State<ShaheenExpress> {
  final SettingsService _settings = SettingsService.instance;

  @override
  void initState() {
    super.initState();
    _settings.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shaheen Express',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _settings.darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      locale: _settings.locale,
      supportedLocales: AppTheme.supportedLocales,
      localizationsDelegates: AppTheme.localizationsDelegates,
      home: const SplashScreen(),
      routes: {
        '/buslistpage': (context) => const BusListPage(),
        '/settingspage': (context) => const SettingsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
