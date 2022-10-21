import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:humm/src/app/colors.dart';
import 'package:humm/src/app/router/router.gr.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../app/global_provider.dart';

class SongPage extends ConsumerWidget {
  const SongPage({Key? key}) : super(key: key);

  static const routeName = '/song';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    String? swipeDirection;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            int sensitivity = 8;
            if (details.delta.dy > sensitivity) {
              // Down Swipe
              swipeDirection = "Down";
            }
          },
          onVerticalDragEnd: (details) async {
            if (swipeDirection == null) {
              return;
            }
            if (swipeDirection == 'Down') {
              //handle swipe right event
              context.popRoute();
            }
          },
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => context.popRoute(),
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                      ),
                      const Spacer(),
                      Consumer(builder: (context, ref, child) {
                        final themeMode = ref.watch(themeController);

                        return PopupMenuButton<int>(
                          elevation: 30,
                          position: PopupMenuPosition.under,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          icon: SvgPicture.asset(
                            "assets/images/more_circle.svg",
                            color: themeMode == ThemeMode.light
                                ? Colors.grey[800]
                                : AppColors.offWhite,
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              height: 40,
                              onTap: () {
                                context.router.push(const QueueRoute());
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.queue_music_rounded),
                                  SizedBox(width: 12),
                                  Text("Show Queue"),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Consumer(builder: (context, ref, child) {
                          final res = ref.watch(metaDataProvider);

                          return res.when(
                            data: (state) {
                              if (state?.sequence.isEmpty ?? true) {
                                return const SizedBox();
                              }
                              final metadata =
                                  state!.currentSource!.tag as MediaItem;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Hero(
                                      tag: "Art",
                                      child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(36),
                                            color: AppColors.primary,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(36),
                                            child: Consumer(
                                                builder: (context, ref, child) {
                                              final res = ref.watch(
                                                  songArtProvider(
                                                      int.parse(metadata.id)));

                                              return res.when(
                                                data: (data) {
                                                  if (data != null) {
                                                    return FittedBox(
                                                        fit: BoxFit.cover,
                                                        child:
                                                            Image.memory(data));
                                                  } else {
                                                    return const Icon(
                                                      Icons.music_note_rounded,
                                                      size: 120,
                                                      color: AppColors.white,
                                                    );
                                                  }
                                                },
                                                error: (e, s) => const Icon(
                                                  Icons.music_note_rounded,
                                                  color: AppColors.white,
                                                  size: 120,
                                                ),
                                                loading: () => const Icon(
                                                  Icons.music_note_rounded,
                                                  size: 120,
                                                  color: AppColors.white,
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Hero(
                                    tag: "title",
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        metadata.title,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Hero(
                                    tag: "artist",
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        metadata.artist == "<unknown>"
                                            ? "Unknown Artist"
                                            : metadata.artist!,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.greyStrong),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            error: (error, st) => const SizedBox(),
                            loading: () => const CircularProgressIndicator(),
                          );
                        }),
                      ),
                      const Divider(),
                      const SongSeeker(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer(builder: (context, ref, child) {
                            final res = ref.watch(dragProvider);

                            return res.when(
                              data: (data) {
                                var valid =
                                    data.duration.compareTo(data.position) >= 0;
                                return Text(
                                  (valid ? data.position : data.duration)
                                      .toString()
                                      .substring(2, 7),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.greyStrong),
                                );
                              },
                              error: (error, st) => const SizedBox(),
                              loading: () => const CircularProgressIndicator(),
                            );
                          }),
                          Consumer(builder: (context, ref, child) {
                            final res = ref.watch(remainingProvider);
                            return res.when(
                              data: (rem) {
                                return Text(
                                  rem.toString().substring(2, 7),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.greyStrong),
                                );
                              },
                              error: (error, st) => const SizedBox(),
                              loading: () => const CircularProgressIndicator(),
                            );
                          }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Consumer(builder: (context, ref, child) {
                            final res = ref.watch(shuffleProvider);

                            return res.when(
                              data: (shuffleModeEnabled) {
                                return IconButton(
                                  onPressed: () async {
                                    final enable = !shuffleModeEnabled;
                                    if (enable) {
                                      await player.shuffle();
                                    }
                                    await player.setShuffleModeEnabled(enable);
                                  },
                                  icon: Icon(
                                    Icons.shuffle_rounded,
                                    color: shuffleModeEnabled
                                        ? AppColors.primary
                                        : AppColors.grey,
                                  ),
                                );
                              },
                              error: (error, st) => const SizedBox(),
                              loading: () => const CircularProgressIndicator(),
                            );
                          }),
                          IconButton(
                            onPressed: () {
                              if (player.hasPrevious) {
                                player.seekToPrevious();
                                if (!player.playing) {
                                  player.play();
                                }
                              } else {
                                player.seek(Duration.zero);
                                if (!player.playing) {
                                  player.play();
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 30,
                            ),
                          ),
                          Consumer(builder: (context, ref, child) {
                            final res = ref.watch(playerStateProvider);

                            ref.listen(playerStateProvider, (previous, next) {
                              next.whenData((value) {
                                // debugPrint(value.processingState.name);
                                if (value.processingState ==
                                    ProcessingState.completed) {
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
                                    size: 70,
                                    color: AppColors.primary,
                                  ),
                                );
                              },
                              error: (error, st) => const SizedBox(),
                              loading: () => const CircularProgressIndicator(),
                            );
                          }),
                          IconButton(
                            onPressed: () {
                              if (player.hasNext) {
                                player.seekToNext();
                                if (!player.playing) {
                                  player.play();
                                }
                              } else {
                                if (player.playing) {
                                  player.pause();
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("No more song in the queue")));
                              }
                            },
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              size: 30,
                            ),
                          ),
                          Consumer(builder: (context, ref, child) {
                            final res = ref.watch(loopProvider);

                            return res.when(
                              data: (loopMode) {
                                return IconButton(
                                  onPressed: () {
                                    switch (loopMode) {
                                      case LoopMode.off:
                                        player.setLoopMode(LoopMode.all);
                                        break;
                                      case LoopMode.all:
                                        player.setLoopMode(LoopMode.one);
                                        break;
                                      case LoopMode.one:
                                        player.setLoopMode(LoopMode.off);
                                        break;
                                      default:
                                    }
                                  },
                                  icon: Icon(
                                    loopMode == LoopMode.off
                                        ? Icons.repeat_rounded
                                        : loopMode == LoopMode.all
                                            ? Icons.repeat_rounded
                                            : Icons.repeat_one_rounded,
                                    color: loopMode == LoopMode.off
                                        ? AppColors.grey
                                        : AppColors.primary,
                                  ),
                                );
                              },
                              error: (error, st) => const SizedBox(),
                              loading: () => const CircularProgressIndicator(),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SongSeeker extends ConsumerStatefulWidget {
  const SongSeeker({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongSeekerState();
}

class _SongSeekerState extends ConsumerState<SongSeeker> {
  double? dragValue;

  @override
  Widget build(BuildContext context) {
    final res = ref.watch(dragProvider);
    return res.when(
      data: (data) {
        // debugPrint("pos: ${data.position}, dur: ${data.duration}");
        return Slider(
          max: data.duration.inMilliseconds.toDouble(),
          value: min(dragValue ?? data.position.inMilliseconds.toDouble(),
              data.duration.inMilliseconds.toDouble()),
          onChanged: (value) {
            setState(() {
              dragValue = value;
              // print(dragValue);
            });
          },
          onChangeEnd: (newPosition) {
            ref
                .read(playerProvider)
                .seek(Duration(milliseconds: newPosition.round()));
            dragValue = null;
          },
        );
      },
      error: (error, st) => const SizedBox(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
