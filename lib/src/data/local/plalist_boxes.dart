import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:humm/src/data/model/music_model.dart';
import 'package:humm/src/data/model/playlist_info_model.dart';

class PlaylistBox {
  static const _playlistBoxName = 'List_of_playlist';

  Future<Box<MusicModel>> createPlaylist(String name) async {
    final Box<MusicModel> box = await Hive.openBox<MusicModel>(name);
    return box;
  }

  Future<Box<MusicModel>> getPlaylistInstance(String name) async {
    final Box<MusicModel> box = Hive.box<MusicModel>(name);
    return box;
  }

  Future<Box<String>> addPlaylists(String name) async {
    final Box<String> box = await Hive.openBox<String>(name);
    return box;
  }

  Future<Box<String>> openPlaylistListBox() async {
    final Box<String> box = await Hive.openBox<String>(_playlistBoxName);
    return box;
  }

  Box<String> playlistListBox() {
    final Box<String> box = Hive.box<String>(_playlistBoxName);
    return box;
  }

  Future<Box<MusicModel>> addPlaylist(String playlist) async {
    final box = await openPlaylistListBox();
    await box.put(playlist, playlist);
    return createPlaylist(playlist);
  }

  Future<void> addSongInPlaylist(
      {required MusicModel song, required String playlistName}) async {
    final perPlayBox = await createPlaylist(playlistName);
    await perPlayBox.put(song.id, song);
  }

  Future<void> addMultitpleSongInPlaylist(
      {required List<MusicModel> songs, required String playlistName}) async {
    final perPlayBox = await createPlaylist(playlistName);
    for (var song in songs) {
      await perPlayBox.put(song.id, song);
    }
  }

  Future<void> removeFromPlaylist(
      {required int key, required String playlistName}) async {
    final perPlayBox = await createPlaylist(playlistName);
    await perPlayBox.delete(key);
  }

  Future<void> clearPlaylist(String key) async {
    final playListbox = await getPlaylistInstance(key);
    await playListbox.clear();
  }

  Future<void> removePlaylist(String key) async {
    final box = await openPlaylistListBox();
    final playListbox = await getPlaylistInstance(key);
    playListbox.clear();
    await box.delete(key);
  }

  Future<List<MusicModel>> getPlaylistSongs(String name) async {
    final perPlayBox = await createPlaylist(name);
    final value = perPlayBox.values.toList();
    return value;
  }

  Future<List<PlaylistInfoModel>> getPlaylistInfo() async {
    List<PlaylistInfoModel> plylistsInfo = [];
    final box = playlistListBox();
    final values = box.values.toList();

    for (var item in values) {
      final perPlayBox = await createPlaylist(item);
      final len = perPlayBox.length;
      plylistsInfo.add(PlaylistInfoModel(playlistName: item, noOfSongs: len));
    }
    return plylistsInfo;
  }

  List<String> get playlistList {
    final box = playlistListBox();
    final value = box.values.toList();
    return value;
  }

  Future<void> deleteplaylistList() async {
    final box = playlistListBox();
    await box.clear();
  }

  Future<void> closeplaylistList() async {
    final box = playlistListBox();
    await box.close();
  }
}
