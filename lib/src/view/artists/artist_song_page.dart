import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/global_provider.dart';

import '../songs/music_tile.dart';

class ArtistPage extends ConsumerWidget {
  const ArtistPage({Key? key, required this.artist}) : super(key: key);

  static const routeName = '/artist';

  final String artist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artist == "<unknown>" ? "Unknown Artist" : artist),
      ),
      body: ArtistSongsList(artist: artist),
    );
  }
}

class ArtistSongsList extends ConsumerWidget {
  const ArtistSongsList({super.key, required this.artist});

  final String artist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsList = ref.watch(artistFilterSongProvider(artist));
    if (songsList.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              final player = ref.read(playerProvider);
              final queueHashcode = ref.read(queueHashcodeProvider);
              print("hash:: $queueHashcode ,${songsList.hashCode}");
              print("hi");

              if (queueHashcode == null) {
                print("initialising source");

                await ref.read(queueController.notifier).setQueue(songsList);

                ref.read(queueHashcodeProvider.state).state =
                    songsList.hashCode;

                await player.seek(Duration.zero, index: index);

                ref.read(musicQueuedProvider.state).state = true;

                await player.play();
              } else {
                if (queueHashcode != songsList.hashCode) {
                  print("changing source");
                  await ref.read(queueController.notifier).clearQueue();

                  await ref.read(queueController.notifier).setQueue(songsList);

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
            child: MusicTile(
              song: songsList[index],
            ),
          );
        },
        itemCount: songsList.length,
      );
    } else {
      return const Center(child: Text("No Songs here !"));
    }
  }
}
