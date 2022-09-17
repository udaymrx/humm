import 'dart:math';

import 'package:flutter/material.dart';
import 'package:humm/src/app/colors.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../app/global_provider.dart';
import 'music_tile.dart';

class SongPage extends ConsumerWidget {
  const SongPage({Key? key}) : super(key: key);

  static const routeName = '/song';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Consumer(builder: (context, ref, child) {
                final res = ref.watch(metaDataProvider);

                return res.when(
                  data: (state) {
                    if (state?.sequence.isEmpty ?? true) {
                      return const SizedBox();
                    }
                    final metadata = state!.currentSource!.tag as MediaItem;
                    return Column(
                      children: [
                        Hero(
                          tag: "Art",
                          child: Container(
                            height: 356,
                            width: double.maxFinite,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              color: AppColors.primary,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(36),
                              child: Consumer(builder: (context, ref, child) {
                                final res = ref.watch(
                                    songArtProvider(int.parse(metadata.id)));

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
                        const SizedBox(height: 16),
                        Text(
                          metadata.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          metadata.artist!,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.greyStrong),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  },
                  error: (error, st) => const SizedBox(),
                  loading: () => const CircularProgressIndicator(),
                );
              }),
              const SongSeeker(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer(builder: (context, ref, child) {
                    final res = ref.watch(dragProvider);

                    return res.when(
                      data: (data) {
                        var valid = data.duration.compareTo(data.position) >= 0;
                        return Hero(
                          tag: "title",
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              (valid ? data.position : data.duration)
                                  .toString()
                                  .substring(2, 7),
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greyStrong),
                            ),
                          ),
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
                        return Hero(
                          tag: 'artist',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              rem.toString().substring(2, 7),
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greyStrong),
                            ),
                          ),
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
                            Icons.shuffle,
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
                    icon: const Icon(Icons.skip_previous),
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
                              state.playing ? Icons.pause : Icons.play_arrow),
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
                                content: Text("No more song in the queue")));
                      }
                    },
                    icon: const Icon(Icons.skip_next),
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
                                ? Icons.repeat
                                : loopMode == LoopMode.all
                                    ? Icons.repeat
                                    : Icons.repeat_one,
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
        debugPrint("pos: ${data.position}, dur: ${data.duration}");
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
