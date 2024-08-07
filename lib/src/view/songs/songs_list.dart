import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/global_provider.dart';
import 'package:humm/src/view/songs/music_tile.dart';

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
          data: (songsList) {
            if (songsList.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (cnxt, index) {
                  return InkWell(
                    onTap: () async {
                      final player = ref.read(playerProvider);
                      final queueHashcode = ref.read(queueHashcodeProvider);
                      print("hash:: $queueHashcode ,${songsList.hashCode}");

                      if (queueHashcode == null) {
                        print("initialising source");

                        await ref
                            .read(queueController.notifier)
                            .setQueue(songsList);

                        ref.read(queueHashcodeProvider.notifier).state =
                            songsList.hashCode;

                        print("avail indices: ${player.effectiveIndices}");
                        print("seeking to $index");

                        await player.seek(Duration.zero, index: index);

                        print("seeked to $index");

                        ref.read(musicQueuedProvider.state).state = true;

                        await player.play();
                      } else {
                        if (queueHashcode != songsList.hashCode) {
                          print("changing source");
                          await ref.read(queueController.notifier).clearQueue();

                          await ref
                              .read(queueController.notifier)
                              .setQueue(songsList);

                          ref.read(queueHashcodeProvider.notifier).state =
                              songsList.hashCode;

                          await player.seek(Duration.zero, index: index);

                          ref.read(musicQueuedProvider.notifier).state = true;

                          if (!player.playing) {
                            await player.play();
                          }
                        } else {
                          print(" source exisit");

                          await player.seek(Duration.zero, index: index);
                          if (!player.playing) {
                            await player.play();
                          }
                        }
                      }
                    },
                    child: MusicTile(
                      song: songsList[index],
                    ),
                  );
                },
                itemCount: songsList.length,
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
