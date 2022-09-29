import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../app/global_provider.dart';
import '../songs/music_tile.dart';

final folderSongProvider =
    FutureProvider.family<List<SongModel>, String>((ref, path) async {
  final musicList = await ref.read(audioQueryProvider).getFolderSongs(path);

  // for (var element in val) {
  //   final music = MusicModel.fromJson(
  //       element.getMap.map((key, value) => MapEntry(key, value)));
  //   musicList.add(music);
  // }
  return musicList;
});

class FolderPage extends ConsumerWidget {
  const FolderPage({
    Key? key,
    required this.path,
  }) : super(key: key);

  static const routeName = '/folder';

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(path.split('/').last),
      ),
      body: FolderSongsList(path: path),
    );
  }
}

class FolderSongsList extends ConsumerWidget {
  const FolderSongsList({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(folderSongProvider(path));
    return res.when(
        data: (songsList) {
          if (songsList.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    final player = ref.read(playerProvider);
                    final queueHashcode = ref.read(queueHashcodeProvider);

                    if (queueHashcode == null) {
                      print("initialising source");

                      await ref
                          .read(queueController.notifier)
                          .setQueue(songsList);

                      ref.read(queueHashcodeProvider.state).state =
                          songsList.hashCode;

                      await player.seek(Duration.zero, index: index);

                      ref.read(musicQueuedProvider.state).state = true;

                      await player.play();
                    } else {
                      if (queueHashcode != songsList.hashCode) {
                        print("changing source");
                        await ref.read(queueController.notifier).clearQueue();

                        await ref
                            .read(queueController.notifier)
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
            return const Center(child: Text("Permission not Granted !"));
          }
        },
        error: (error, st) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
