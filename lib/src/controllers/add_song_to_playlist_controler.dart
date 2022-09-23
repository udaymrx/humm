import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsToAddNotifier extends ChangeNotifier {
  bool _isNotEmpty = false;

  bool get isNotEmpty => _isNotEmpty;

  final List<SongModel> _state = [];

  List<SongModel> get state => _state;

  void addSong(SongModel song) {
    _state.add(song);
    _isNotEmpty = true;

    notifyListeners();
  }

  void removeSong(int id) {
    _state.removeWhere((element) => element.id == id);

    if (_state.isEmpty) {
      _isNotEmpty = false;
    }

    notifyListeners();
  }
}
