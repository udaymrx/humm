import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/colors.dart';
import 'package:humm/src/app/global_provider.dart';
import 'package:just_audio_background/just_audio_background.dart';

class QueueTile extends StatelessWidget {
  const QueueTile({super.key, required this.song, this.isPlaying = false});

  final MediaItem song;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isPlaying
          ? const Color.fromRGBO(6, 193, 73, 0.1)
          : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 4, 8),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.primary,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Consumer(builder: (context, ref, child) {
                      final res =
                          ref.watch(songArtProvider(int.parse(song.id)));
                      return res.when(
                        data: (data) {
                          if (data != null) {
                            return FittedBox(
                              fit: BoxFit.cover,
                              child: Image.memory(data),
                            );
                          } else {
                            return const Icon(
                              Icons.music_note_rounded,
                              size: 30,
                              color: AppColors.white,
                            );
                          }
                        },
                        error: (e, s) => const Icon(
                          Icons.music_note_rounded,
                          color: AppColors.white,
                          size: 30,
                        ),
                        loading: () => const Icon(
                          Icons.music_note_rounded,
                          size: 30,
                          color: AppColors.white,
                        ),
                      );
                    }),
                    if (isPlaying)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black26,
                          child: const Icon(
                            Icons.pause_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                          child: Text(
                        song.artist == "<unknown>"
                            ? "Unknown Artist"
                            : song.artist!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      const Text(
                        "  |  ",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey,
                        ),
                      ),
                      Text(
                        "${song.duration.toString().substring(2, 7)} mins",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Consumer(builder: (context, ref, child) {
              return IconButton(
                onPressed: () async {
                  // final key = await openBottomSheet(context);
                  // if (key != null) {
                  //   await ref
                  //       .read(roomProvider)
                  //       .addToPlaylist(song: song, playlistKey: key);
                  //   ref.invalidate(listOfPlaylistProvider);
                  // }
                },
                icon: const Icon(Icons.more_vert),
              );
            }),
          ],
        ),
      ),
    );
  }
}
