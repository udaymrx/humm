import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistController extends StateNotifier<ConcatenatingAudioSource> {
  PlaylistController() : super(ConcatenatingAudioSource(children: []));

  Future<void> addSong(SongModel song) async {
    final source = AudioSource.uri(
      Uri.parse(song.uri!),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: "${song.id}",
        // Metadata to display in the notification:
        album: song.album,
        artist: song.artist ?? "Unknown Artist",
        title: song.displayNameWOExt,
        // artUri: Uri.parse('https://example.com/albumart.jpg'),
      ),
    );
    await state.add(source);
  }

  Future<void> removeSongAt(int index) async {
    await state.removeAt(index);
  }

  Future<void> removeSongRange(int start, int end) async {
    await state.removeRange(start, end);
  }

  Future<void> clearPlaylist() async {
    await state.clear();
  }

  Future<void> addPlaylist(List<SongModel> songsList) async {
    List<AudioSource> songs = [];
    for (var song in songsList) {
      final s = AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: "${song.id}",
          // Metadata to display in the notification:
          album: song.album,
          artist: song.artist ?? "Unknown Artist",
          title: song.displayNameWOExt,
          // artUri: Uri.parse('https://example.com/albumart.jpg'),
        ),
      );
      songs.add(s);
    }

    await state.addAll(songs);
  }

  @override
  void dispose() {
    state.clear();
    super.dispose();
  }
}
