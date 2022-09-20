import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../app/global_provider.dart';
import '../data/model/music_model.dart';

class FavoutiteSongListNotifier
    extends StateNotifier<AsyncValue<List<MusicModel>>> {
  FavoutiteSongListNotifier(this._reader) : super(const AsyncValue.loading()) {
    initList();
  }

  final Reader _reader;

  Future<void> initList() async {
    var list = await _reader(favoriteBoxProvider).favoriteSongs;

    state = AsyncValue.data(list);
  }
}
