import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/colors.dart';
import 'package:humm/src/app/global_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../utils/playlists_bottom_sheet.dart';

class MusicTile extends StatelessWidget {
  const MusicTile({super.key, required this.song});

  final SongModel song;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      "${Duration(milliseconds: song.duration ?? 0).toString().substring(2, 7)} mins",
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
            final val = ref.watch(isFavoriteProvider(song.id));
            return val.when(
              data: (isFavorite) {
                return IconButton(
                  onPressed: () async {
                    if (isFavorite) {
                      await ref.read(roomProvider).removeFromFavourite(song.id);
                      ref.invalidate(favoriteSongProvider);
                      ref.invalidate(isFavoriteProvider(song.id));
                    } else {
                      await ref.read(roomProvider).addToFavourite(song);
                      ref.invalidate(favoriteSongProvider);
                      ref.invalidate(isFavoriteProvider(song.id));
                    }
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                  ),
                );
              },
              error: (error, st) => Text(error.toString()),
              loading: () => const Icon(
                Icons.favorite_border_rounded,
              ),
            );
          }),
          Consumer(builder: (context, ref, child) {
            return IconButton(
              onPressed: () async {
                final key = await openBottomSheet(context);
                if (key != null) {
                  await ref
                      .read(roomProvider)
                      .addToPlaylist(song: song, playlistKey: key);
                  ref.invalidate(listOfPlaylistProvider);
                }
              },
              icon: const Icon(Icons.more_vert),
            );
          }),
        ],
      ),
    );
  }
}
