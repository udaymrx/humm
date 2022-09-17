import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class PlayerNotifier extends StateNotifier<AudioPlayer> {
  PlayerNotifier() : super(AudioPlayer());

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}
