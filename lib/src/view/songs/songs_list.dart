import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/global_provider.dart';
import 'package:humm/src/view/songs/music_tile.dart';
import 'package:just_audio_background/just_audio_background.dart';

class SongsList extends StatefulWidget {
  const SongsList({super.key});

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final res = ref.watch(allSongProvider);
        ref.listen(playerStateProvider, (previous, next) {
          next.whenData((value) {
            debugPrint(value.processingState.name);
          });
        });

        return res.when(
          data: (data) {
            if (data.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (cnxt, index) {
                  return InkWell(
                    onTap: () async {
                      final player = ref.read(playerProvider);

                      await ref
                          .read(playlistController.notifier)
                          .addSong(data[index]);
                      await player.seek(Duration.zero, index: index);
                      if (!player.playing) {
                        player.play();
                      }
                      // if (player.audioSource!.sequence.isEmpty) {
                      //   // add sources
                      //   print("initialising source");
                      //   var newlist = data.skip(index).toList();
                      //   await ref
                      //       .read(playlistController.notifier)
                      //       .addPlaylist(newlist);
                      //   await player.play();
                      // } else {
                      //   // not added song
                      //   print(" source exisit");
                      //   print("avil indices:  ${player.effectiveIndices}");
                      //   print(
                      //       "contains: ${player.effectiveIndices?.contains(index)}");

                      //   final val = player.sequenceState?.currentSource?.tag
                      //       as MediaItem;
                      //   val.title == data[index].displayNameWOExt;

                      //   if (!(player.effectiveIndices?.contains(index) ??
                      //       false)) {
                      //     print(" song not added");

                      //     await ref
                      //         .read(playlistController.notifier)
                      //         .addSong(data[index]);
                      //     await player.seek(Duration.zero, index: index);
                      //     if (!player.playing) {
                      //       player.play();
                      //     }
                      //   } else {
                      //     print(" replying song");

                      //     // already added song
                      //     await player.seek(Duration.zero, index: index);
                      //     if (!player.playing) {
                      //       player.play();
                      //     }
                      //   }
                      // }
                    },
                    child: MusicTile(
                      song: data[index],
                    ),
                  );
                },
                itemCount: data.length,
              );
            } else {
              return const Center(child: Text("Permission not Granted !"));
            }
          },
          error: (error, st) => Center(child: Text(error.toString())),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
