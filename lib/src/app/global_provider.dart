import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/controllers/favorite_list_controller.dart';
import 'package:humm/src/controllers/song_list_controller.dart';
import 'package:humm/src/data/local/favorite_box.dart';
import 'package:humm/src/data/model/music_model.dart';
import 'package:humm/src/services/room_service.dart';
import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../controllers/playlist_controller.dart';
import '../data/model/posistion_model.dart';

import '../controllers/settings_controller.dart';
import '../services/audio_service.dart';

final themeController =
    StateNotifierProvider<AppThemeNotifier, ThemeMode>((ref) {
  return AppThemeNotifier(ref.read);
});

final audioQueryProvider = Provider<AudioQueryService>((ref) {
  return AudioQueryService();
});

final roomProvider = Provider<RoomService>((ref) {
  return RoomService();
});

final favoriteBoxProvider = Provider<FavoriteBox>((ref) {
  return FavoriteBox();
});
final isFavoriteProvider = FutureProvider.family<bool, int>((ref, id) async {
  final val = await ref.read(favoriteBoxProvider).favoriteSongsKeys;

  final result = val.any((key) => key == id);

  return result;
});

final favoriteSongProvider = StateNotifierProvider<FavoutiteSongListNotifier,
    AsyncValue<List<MusicModel>>>((ref) {
  return FavoutiteSongListNotifier(ref.read);
});

final playerProvider = StateProvider<AudioPlayer>((ref) {
  return AudioPlayer();
});

final playlistController =
    StateNotifierProvider<PlaylistController, ConcatenatingAudioSource>((ref) {
  return PlaylistController(ref.read);
});

final musicQueuedProvider = StateProvider<bool>((ref) {
  return false;
});

final queueHashcodeProvider = StateProvider<int?>((ref) {
  return null;
});

final allSongProvider =
    StateNotifierProvider<SongListNotifier, AsyncValue<List<MusicModel>>>(
        (ref) {
  return SongListNotifier(ref.read);
});

final playingProvider = StreamProvider<bool>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.playingStream));
});

final durationProvider = StreamProvider<Duration?>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.durationStream));
});

final positionProvider = StreamProvider<Duration>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.positionStream));
});

final playerStateProvider = StreamProvider<PlayerState>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.playerStateStream));
});

final playingIndexProvider = StreamProvider<int?>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.currentIndexStream));
});

final remainingProvider = StreamProvider<Duration>((ref) {
  StreamController<Duration> st = StreamController();
  var myStr = st.stream.asBroadcastStream();
  ref.watch(durationProvider.stream).listen((durt) {
    ref.watch(positionProvider.stream).listen((position) {
      var duration = durt ?? Duration.zero;
      Duration remaining = Duration.zero;
      if (duration >= position) {
        remaining = duration - position;
      }
      st.add(remaining);
    });
  });
  return myStr;
});

final dragProvider = StreamProvider<PositionData>((ref) {
  StreamController<PositionData> st = StreamController();
  var myStr = st.stream.asBroadcastStream();
  ref.watch(durationProvider.stream).listen((durt) {
    ref.watch(positionProvider.stream).listen((post) {
      st.add(PositionData(post, durt ?? Duration.zero));
    });
  });
  return myStr;
});

final loopProvider = StreamProvider<LoopMode>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.loopModeStream));
});

final shuffleProvider = StreamProvider<bool>((ref) {
  return ref
      .watch(playerProvider.select((plyr) => plyr.shuffleModeEnabledStream));
});

final metaDataProvider = StreamProvider<SequenceState?>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.sequenceStateStream));
});

final artistFilterSongProvider =
    StateProvider.family<List<MusicModel>, String>((ref, artist) {
  final out = ref.watch(allSongProvider);

  List<MusicModel> filteredList = [];

  out.whenData((list) {
    filteredList = list.where((song) {
      return song.artist == artist;
    }).toList();
  });

  return filteredList;
});

final albumFilterSongProvider =
    StateProvider.family<List<MusicModel>, String>((ref, album) {
  final out = ref.watch(allSongProvider);

  List<MusicModel> filteredList = [];

  out.whenData((list) {
    filteredList = list.where((song) {
      return song.album == album;
    }).toList();
  });

  return filteredList;
});
