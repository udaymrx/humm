import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:humm/src/app/global_provider.dart';
import 'package:humm/src/data/model/music_model.dart';
import 'package:humm/src/data/model/playlist_info_model.dart';

import 'package:humm/src/services/shared_preferences.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_room/on_audio_room.dart';

import 'src/app.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeApp();
  FlutterNativeSplash.remove();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initializeApp() async {
  await UserPreferences.init();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'drawable/icon',
  );
  final cont = ProviderContainer();
  await cont.read(audioQueryProvider).requestPermission();
  await Hive.initFlutter();
  Hive.registerAdapter(MusicModelAdapter());
  Hive.registerAdapter(PlaylistInfoModelAdapter());
  cont.read(favoriteBoxProvider).openFavoriteBox();
}
