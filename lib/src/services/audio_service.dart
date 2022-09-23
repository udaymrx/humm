import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioQueryService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<bool> requestPermission() async {
    bool permissionStatus = false;

    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        permissionStatus = await _audioQuery.permissionsRequest();
      }
    }
    return permissionStatus;
  }

  Future<bool> checkPermission() async {
    return await _audioQuery.permissionsStatus();
  }

  Future<List<SongModel>> getSongs() async {
    return await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
    );
  }

  Future<List<SongModel>> getaSongs() async {
    return await _audioQuery.querySongs();
  }

  Future<List<AlbumModel>> getAlbums() async {
    return await _audioQuery.queryAlbums();
  }

  Future<List<ArtistModel>> getArtists() async {
    return await _audioQuery.queryArtists();
  }

  Future<Uint8List?> getSongArt(int id) async {
    var uint8list = await _audioQuery.queryArtwork(id, ArtworkType.AUDIO);
    return uint8list;
  }

  Future<Uint8List?> getAlbumArt(int id) async {
    var uint8list = await _audioQuery.queryArtwork(id, ArtworkType.ALBUM);
    return uint8list;
  }

  Future<Uint8List?> getArtistArt(int id) async {
    var uint8list = await _audioQuery.queryArtwork(id, ArtworkType.ARTIST);
    return uint8list;
  }

  Future<Uint8List?> getPlaylistArt(int id) async {
    var uint8list = await _audioQuery.queryArtwork(id, ArtworkType.PLAYLIST);
    return uint8list;
  }

  Future<List<String>> getFoldersPath() async {
    var paths = await _audioQuery.queryAllPath();
    return paths;
  }

  Future<List<SongModel>> getFolderSongs(String path) async {
    var val = await _audioQuery.querySongs(path: path);
    return val;
  }
}
