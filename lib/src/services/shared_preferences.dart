import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static const _language = 'language';
  static const _selectedTheme = 'selectedTheme'; // 0: system, 1: dark, 2: light
  static const _appPath = 'appPath';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setLanguage(String? lang) async {
    await _preferences.setString(_language, lang ?? 'en');
  }

  static Future setTheme(int select) async {
    _preferences.setInt(_selectedTheme, select);
  }

  static Future setAppPath(String appPath) async {
    await _preferences.setString(_appPath, appPath);
  }

  static String get language => _preferences.getString(_language) ?? "en";

  static int get selectedTheme => _preferences.getInt(_selectedTheme) ?? 2;

  static String get appPath => _preferences.getString(_appPath) ?? "";

  static Future removeAppPath() async {
    await _preferences.remove(_appPath);
  }

  static Future removeUser() async {
    await _preferences.remove(_language);
    await _preferences.remove(_selectedTheme);
  }
}
