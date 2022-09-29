import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/view/playlist/add_song_page.dart';
import 'package:humm/src/view/playlist/playlist_song_page.dart';

import '../../app/global_provider.dart';

// final rawPlaylist2Provider = FutureProvider<List<String>>((ref) async {
//   final audioService = ref.read(playlistBoxProvider);
//   return audioService.playlistList;
// });

class PlaylistPage extends ConsumerStatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends ConsumerState<PlaylistPage> {
  Future<String?> openDialog(BuildContext context) async {
    String? name;
    final result = await showDialog<String?>(
        context: context,
        builder: (contxt) {
          return Dialog(
            insetPadding: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      name = value;
                    },
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Name of the Playlist"),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel")),
                      const SizedBox(width: 16),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, name);
                          },
                          child: const Text("Ok")),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('playlist')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            OutlinedButton(
              onPressed: () async {
                final res = await openDialog(context);
                if (res != null) {
                  final id = await ref.read(roomProvider).createPlaylist(res);
                  if (id != null) {
                    ref.invalidate(listOfPlaylistProvider);
                    if (mounted) {
                      Navigator.pushNamed(context, AddSongPage.routeName,
                          arguments: id);
                    }
                  }
                }
              },
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.maxFinite, 50)),
              child: const Text("Create Playlist"),
            ),
            const Expanded(child: RawPlayList()),
          ],
        ),
      ),
    );
  }
}

class RawPlayList extends ConsumerStatefulWidget {
  const RawPlayList({super.key});

  @override
  ConsumerState<RawPlayList> createState() => _RawPlayListState();
}

class _RawPlayListState extends ConsumerState<RawPlayList> {
  @override
  Widget build(BuildContext context) {
    final res = ref.watch(listOfPlaylistProvider);

    return res.when(
        data: (data) {
          if (data.isNotEmpty) {
            developer.log(data.toString());
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, PlaylistSongPage.routeName,
                        arguments: data[index].key);
                  },
                  title: Text(data[index].playlistName),
                  subtitle: Text("${data[index].playlistSongs.length} songs"),
                  trailing: IconButton(
                      onPressed: () async {
                        final deleted = await ref
                            .read(roomProvider)
                            .deletePlaylist(data[index].key);
                        ref.invalidate(listOfPlaylistProvider);

                        if (deleted) {
                          if (mounted) {
                            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                              const SnackBar(
                                content: Text("Playlist Deleted!"),
                              ),
                            );
                          }
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                              const SnackBar(
                                content: Text("Playlist could not be Deleted!"),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.more_vert)),
                );
              },
              itemCount: data.length,
            );
          } else {
            return const Center(
              child: Text(
                "No Playlist created,\n Create your first Playlist.",
                textAlign: TextAlign.center,
              ),
            );
          }
        },
        error: (error, st) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
