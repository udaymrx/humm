import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/global_provider.dart';

import '../songs/music_tile.dart';

class AlbumPage extends ConsumerWidget {
  const AlbumPage({Key? key, required this.album}) : super(key: key);

  static const routeName = '/album';

  final String album;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album),
      ),
      body: AlbumSongsList(album: album),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // final lst = ref.read(albumFilterSongProvider(album));
        },
        child: Icon(
          Icons.play_arrow_rounded,
        ),
      ),
    );
  }
}

class AlbumSongsList extends ConsumerWidget {
  const AlbumSongsList({super.key, required this.album});

  final String album;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsList = ref.watch(albumFilterSongProvider(album));
    if (songsList.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              final player = ref.read(playerProvider);

              await ref
                  .read(playlistController.notifier)
                  .addSong(songsList[index]);
              await player.seek(Duration.zero, index: index);
              if (!player.playing) {
                player.play();
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
