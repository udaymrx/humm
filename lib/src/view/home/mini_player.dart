import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humm/src/app/global_provider.dart';
import 'package:humm/src/view/songs/song_page.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../app/colors.dart';
import '../../services/music_player_service.dart';
import '../songs/music_tile.dart';

class MiniMusicPlayer extends ConsumerWidget {
  const MiniMusicPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(metaDataProvider);

    return res.when(
      data: (state) {
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as MediaItem;
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, SongPage.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Hero(
                  tag: "Art",
                  child: Container(
                    height: 56,
                    width: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primary,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Consumer(builder: (context, ref, child) {
                        final res =
                            ref.watch(songArtProvider(int.parse(metadata.id)));

                        return res.when(
                          data: (data) {
                            if (data != null) {
                              return Image.memory(data);
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
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'title',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          metadata.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Hero(
                      tag: 'artist',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          metadata.artist!,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.greyStrong),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // SvgPicture.asset(
                //   'assets/images/play3.svg',
                //   // color: AppColors.primary,
                // ),
                Consumer(builder: (context, ref, child) {
                  final res = ref.watch(playerStateProvider);
                  final player = ref.read(playerProvider);

                  ref.listen(playerStateProvider, (previous, next) {
                    next.whenData((value) {
                      if (value.processingState == ProcessingState.completed) {
                        debugPrint("playing completed");
                        player.stop();
                      }
                    });
                  });

                  return res.when(
                    data: (state) {
                      return IconButton(
                        onPressed: () {
                          if (state.playing) {
                            player.pause();
                          } else {
                            player.play();
                          }
                        },
                        icon: Icon(
                          state.playing
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      );
                    },
                    error: (error, st) => const SizedBox(),
                    loading: () => const CircularProgressIndicator(),
                  );
                }),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    final player = ref.read(playerProvider);
                    if (player.hasNext) {
                      player.seekToNext();
                      if (!player.playing) {
                        player.play();
                      }
                    } else {
                      if (player.playing) {
                        player.pause();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("No more song in the queue")));
                    }
                  },
                  child: const Icon(
                    Icons.skip_next_rounded,
                    size: 26,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        );
      },
      error: (error, st) => const SizedBox(),
      loading: () => const SizedBox(),
    );
  }
}
