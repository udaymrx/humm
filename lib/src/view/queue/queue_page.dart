import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:humm/src/view/queue/queue_tile.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../app/global_provider.dart';

class QueuePage extends ConsumerWidget {
  const QueuePage({Key? key}) : super(key: key);
  static const routeName = '/queue';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Queue"),
        actions: [
          PopupMenuButton<int>(
            elevation: 30,
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: SvgPicture.asset("assets/images/more_circle.svg"),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                height: 40,
                onTap: () async {
                  final player = ref.read(playerProvider);

                  if (!player.playing) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    await ref.read(queueController.notifier).dumpQueue();
                    ref.read(musicQueuedProvider.notifier).state = false;
                  } else {
                    Navigator.pop(context);
                    await ref.read(queueController.notifier).clearKeepSingle();
                  }
                },
                child: const Text("Clear Queue"),
              ),
            ],
          ),
        ],
      ),
      body: Consumer(builder: (context, ref, child) {
        final val = ref.watch(queueController);
        return ListView.builder(
          itemBuilder: (context, index) {
            MediaItem currentItem = val.sequence[index].tag as MediaItem;

            var result = ref.watch(playingIndexProvider);
            return result.when(
              data: (plyingIndex) {
                return InkWell(
                  onTap: () async {
                    final player = ref.read(playerProvider);

                    await player.seek(Duration.zero, index: index);
                    if (!player.playing) {
                      await player.play();
                    }
                  },
                  child: QueueTile(
                    song: currentItem,
                    isPlaying: plyingIndex == index,
                  ),
                );
              },
              error: (error, stackTrace) => const SizedBox(),
              loading: () => const SizedBox(),
            );
          },
          itemCount: val.length,
        );
      }),
    );
  }
}
