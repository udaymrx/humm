import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/data/model/music_model.dart';
// import 'package:on_audio_query/on_audio_query.dart';

import '../app/global_provider.dart';

class SongListNotifier extends StateNotifier<AsyncValue<List<MusicModel>>> {
  SongListNotifier(this._reader) : super(const AsyncValue.loading()) {
    initList();
  }

  final Reader _reader;

  Future<void> initList() async {
    var list = await _reader(audioQueryProvider).getSongs();

    final songlist = list.where((element) => element.isMusic!).toList();
    List<MusicModel> musicList = [];

    for (var element in songlist) {
      final music = MusicModel.fromJson(
          element.getMap.map((key, value) => MapEntry(key, value)));
      musicList.add(music);
    }

    state = AsyncValue.data(musicList);
  }

  void enableFavorite(int id) {
    final lst = state.asData!.value;

    final index = lst.indexWhere((element) => element.id == id);
    final music = lst.firstWhere((element) => element.id == id);
    lst[index] = music.copyWith(isFavorite: true);

    state = AsyncValue.data(lst);
  }
  void disableFavorite(int id) {
    final lst = state.asData!.value;

    final index = lst.indexWhere((element) => element.id == id);
    final music = lst.firstWhere((element) => element.id == id);
    lst[index] = music.copyWith(isFavorite: false);

    state = AsyncValue.data(lst);
  }
}
