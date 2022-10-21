import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/colors.dart';
import 'mini_player.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.tabsRouter});

  final TabsRouter tabsRouter;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, -2),
          blurRadius: 4,
          spreadRadius: 2,
        ),
      ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniMusicPlayer(),
          BottomNavigationBar(
            currentIndex: widget.tabsRouter.activeIndex,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedItemColor: AppColors.grey,
            onTap: widget.tabsRouter.setActiveIndex,
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

class BottomNavItem extends StatelessWidget {
  const BottomNavItem(
      {super.key, required this.child, required this.label, this.onPressed});

  final Widget child;
  final String label;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
