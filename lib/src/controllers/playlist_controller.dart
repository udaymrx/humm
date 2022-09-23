import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../app/global_provider.dart';

class PlaylistSongListNotifier
    extends StateNotifier<AsyncValue<List<SongEntity>>> {
  PlaylistSongListNotifier(this._reader, {required this.key})
      : super(const AsyncValue.loading()) {
    initList();
  }

  final Reader _reader;
  final int key;

  Future<void> initList() async {
    var list = await _reader(roomProvider).getSongsFormPlaylist(key);

    state = AsyncValue.data(list);
  }
}
