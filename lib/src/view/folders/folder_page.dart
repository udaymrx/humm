import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/view/songs/songs_list.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../app/global_provider.dart';
import '../songs/music_tile.dart';

final folderSongProvider =
    FutureProvider.family<List<SongModel>, String>((ref, path) async {
  return await ref.read(audioQueryProvider).getFolderSongs(path);
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
      // Because Folder song is not loading
      body: SongsList(),
      // body: FolderSongsList(
      //   path: path,
      // ),
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
        data: (data) {
          if (data.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return MusicTile(
                  song: data[index],
                );
              },
              itemCount: data.length,
            );
          } else {
            return const Center(child: Text("Permission not Granted !"));
          }
        },
        error: (error, st) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
