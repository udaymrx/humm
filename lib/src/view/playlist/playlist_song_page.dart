import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/view/playlist/playlist_song_tile.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../../app/global_provider.dart';

final playlistInfoProvider =
    FutureProvider.family<PlaylistEntity?, int>((ref, id) async {
  final output = await ref.read(roomProvider).getPlaylistInfo(id);
  return output;
});

class PlaylistSongPage extends ConsumerWidget {
  const PlaylistSongPage({Key? key, required this.id}) : super(key: key);

  static const routeName = '/playlist_song';

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Consumer(builder: (context, ref, child) {
        final res = ref.watch(playlistInfoProvider(id));
        return res.when(
          data: (data) {
            return data != null ? Text(data.playlistName) : const Text("Unkown Playlist");
          },
          error: (error, stackTrace) => const Text("Unkown Playlist"),
          loading: () => const Text("Loading..."),
        );
      })),
      body: PlaylistSongList(
        id: id,
      ),
    );
  }
}

class PlaylistSongList extends StatefulWidget {
  const PlaylistSongList({super.key, required this.id});

  final int id;

  @override
  State<PlaylistSongList> createState() => _PlaylistSongListState();
}

class _PlaylistSongListState extends State<PlaylistSongList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final res = ref.watch(songsOfPlaylistProvider(widget.id));
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
                            .setPlaylistQueue(songsList);

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
                          await ref
                              .read(queueController.notifier)
                              .clearPlaylist();

                          await ref
                              .read(queueController.notifier)
                              .setPlaylistQueue(songsList);

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
                    child: PlaylistSongTile(
                      song: songsList[index],
                    ),
                  );
                },
                itemCount: songsList.length,
              );
            } else {
              return const Center(child: Text("No Songs in this Playlist"));
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
