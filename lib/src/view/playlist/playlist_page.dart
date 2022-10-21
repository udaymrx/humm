import 'dart:developer' as developer;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../../app/colors.dart';
import '../../app/global_provider.dart';
import '../../app/router/router.gr.dart';

class PlaylistPage extends ConsumerStatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends ConsumerState<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('playlist')),
      body: const RawPlayList(),
    );
  }
}

class RawPlayList extends ConsumerStatefulWidget {
  const RawPlayList({super.key});

  @override
  ConsumerState<RawPlayList> createState() => _RawPlayListState();
}

class _RawPlayListState extends ConsumerState<RawPlayList> {
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
                    textCapitalization: TextCapitalization.words,
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
                          onPressed: () => context.popRoute(),
                          child: const Text("Cancel")),
                      const SizedBox(width: 16),
                      ElevatedButton(
                          onPressed: () {
                            context.popRoute(name);
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
    final res = ref.watch(listOfPlaylistProvider);

    return res.when(
        data: (data) {
          if (data.isNotEmpty) {
            developer.log(data.toString());
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      radius: 30,
                      child: Icon(
                        Icons.add_rounded,
                        size: 28,
                      ),
                    ),
                    minLeadingWidth: 60,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    title: const Text(
                      "Add New Playlist",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, letterSpacing: 0.8),
                    ),
                    onTap: () async {
                      final res = await openDialog(context);
                      if (res != null) {
                        final id =
                            await ref.read(roomProvider).createPlaylist(res);
                        if (id != null) {
                          ref.invalidate(listOfPlaylistProvider);
                          if (mounted) {
                            context.router.push(AddSongRoute(id: id));
                          }
                        }
                      }
                    },
                  );
                } else {
                  return PlaylistTile(playlist: data[index - 1]);
                }
              },
              itemCount: data.length + 1,
            );
          } else {
            return Column(
              children: [
                const SizedBox(height: 10),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      Icons.add_rounded,
                      size: 28,
                    ),
                  ),
                  minLeadingWidth: 60,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  title: const Text(
                    "Add New Playlist",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, letterSpacing: 0.8),
                  ),
                  onTap: () async {
                    final res = await openDialog(context);
                    if (res != null) {
                      final id =
                          await ref.read(roomProvider).createPlaylist(res);
                      if (id != null) {
                        ref.invalidate(listOfPlaylistProvider);
                        if (mounted) {
                          context.router.push(AddSongRoute(id: id));
                        }
                      }
                    }
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "No Playlist created,\n Create your first Playlist.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          }
        },
        error: (error, st) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}

class PlaylistTile extends ConsumerWidget {
  const PlaylistTile({super.key, required this.playlist});

  final PlaylistEntity playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        context.router.push(PlaylistSongRoute(id: playlist.key));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.playlistName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${playlist.playlistSongs.length} songs",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<int>(
              elevation: 30,
              position: PopupMenuPosition.under,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  height: 40,
                  onTap: () async {
                    final messanger = ScaffoldMessenger.of(context);
                    final deleted = await ref
                        .read(roomProvider)
                        .deletePlaylist(playlist.key);
                    ref.invalidate(listOfPlaylistProvider);

                    if (deleted) {
                      messanger.showSnackBar(
                        const SnackBar(
                          content: Text("Playlist Deleted!"),
                        ),
                      );
                    } else {
                      messanger.showSnackBar(
                        const SnackBar(
                          content: Text("Playlist could not be Deleted!"),
                        ),
                      );
                    }
                  },
                  child: const Text("Delete Playlist"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
