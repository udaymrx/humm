import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../app/global_provider.dart';

class SongListNotifier extends StateNotifier<AsyncValue<List<SongModel>>> {
  SongListNotifier(this._reader) : super(const AsyncValue.loading()) {
    initList();
  }

  final Reader _reader;

  Future<void> initList() async {
    var list = await _reader(audioQueryProvider).getSongs();

    state = AsyncValue.data(list);
  }
}
