import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class RoomService {
  final OnAudioRoom _audioRoom = OnAudioRoom();

  Future<void> initRoom() async {
    await _audioRoom.initRoom();
  }


  ///Playlist
  ///
  Future<int?> createPlaylist(String name) async {
    return await _audioRoom.createPlaylist(name);
  }

  Future<int?> addToPlaylist(SongModel song) async {
    return await _audioRoom.addTo(
      RoomType.PLAYLIST,
      song.getMap.toFavoritesEntity(),
    );
  }

  Future<List<int>> addAllToPlaylist(List<SongModel> songs) async {
    List<dynamic> entities = [];
    for (var song in songs) {
      entities.add(song.getMap.toFavoritesEntity());
    }
    return await _audioRoom.addAllTo(RoomType.PLAYLIST, entities);
  }

  Future<bool> removeFromPlaylist(int entityKey) async {
    return await _audioRoom.deleteFrom(RoomType.PLAYLIST, entityKey);
  }

  Future<bool> clearPlaylist(List<int> keys) async {
    return await _audioRoom.deleteAllFrom(RoomType.PLAYLIST, keys);
  }

  Future<bool> deletePlaylist(int key) async {
    return await _audioRoom.deletePlaylist(key);
  }


  ///Favourites
  ///
  Future<int?> addToFavourite(SongModel song) async {
    return await _audioRoom.addTo(
      RoomType.FAVORITES,
      song.getMap.toFavoritesEntity(),
    );
  }

  Future<bool> removeFromFavourite(int entityKey) async {
    return await _audioRoom.deleteFrom(RoomType.FAVORITES, entityKey);
  }

  Future<List<FavoritesEntity>> getFavouriteSongs() async {
    return await _audioRoom.queryFavorites();
  }
}
