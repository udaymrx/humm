import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/services/music_player_service.dart';

import '../controllers/settings_controller.dart';
import '../services/audio_service.dart';

final themeController =
    StateNotifierProvider<AppThemeNotifier, ThemeMode>((ref) {
  return AppThemeNotifier(ref.read);
});


final audioQueryProvider = Provider<AudioQueryService>((ref) {
  return AudioQueryService();
});

// final musicPlayerProvider = Provider<MusicPlayerService>((ref) {
//   return MusicPlayerService();
// });