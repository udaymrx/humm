import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:humm/src/data/model/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../app/global_provider.dart';

class SongListNotifier extends StateNotifier<AsyncValue<List<SongModel>>> {
  SongListNotifier(this._reader) : super(const AsyncValue.loading()) {
    initList();
  }

  final Reader _reader;

  Future<void> initList() async {
    var list = await _reader(audioQueryProvider).getSongs();

    final songlist = list.where((element) => element.isMusic!).toList();
    developer.log(songlist.toString());
    // List<SongModel> musicList = [];

    // for (var element in songlist) {
    //   final music = SongModel.fromJson(
    //       element.getMap.map((key, value) => MapEntry(key, value)));
    //   musicList.add(music);
    // }

    state = AsyncValue.data(songlist);
  }

  // void enableFavorite(int id) {
  //   final lst = state.asData!.value;

  //   final index = lst.indexWhere((element) => element.id == id);
  //   final music = lst.firstWhere((element) => element.id == id);
  //   lst[index] = music.copyWith(isFavorite: true);

  //   state = AsyncValue.data(lst);
  // }

  // void disableFavorite(int id) {
  //   final lst = state.asData!.value;

  //   final index = lst.indexWhere((element) => element.id == id);
  //   final music = lst.firstWhere((element) => element.id == id);
  //   lst[index] = music.copyWith(isFavorite: false);

  //   state = AsyncValue.data(lst);
  // }
}
