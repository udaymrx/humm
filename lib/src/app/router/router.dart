import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:humm/src/view/albums/album_song_page.dart';
import 'package:humm/src/view/artists/artist_song_page.dart';
import 'package:humm/src/view/favorites/favorite_page.dart';
import 'package:humm/src/view/folders/folder_page.dart';
import 'package:humm/src/view/main/main_page.dart';
import 'package:humm/src/view/playlist/add_song_page.dart';
import 'package:humm/src/view/playlist/playlist_page.dart';
import 'package:humm/src/view/playlist/playlist_song_page.dart';
import 'package:humm/src/view/queue/queue_page.dart';
import 'package:humm/src/view/settings/settings_page.dart';
import 'package:humm/src/view/songs/song_page.dart';

import '../../view/home/home_page.dart';

class AppRouteObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint("going to: ${route.settings.name}");
  }
}

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      // guards: [AuthGuard],
      name: 'MainRouter',
      initial: true,
      page: MainPage,
      children: [
        AutoRoute(
          path: 'home',
          name: 'HomeRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: HomePage),
            AutoRoute(path: 'artist', page: ArtistPage),
            AutoRoute(path: 'album', page: AlbumPage),
            AutoRoute(path: 'folder', page: FolderPage),
          ],
        ),
        AutoRoute(
          path: 'favorite',
          name: 'FavoriteRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: FavoritePage),
          ],
        ),
        AutoRoute(
          path: 'playlist',
          name: 'PlaylistRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: PlaylistPage),
            AutoRoute(path: 'playlist-songs', page: PlaylistSongPage),
            AutoRoute(path: 'addSong', page: AddSongPage),
          ],
        ),
        AutoRoute(
          path: 'settings',
          name: 'SettingsRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: SettingsPage),
          ],
        ),
      ],
    ),
    CustomRoute(
      path: '/song',
      page: SongPage,
      transitionsBuilder: TransitionsBuilders.slideBottom,
      durationInMilliseconds: 400,
    ),
    AutoRoute(path: 'queue', page: QueuePage),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class $AppRouter {}
