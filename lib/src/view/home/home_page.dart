import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/colors.dart';
import 'package:humm/src/view/albums/album_list.dart';
import 'package:humm/src/view/artists/artist_list.dart';
import 'package:humm/src/view/folders/folder_list.dart';
import 'package:humm/src/view/songs/songs_list.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Humm"),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Songs'),
              Tab(text: 'Artist'),
              Tab(text: 'Album'),
              Tab(text: 'Folder'),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.grey,
          ),
        ),
        body: const TabBarView(
          children: [
            SongsList(),
            ArtistList(),
            AlbumList(),
            FolderList(),
          ],
        ),
      ),
    );
  }
}
