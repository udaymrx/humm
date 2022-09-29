import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/global_provider.dart';
import 'package:humm/src/view/favorites/favorite_tile.dart';

class FavoritePage extends ConsumerWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite")),
      body: const FavoriteList(),
    );
  }
}

class FavoriteList extends StatefulWidget {
  const FavoriteList({super.key});

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final res = ref.watch(favoriteSongProvider);
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
                            .setFavoriteQueue(songsList);

                        ref.read(queueHashcodeProvider.state).state =
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
                              .setFavoriteQueue(songsList);

                          ref.read(queueHashcodeProvider.state).state =
                              songsList.hashCode;

                          await player.seek(Duration.zero, index: index);

                          ref.read(musicQueuedProvider.state).state = true;

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
                    child: FavoriteTile(
                      song: songsList[index],
                    ),
                  );
                },
                itemCount: songsList.length,
              );
            } else {
              return const Center(child: Text("No Favorite Songs"));
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
