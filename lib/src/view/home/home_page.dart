import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:humm/src/app/colors.dart';
import 'package:humm/src/view/albums/album_list.dart';
import 'package:humm/src/view/artists/artist_list.dart';
import 'package:humm/src/view/folders/folder_list.dart';
import 'package:humm/src/view/home/mini_player.dart';
import 'package:humm/src/view/songs/songs_list.dart';

import '../../app/global_provider.dart';
import '../settings/settings_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static const routeName = '/';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int currentIndex = 0;

  void changeTab(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  void dispose() {
    ref.read(playerProvider).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Humm"),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsPage.routeName);
              },
            ),
          ],
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
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MiniMusicPlayer(),
            BottomNavigationBar(
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12,
              unselectedItemColor: AppColors.grey,
              onTap: changeTab,
              items: [
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset('assets/images/home_fill.svg'),
                  icon: SvgPicture.asset(
                    'assets/images/home.svg',
                    color: AppColors.grey,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset('assets/images/heart_fill.svg'),
                  icon: SvgPicture.asset(
                    'assets/images/heart.svg',
                    color: AppColors.grey,
                  ),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  activeIcon:
                      SvgPicture.asset('assets/images/playlist_fill.svg'),
                  icon: SvgPicture.asset(
                    'assets/images/playlist.svg',
                    color: AppColors.grey,
                  ),
                  label: 'Playlists',
                ),
                BottomNavigationBarItem(
                  activeIcon:
                      SvgPicture.asset('assets/images/settings_fill.svg'),
                  icon: SvgPicture.asset(
                    'assets/images/settings.svg',
                    color: AppColors.grey,
                  ),
                  label: "Settings",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
