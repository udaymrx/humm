import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/global_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicNotifier extends StateNotifier<AudioPlayer> {
  MusicNotifier(this._reader) : super(AudioPlayer()) {
    _initPlaylist();
  }

  final Reader _reader;

  void _initPlaylist() {
    state.setAudioSource(_reader(playlistController));
  }

  // Future<void> initSource(List<SongModel> songsList) async {
  //   List<AudioSource> songs = [];
  //   for (var song in songsList) {
  //     final s = AudioSource.uri(
  //       Uri.parse(song.uri!),
  //       tag: MediaItem(
  //         // Specify a unique ID for each media item:
  //         id: "${song.id}",
  //         // Metadata to display in the notification:
  //         album: song.album,
  //         artist: song.artist ?? "Unknown Artist",
  //         title: song.displayNameWOExt,
  //         // artUri: Uri.parse('https://example.com/albumart.jpg'),
  //       ),
  //     );
  //     songs.add(s);
  //   }

  //   final playlist = ConcatenatingAudioSource(children: songs);
  //   await state.setAudioSource(playlist);
  // }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}
