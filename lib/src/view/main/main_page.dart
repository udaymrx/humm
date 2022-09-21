import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:humm/src/app/colors.dart';
import 'package:humm/src/view/favorites/favorite_page.dart';
import 'package:humm/src/view/home/home_page.dart';
import 'package:humm/src/view/home/mini_player.dart';
import 'package:humm/src/view/playlist/playlist_page.dart';
import 'package:humm/src/view/settings/settings_page.dart';

import '../../app/global_provider.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  static const routeName = '/';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int currentIndex = 0;

  final PageController _pageController = PageController();

  void changeTab(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    currentIndex = index;
    setState(() {});
  }

  void changeTabIndex(int index) {
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
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: changeTabIndex,
        children: const [
          HomePage(),
          FavoritePage(),
          PlaylistPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniMusicPlayer(),
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
                activeIcon: SvgPicture.asset('assets/images/playlist_fill.svg'),
                icon: SvgPicture.asset(
                  'assets/images/playlist.svg',
                  color: AppColors.grey,
                ),
                label: 'Playlists',
              ),
              BottomNavigationBarItem(
                activeIcon: SvgPicture.asset('assets/images/settings_fill.svg'),
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
    );
  }
}
