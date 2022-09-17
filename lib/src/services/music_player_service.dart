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
