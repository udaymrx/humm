import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/global_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class QueueController extends StateNotifier<ConcatenatingAudioSource> {
  QueueController(this.ref) : super(ConcatenatingAudioSource(children: []));

  final Ref ref;

  Future<void> setQueue(List<SongModel> songsList) async {
    List<AudioSource> songs = [];
    for (var song in songsList) {
      final s = AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: "${song.id}",
          // Metadata to display in the notification:
          duration: Duration(milliseconds: song.duration ?? 0),
          album: song.album,
          artist: song.artist == "<unknown>" ? "Unknown Artist" : song.artist,
          title: song.title,
          // artUri: Uri.parse('https://example.com/albumart.jpg'),
        ),
      );
      songs.add(s);
    }

    await state.addAll(songs);

    await ref.read(playerProvider).setAudioSource(state);
  }

  Future<void> setFavoriteQueue(List<FavoritesEntity> songsList) async {
    List<AudioSource> songs = [];
    for (var song in songsList) {
      final s = AudioSource.uri(
        Uri.parse(song.lastData),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: "${song.id}",
          // Metadata to display in the notification:
          duration: Duration(milliseconds: song.duration ?? 0),
          album: song.album,
          artist: song.artist == "<unknown>" ? "Unknown Artist" : song.artist,
          title: song.title,
          // artUri: Uri.parse('https://example.com/albumart.jpg'),
        ),
      );
      songs.add(s);
    }

    await state.addAll(songs);

    await ref.read(playerProvider).setAudioSource(state);
  }

  Future<void> setPlaylistQueue(List<SongEntity> songsList) async {
    List<AudioSource> songs = [];
    for (var song in songsList) {
      final s = AudioSource.uri(
        Uri.parse(song.lastData),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: "${song.id}",
          // Metadata to display in the notification:
          duration: Duration(milliseconds: song.duration ?? 0),
          album: song.album,
          artist: song.artist == "<unknown>" ? "Unknown Artist" : song.artist,
          title: song.title,
          // artUri: Uri.parse('https://example.com/albumart.jpg'),
        ),
      );
      songs.add(s);
    }

    await state.addAll(songs);

    await ref.read(playerProvider).setAudioSource(state);
  }

  // Future<void> addSong(SongModel song) async {
  //   final source = AudioSource.uri(
  //     Uri.parse(song.uri!),
  //     tag: MediaItem(
  //       // Specify a unique ID for each media item:
  //       id: "${song.id}",
  //       // Metadata to display in the notification:
  //       album: song.album,
  //       artist: song.artist ?? "Unknown Artist",
  //       title: song.displayNameWOExt,
  //       // artUri: Uri.parse('https://example.com/albumart.jpg'),
  //     ),
  //   );
  //   await state.add(source);
  // }

  // Future<void> removeSongAt(int index) async {
  //   await state.removeAt(index);
  // }

  // Future<void> removeSongRange(int start, int end) async {
  //   await state.removeRange(start, end);
  // }

  Future<void> clearKeepSingle() async {
    final index = ref.read(playerProvider).currentIndex!;
    var noOfSongs = state.length;
    print("currentIndex: $index, no. of Songs: $noOfSongs");
    print("last: ${noOfSongs - 1}");
    if (index == 0) {
      await state.removeRange(1, noOfSongs);
    } else if (index == (noOfSongs - 1)) {
      await state.removeRange(0, noOfSongs - 1);
    } else {
      await state.removeRange(index + 1, noOfSongs);
      await state.removeRange(0, index);
    }
  }

  Future<void> clearQueue() async {
    await state.clear();
  }

  Future<void> dumpQueue() async {
    await state.clear();
    ref.read(playerProvider).stop(); // Can be awaited
    ref.read(queueHashcodeProvider.state).state = null;
  }

  // Future<void> addPlaylist(List<SongModel> songsList) async {
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

  //   await state.addAll(songs);
  // }

  @override
  void dispose() {
    state.clear();
    super.dispose();
  }
}
