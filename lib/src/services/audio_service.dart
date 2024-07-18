import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:humm/src/services/shared_preferences.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart' as p;

class AudioQueryService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<bool> requestPermission() async {
    return await _audioQuery.checkAndRequest();
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
    var uint8list = await _audioQuery.queryArtwork(
      id,
      ArtworkType.AUDIO,
      format: ArtworkFormat.PNG,
      size: 400,
    );
    if (uint8list != null) {
      await setSongArtToFile(id, uint8list);
    }
    return uint8list;
  }

  Future<void> setSongArtToFile(int id, Uint8List songData) async {
    try {
      // Get the application documents directory
      final tempPath = UserPreferences.appPath;

      // Create a directory for song artwork if it doesn't exist
      final directoryPath = p.join(tempPath, 'SongArt');
      await Directory(directoryPath).create(recursive: true);

      // Construct the file path
      final filePath = p.join(directoryPath, '$id.png');

      // Check if the file already exists before writing
      if (!await File(filePath).exists()) {
        // Write song artwork data to the file
        await File(filePath).writeAsBytes(songData);
        debugPrint('Song artwork saved to: $filePath');
      } else {
        debugPrint('File already exists: $filePath');
      }
    } catch (e) {
      // Handle error gracefully, e.g., log it or notify the user
      debugPrint('Error saving song artwork: $e');
    }
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
