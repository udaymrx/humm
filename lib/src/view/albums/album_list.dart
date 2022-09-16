import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/view/albums/album_tile.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../app/global_provider.dart';

final artistsProvider = FutureProvider<List<AlbumModel>>((ref) async {
  final audioService = ref.read(audioQueryProvider);
  return audioService.getAlbums();
});

class AlbumList extends ConsumerWidget {
  const AlbumList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(artistsProvider);
    return res.when(
        data: (data) {
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              return AlbumTile(
                album: data[index],
              );
            },
            itemCount: data.length,
          );
        },
        error: (error, st) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
