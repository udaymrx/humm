// import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../app/global_provider.dart';

class FavoutiteSongListNotifier
    extends StateNotifier<AsyncValue<List<FavoritesEntity>>> {
  FavoutiteSongListNotifier(this.ref) : super(const AsyncValue.loading()) {
    initList();
  }

  final Ref ref;

  Future<void> initList() async {
    var list = await ref.read(roomProvider).getFavouriteSongs();
    // developer.log(list.toString());

    state = AsyncValue.data(list);
  }
}
