// import 'package:humm/src/data/model/music_model.dart';
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

  Future<int?> addToPlaylist(
      {required SongModel song, required int playlistKey}) async {
    return await _audioRoom.addTo(
      RoomType.PLAYLIST,
      playlistKey: playlistKey,
      song.getMap.toSongEntity(),
    );
  }

  Future<List<int>> addAllToPlaylist(
      {required List<SongModel> songs, required int playlistKey}) async {
    List<SongEntity> entities = [];
    for (var song in songs) {
      entities.add(song.getMap.toSongEntity());
    }
    return await _audioRoom.addAllTo(
      RoomType.PLAYLIST,
      playlistKey: playlistKey,
      entities,
    );
  }

  Future<bool> removeFromPlaylist(
      {required int entityKey, required int playlistKey}) async {
    return await _audioRoom.deleteFrom(
      RoomType.PLAYLIST,
      playlistKey: playlistKey,
      entityKey,
    );
  }

  Future<bool> clearPlaylist(
      {required List<int> keys, required int playlistKey}) async {
    return await _audioRoom.deleteAllFrom(
      RoomType.PLAYLIST,
      playlistKey: playlistKey,
      keys,
    );
  }

  Future<bool> deletePlaylist(int key) async {
    return await _audioRoom.deletePlaylist(key);
  }

  Future<bool> deleteAllPlaylist(int key) async {
    return await _audioRoom.clearPlaylists();
  }

  Future<List<PlaylistEntity>> getPlaylists() async {
    return await _audioRoom.queryPlaylists();
  }

  Future<PlaylistEntity?> getPlaylistInfo(int key) async {
    return await _audioRoom.queryPlaylist(key);
  }

  Future<List<SongEntity>> getSongsFormPlaylist(
    int playlistKey,
  ) async {
    return await _audioRoom.queryAllFromPlaylist(
      playlistKey,
      sortType: RoomSortType.DATE_ADDED,
    );
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

  Future<bool> isSongFavorite(int entityKey) async {
    return await _audioRoom.checkIn(RoomType.FAVORITES, entityKey);
  }
}
