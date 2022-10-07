import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../app/global_provider.dart';

class PlaylistSongListNotifier
    extends StateNotifier<AsyncValue<List<SongEntity>>> {
  PlaylistSongListNotifier(this.ref, {required this.key})
      : super(const AsyncValue.loading()) {
    initList();
  }

  final Ref ref;
  final int key;

  Future<void> initList() async {
    var list = await ref.read(roomProvider).getSongsFormPlaylist(key);

    state = AsyncValue.data(list);
  }
}
