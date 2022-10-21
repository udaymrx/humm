import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/settings_service.dart';

final settingsProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class AppThemeNotifier extends StateNotifier<ThemeMode> {
  AppThemeNotifier(this.ref) : super(ThemeMode.light) {
    loadSettings();
  }

  final Ref ref;

  Future<void> loadSettings() async {
    final currentTheme = ref.read(settingsProvider).themeMode();

    state = currentTheme;
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == state) return;

    // Otherwise, store the new ThemeMode in memory
    state = newThemeMode;

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await ref.read(settingsProvider).updateThemeMode(newThemeMode);
  }
}
