import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../data/model/posistion_model.dart';
import '../data/model/song_meta_model.dart';

class MusicNotifier extends StateNotifier<AudioPlayer> {
  MusicNotifier() : super(AudioPlayer());

  Future<void> initSource(List<SongModel> songsList) async {
    List<AudioSource> songs = [];
    for (var song in songsList) {
      final s = AudioSource.uri(
        Uri.parse(song.uri!),
        tag: AudioMetadata(
          title: song.displayNameWOExt,
          artist: song.artist ?? "Unknown Artist",
          id: song.id,
        ),
      );
      songs.add(s);
    }

    final playlist = ConcatenatingAudioSource(children: songs);
    await state.setAudioSource(playlist);
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}

final playerProvider = StateNotifierProvider<MusicNotifier, AudioPlayer>((ref) {
  return MusicNotifier();
});

final playingProvider = StreamProvider<bool>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.playingStream));
});

final durationProvider = StreamProvider<Duration?>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.durationStream));
});

final positionProvider = StreamProvider<Duration>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.positionStream));
});

final playerStateProvider = StreamProvider<PlayerState>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.playerStateStream));
});

final remainingProvider = StreamProvider<Duration>((ref) {
  StreamController<Duration> st = StreamController();
  var myStr = st.stream.asBroadcastStream();
  ref.watch(durationProvider.stream).listen((durt) {
    ref.watch(positionProvider.stream).listen((position) {
      var duration = durt ?? Duration.zero;
      Duration remaining = Duration.zero;
      if (duration >= position) {
        remaining = duration - position;
      }
      st.add(remaining);
    });
  });
  return myStr;
});

final dragProvider = StreamProvider<PositionData>((ref) {
  StreamController<PositionData> st = StreamController();
  var myStr = st.stream.asBroadcastStream();
  ref.watch(durationProvider.stream).listen((durt) {
    ref.watch(positionProvider.stream).listen((post) {
      st.add(PositionData(post, durt ?? Duration.zero));
    });
  });
  return myStr;
});

final loopProvider = StreamProvider<LoopMode>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.loopModeStream));
});

final shuffleProvider = StreamProvider<bool>((ref) {
  return ref
      .watch(playerProvider.select((plyr) => plyr.shuffleModeEnabledStream));
});

final metaDataProvider = StreamProvider<SequenceState?>((ref) {
  return ref.watch(playerProvider.select((plyr) => plyr.sequenceStateStream));
});

// class MusicPlayerService {
//   final player = AudioPlayer();

//   Future<void> initPayer(List<String> inp) async {
//     List<AudioSource> songs = [];
//     for (var uri in inp) {
//       final s = AudioSource.uri(Uri.parse(uri));
//       songs.add(s);
//     }

//     final playlist = ConcatenatingAudioSource(children: songs);
//     await player.setAudioSource(playlist);

//     // Show a snackbar whenever reaching the end of an item in the playlist.
//     // player.positionDiscontinuityStream.listen((discontinuity) {
//     //   if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
//     //     _showItemFinished(discontinuity.previousEvent.currentIndex);
//     //   }
//     // });
//     // player.processingStateStream.listen((state) {
//     //   if (state == ProcessingState.completed) {
//     //     _showItemFinished(player.currentIndex);
//     //   }
//     // });
//   }

//   // void _showItemFinished(int? index) {
//   //   if (index == null) return;
//   //   final sequence = player.sequence;
//   //   if (sequence == null) return;
//   //   final source = sequence[index];
//   //   final metadata = source.tag as AudioMetadata;
//   //   _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
//   //     content: Text('Finished playing ${metadata.title}'),
//   //     duration: const Duration(seconds: 1),
//   //   ));
//   // }

// }
