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
        title: Text(artist),
      ),
      body: ArtistSongsList(artist: artist),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // final lst = ref.read(albumFilterSongProvider(album));
        },
        child: const Icon(
          Icons.play_arrow_rounded,
        ),
      ),
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

                await ref.read(playlistController.notifier).setQueue(songsList);

                ref.read(queueHashcodeProvider.state).state =
                    songsList.hashCode;

                await player.seek(Duration.zero, index: index);

                ref.read(musicQueuedProvider.state).state = true;

                await player.play();
              } else {
                if (queueHashcode != songsList.hashCode) {
                  print("changing source");
                  await ref.read(playlistController.notifier).clearPlaylist();

                  await ref
                      .read(playlistController.notifier)
                      .setQueue(songsList);

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
