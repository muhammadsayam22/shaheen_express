import 'package:flutter/widgets.dart';
import 'package:flutter_application_14/database/database_helper.dart';

/// Local key/value settings stored in the Shaheen Express SQLite database.
///
/// Values are loaded once before the first frame is rendered and every change
/// is written straight back to the database, so notifications, dark mode and
/// language all survive an app restart.
class SettingsService extends ChangeNotifier {
  SettingsService._();

  static final SettingsService instance = SettingsService._();

  static const String keyNotifications = 'notifications';
  static const String keyDarkMode = 'dark_mode';
  static const String keyLanguage = 'language';
  static const String keyProfileName = 'profile_name';
  static const String keyProfileEmail = 'profile_email';
  static const String keyProfilePhone = 'profile_phone';

  static const String defaultLanguage = 'en';

  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String languageCode = defaultLanguage;
  String profileName = '';
  String profileEmail = '';
  String profilePhone = '';

  bool _loaded = false;

  bool get isLoaded => _loaded;

  Locale get locale => Locale(languageCode);

  Future<void> load() async {
    try {
      final DatabaseHelper db = DatabaseHelper.instance;
      notificationsEnabled =
          (await db.getSetting(keyNotifications)) != 'false';
      darkModeEnabled = (await db.getSetting(keyDarkMode)) == 'true';
      languageCode = await db.getSetting(keyLanguage) ?? defaultLanguage;
      profileName = await db.getSetting(keyProfileName) ?? '';
      profileEmail = await db.getSetting(keyProfileEmail) ?? '';
      profilePhone = await db.getSetting(keyProfilePhone) ?? '';
      _loaded = true;
    } catch (error) {
      debugPrint('SettingsService: unable to load settings -> $error');
    }
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    if (notificationsEnabled == value) return;
    notificationsEnabled = value;
    notifyListeners();
    await _persist(keyNotifications, value ? 'true' : 'false');
  }

  Future<void> setDarkMode(bool value) async {
    if (darkModeEnabled == value) return;
    darkModeEnabled = value;
    notifyListeners();
    await _persist(keyDarkMode, value ? 'true' : 'false');
  }

  Future<void> setLanguage(String code) async {
    if (languageCode == code || code.isEmpty) return;
    languageCode = code;
    notifyListeners();
    await _persist(keyLanguage, code);
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    profileName = name;
    profileEmail = email;
    profilePhone = phone;
    notifyListeners();
    await _persist(keyProfileName, name);
    await _persist(keyProfileEmail, email);
    await _persist(keyProfilePhone, phone);
  }

  Future<void> _persist(String key, String value) async {
    try {
      final bool saved =
          await DatabaseHelper.instance.setSetting(key, value);
      if (!saved) {
        debugPrint('SettingsService: could not save "$key"');
      }
    } catch (error) {
      debugPrint('SettingsService: could not save "$key" -> $error');
    }
  }
}
