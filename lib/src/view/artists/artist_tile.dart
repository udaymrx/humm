import 'package:flutter/material.dart';
import 'package:humm/src/view/artists/artist_song_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../app/colors.dart';

class ArtistTile extends StatelessWidget {
  const ArtistTile({super.key, required this.artist});

  final ArtistModel artist;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, ArtistPage.routeName,
            arguments: artist.artist == "<unknown>"
                ? "Unknown Artist"
                : artist.artist);
      },
      title: Text(
        artist.artist == "<unknown>" ? "Unknown Artist" : artist.artist,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.visible,
      ),
      subtitle: Text(
        "${artist.numberOfAlbums} albums  |  ${artist.numberOfTracks} songs",
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.grey,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: const CircleAvatar(
        radius: 35,
        child: Icon(
          Icons.person,
          size: 30,
        ),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert),
      ),
    );
  }
}
