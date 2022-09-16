import 'package:flutter/material.dart';
import 'package:humm/src/services/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  ThemeMode themeMode() {
    switch (UserPreferences.selectedTheme) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.dark;
      case 2:
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.

    int newTheme = 0;

    switch (theme) {
      case ThemeMode.system:
        newTheme = 0;
        break;
      case ThemeMode.dark:
        newTheme = 1;
        break;
      case ThemeMode.light:
        newTheme = 2;
        break;
      default:
        newTheme = 0;
    }
    await UserPreferences.setTheme(newTheme);
  }
}
