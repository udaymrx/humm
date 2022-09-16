import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/view/artists/artist_tile.dart';
import 'package:humm/src/view/songs/music_tile.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../app/global_provider.dart';
import '../songs/songs_list.dart';

final artistsProvider = FutureProvider<List<ArtistModel>>((ref) async {
  final audioService = ref.read(audioQueryProvider);
  return audioService.getArtists();
});

class ArtistList extends ConsumerWidget {
  const ArtistList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(artistsProvider);
    return res.when(
        data: (data) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return ArtistTile(
                artist: data[index],
              );
            },
            itemCount: data.length,
          );
        },
        error: (error, st) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
