import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static const _language = 'language';
  static const _selectedTheme = 'selectedTheme'; // 0: system, 1: dark, 2: light

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setLanguage(String? lang) async {
    await _preferences.setString(_language, lang ?? 'en');
  }

  static Future setTheme(int select) async {
    _preferences.setInt(_selectedTheme, select);
  }

  static String get language => _preferences.getString(_language) ?? "en";

  static int get selectedTheme => _preferences.getInt(_selectedTheme) ?? 0;

  static Future removeUser() async {
    await _preferences.remove(_language);
    await _preferences.remove(_selectedTheme);
  }
}
