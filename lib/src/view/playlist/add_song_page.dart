import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/global_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../app/colors.dart';

final songcheckProvider =
    StateProvider.autoDispose.family<bool, int>((ref, id) {
  return false;
});

class AddSongPage extends ConsumerStatefulWidget {
  const AddSongPage({Key? key, required this.id}) : super(key: key);

  static const routeName = '/add_song';

  final int id;

  @override
  ConsumerState<AddSongPage> createState() => _AddSongPageState();
}

class _AddSongPageState extends ConsumerState<AddSongPage> {
  Future<void> submit() async {
    final songlst = ref.read(songsToAddProvider).state;
    final lst = await ref
        .read(roomProvider)
        .addAllToPlaylist(songs: songlst, playlistKey: widget.id);
    ref.invalidate(listOfPlaylistProvider);
    if (mounted) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text("${lst.length} songs added to the Playlist")));
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Songs"),
        actions: [
          Consumer(builder: (context, ref, child) {
            final isNotEmpty = ref
                .watch(songsToAddProvider.select((value) => value.isNotEmpty));
            return isNotEmpty
                ? IconButton(
                    onPressed: submit,
                    icon: const Icon(Icons.check),
                  )
                : const SizedBox();
          }),
        ],
      ),
      body: const SongsToAddList(),
    );
  }
}

class SongsToAddList extends ConsumerWidget {
  const SongsToAddList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(allSongProvider);
    return res.when(
      data: (data) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return SongCheckWidget(song: data[index]);
          },
          itemCount: data.length,
        );
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class SongCheckWidget extends ConsumerWidget {
  const SongCheckWidget({Key? key, required this.song}) : super(key: key);

  final SongModel song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songcheckProvider(song.id));
    return CheckboxListTile(
      value: state,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(song.title),
      secondary: Container(
        height: 70,
        width: 70,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.primary,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Consumer(builder: (context, ref, child) {
            final res = ref.watch(songArtProvider(song.id));
            return res.when(
              data: (data) {
                if (data != null) {
                  return FittedBox(
                    fit: BoxFit.cover,
                    child: Image.memory(data),
                  );
                } else {
                  return const Icon(
                    Icons.music_note,
                    size: 30,
                    color: AppColors.white,
                  );
                }
              },
              error: (e, s) => const Icon(
                Icons.music_note,
                color: AppColors.white,
                size: 30,
              ),
              loading: () => const Icon(
                Icons.music_note,
                size: 30,
                color: AppColors.white,
              ),
            );
          }),
        ),
      ),
      subtitle:
          Text(song.artist == "<unknown>" ? "Unknown Artist" : song.artist!),
      onChanged: (newState) {
        if (newState != null) {
          if (newState) {
            ref.read(songcheckProvider(song.id).state).state = newState;
            ref.read(songsToAddProvider.notifier).addSong(song);
          } else {
            ref.read(songcheckProvider(song.id).state).state = newState;
            ref.read(songsToAddProvider.notifier).removeSong(song.id);
          }
        }
      },
    );
  }
}
