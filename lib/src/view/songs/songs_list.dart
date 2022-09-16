import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/global_provider.dart';
import 'package:humm/src/services/music_player_service.dart';
import 'package:humm/src/view/songs/music_tile.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'song_page.dart';

final songsProvider = FutureProvider<List<SongModel>>((ref) async {
  final audioService = ref.read(audioQueryProvider);

  return audioService.getSongs();
});

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
        final res = ref.watch(songsProvider);
        return res.when(
          data: (data) {
            if (data.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (cnxt, index) {
                  return InkWell(
                    onTap: () async {
                      final player = ref.read(playerProvider);
                      if (player.audioSource == null) {
                        debugPrint("hi");
                        await ref
                            .read(playerProvider.notifier)
                            .initSource(data);
                      } else {
                        debugPrint('hello');
                      }
                      player.seek(Duration.zero, index: index);
                      player.play();
                      if (!mounted) return;
                      Navigator.pushNamed(context, SongPage.routeName);
                    },
                    child: MusicTile(
                      song: data[index],
                    ),
                  );
                },
                itemCount: data.length,
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
