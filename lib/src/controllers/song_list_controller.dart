import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../app/global_provider.dart';

class SongListNotifier extends StateNotifier<AsyncValue<List<SongModel>>> {
  SongListNotifier(this.ref) : super(const AsyncValue.loading()) {
    initList();
  }

  final Ref ref;

  Future<void> initList() async {
    var list = await ref.read(audioQueryProvider).getSongs();

    final songlist = list.where((element) => element.isMusic!).toList();

    state = AsyncValue.data(songlist);
  }
}
