import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/controllers/favorite_list_controller.dart';
import 'package:humm/src/controllers/playlist_controller.dart';
import 'package:humm/src/controllers/song_list_controller.dart';
import 'package:humm/src/data/local/favorite_box.dart';
import 'package:humm/src/services/room_service.dart';
import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../controllers/add_song_to_playlist_controler.dart';
import '../controllers/queue_controller.dart';
import '../data/model/posistion_model.dart';

import '../controllers/settings_controller.dart';
import '../services/audio_service.dart';

final themeController =
    StateNotifierProvider<AppThemeNotifier, ThemeMode>((ref) {
  return AppThemeNotifier(ref);
});

final audioQueryProvider = Provider<AudioQueryService>((ref) {
  return AudioQueryService();
});

final songArtProvider = FutureProvider.family<Uint8List?, int>((ref, id) async {
  return ref.read(audioQueryProvider).getSongArt(id);
});

final roomProvider = Provider<RoomService>((ref) {
  return RoomService();
});

final favoriteBoxProvider = Provider<FavoriteBox>((ref) {
  return FavoriteBox();
});

// final playlistBoxProvider = Provider<PlaylistBox>((ref) {
//   return PlaylistBox();
// });

final isFavoriteProvider = FutureProvider.family<bool, int>((ref, id) async {
  final result = await ref.read(roomProvider).isSongFavorite(id);
  return result;
});

final favoriteSongProvider = StateNotifierProvider<FavoutiteSongListNotifier,
    AsyncValue<List<FavoritesEntity>>>((ref) {
  return FavoutiteSongListNotifier(ref);
});

final listOfPlaylistProvider =
    FutureProvider<List<PlaylistEntity>>((ref) async {
  final result = await ref.read(roomProvider).getPlaylists();
  return result;
});

final songsToAddProvider =
    ChangeNotifierProvider.autoDispose<SongsToAddNotifier>((ref) {
  return SongsToAddNotifier();
});

final songsOfPlaylistProvider = StateNotifierProvider.autoDispose
    .family<PlaylistSongListNotifier, AsyncValue<List<SongEntity>>, int>(
        (ref, key) {
  return PlaylistSongListNotifier(ref, key: key);
});

final playerProvider = StateProvider<AudioPlayer>((ref) {
  return AudioPlayer();
});

final queueController =
    StateNotifierProvider<QueueController, ConcatenatingAudioSource>((ref) {
  return QueueController(ref);
});

final musicQueuedProvider = StateProvider<bool>((ref) {
  return false;
});

final queueHashcodeProvider = StateProvider<int?>((ref) {
  return null;
});

final allSongProvider =
    StateNotifierProvider<SongListNotifier, AsyncValue<List<SongModel>>>((ref) {
  return SongListNotifier(ref);
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

final processingStateProvider = StreamProvider<ProcessingState>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.processingStateStream));
});

final playingIndexProvider = StreamProvider<int?>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.currentIndexStream));
});

final remainingProvider = StreamProvider<Duration>((ref) {
  StreamController<Duration> st = StreamController();
  var myStr = st.stream.asBroadcastStream();
  ref.listen(durationProvider, (prev, durt) {
    ref.listen(positionProvider, (prv, position) {
      var duration = durt.value ?? Duration.zero;
      Duration remaining = Duration.zero;
      if (duration >= position.value!) {
        remaining = duration - position.value!;
      }
      st.add(remaining);
    });
  });
  return myStr;
});

final dragProvider = StreamProvider<PositionData>((ref) {
  StreamController<PositionData> st = StreamController();
  var myStr = st.stream.asBroadcastStream();
  ref.listen(durationProvider, (prv, durt) {
    ref.listen(positionProvider, (pr, post) {
      st.add(PositionData(post.value!, durt.value ?? Duration.zero));
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
    StateProvider.family<List<SongModel>, String>((ref, artist) {
  final out = ref.watch(allSongProvider);

  List<SongModel> filteredList = [];

  out.whenData((list) {
    filteredList = list.where((song) {
      return song.artist == artist;
    }).toList();
  });

  return filteredList;
});

final albumFilterSongProvider =
    StateProvider.family<List<SongModel>, String>((ref, album) {
  final out = ref.watch(allSongProvider);

  List<SongModel> filteredList = [];

  out.whenData((list) {
    filteredList = list.where((song) {
      return song.album == album;
    }).toList();
  });

  return filteredList;
});
