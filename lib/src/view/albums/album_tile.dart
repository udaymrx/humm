import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/view/albums/album_song_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../app/colors.dart';
import '../../app/global_provider.dart';

final albumArtProvider =
    FutureProvider.family<Uint8List?, int>((ref, id) async {
  return ref.read(audioQueryProvider).getAlbumArt(id);
});

class AlbumTile extends StatelessWidget {
  const AlbumTile({super.key, required this.album});

  final AlbumModel album;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AlbumPage.routeName,
            arguments: album.album);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: AppColors.primary,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Consumer(builder: (context, ref, child) {
                final res = ref.watch(albumArtProvider(album.id));
                return res.when(
                  data: (data) {
                    if (data != null) {
                      return FittedBox(
                          fit: BoxFit.cover, child: Image.memory(data));
                    } else {
                      return const Icon(
                        Icons.music_note,
                        color: AppColors.white,
                      );
                    }
                  },
                  error: (e, s) => const Icon(
                    Icons.music_note,
                    color: AppColors.white,
                  ),
                  loading: () => const Icon(
                    Icons.music_note,
                    color: AppColors.white,
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    album.album,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Flexible(
                    child: Text(
                  album.artist == "<unknown>"
                      ? "Unknown Artist"
                      : album.artist!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                )),
                Text(
                  "  |  ${album.numOfSongs} songs",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
