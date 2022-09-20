import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:humm/src/data/model/music_model.dart';

class FavoriteBox {
  static const _favoriteBoxName = 'Favorite';

  Future<Box<MusicModel>> openFavoriteBox() async {
    final Box<MusicModel> box =
        await Hive.openBox<MusicModel>(_favoriteBoxName);
    return box;
  }

  Box<MusicModel> favoriteBox() {
    final Box<MusicModel> box = Hive.box<MusicModel>(_favoriteBoxName);
    return box;
  }

  Future<void> addFavorite(MusicModel favorite) async {
    final box = await openFavoriteBox();
    await box.put(favorite.id, favorite);
  }

  Future<void> removeFavorite(int key) async {
    final box = await openFavoriteBox();
    await box.delete(key);
  }

  Future<List<MusicModel>> get favoriteSongs async {
    final box = await openFavoriteBox();
    final value = box.values.toList();
    return value;
  }

  Future<List<int>> get favoriteSongsKeys async {
    final box = await openFavoriteBox();
    final value = box.keys.cast<int>().toList();
    return value;
  }

  Future<void> deleteFavorite() async {
    final box = favoriteBox();
    await box.clear();
  }

  Future<void> closeFavorite() async {
    final box = favoriteBox();
    await box.close();
  }
}
