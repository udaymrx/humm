// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i14;
import 'package:auto_route/empty_router_widgets.dart' as _i4;
import 'package:flutter/material.dart' as _i15;
import 'package:flutter/widgets.dart' as _i16;
import 'package:humm/src/view/albums/album_song_page.dart' as _i7;
import 'package:humm/src/view/artists/artist_song_page.dart' as _i6;
import 'package:humm/src/view/favorites/favorite_page.dart' as _i9;
import 'package:humm/src/view/folders/folder_page.dart' as _i8;
import 'package:humm/src/view/home/home_page.dart' as _i5;
import 'package:humm/src/view/main/main_page.dart' as _i1;
import 'package:humm/src/view/playlist/add_song_page.dart' as _i12;
import 'package:humm/src/view/playlist/playlist_page.dart' as _i10;
import 'package:humm/src/view/playlist/playlist_song_page.dart' as _i11;
import 'package:humm/src/view/queue/queue_page.dart' as _i3;
import 'package:humm/src/view/settings/settings_page.dart' as _i13;
import 'package:humm/src/view/songs/song_page.dart' as _i2;

class AppRouter extends _i14.RootStackRouter {
  AppRouter([_i15.GlobalKey<_i15.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    MainRouter.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i1.MainPage());
    },
    SongRoute.name: (routeData) {
      return _i14.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i2.SongPage(),
          transitionsBuilder: _i14.TransitionsBuilders.slideBottom,
          durationInMilliseconds: 400,
          opaque: true,
          barrierDismissible: false);
    },
    QueueRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.QueuePage());
    },
    HomeRouter.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    FavoriteRouter.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    PlaylistRouter.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    SettingsRouter.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    HomeRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.HomePage());
    },
    ArtistRoute.name: (routeData) {
      final args = routeData.argsAs<ArtistRouteArgs>();
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i6.ArtistPage(key: args.key, artist: args.artist));
    },
    AlbumRoute.name: (routeData) {
      final args = routeData.argsAs<AlbumRouteArgs>();
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i7.AlbumPage(key: args.key, album: args.album));
    },
    FolderRoute.name: (routeData) {
      final args = routeData.argsAs<FolderRouteArgs>();
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i8.FolderPage(key: args.key, path: args.path));
    },
    FavoriteRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i9.FavoritePage());
    },
    PlaylistRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i10.PlaylistPage());
    },
    PlaylistSongRoute.name: (routeData) {
      final args = routeData.argsAs<PlaylistSongRouteArgs>();
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i11.PlaylistSongPage(key: args.key, id: args.id));
    },
    AddSongRoute.name: (routeData) {
      final args = routeData.argsAs<AddSongRouteArgs>();
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i12.AddSongPage(key: args.key, id: args.id));
    },
    SettingsRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i13.SettingsPage());
    }
  };

  @override
  List<_i14.RouteConfig> get routes => [
        _i14.RouteConfig(MainRouter.name, path: '/', children: [
          _i14.RouteConfig(HomeRouter.name,
              path: 'home',
              parent: MainRouter.name,
              children: [
                _i14.RouteConfig(HomeRoute.name,
                    path: '', parent: HomeRouter.name),
                _i14.RouteConfig(ArtistRoute.name,
                    path: 'artist', parent: HomeRouter.name),
                _i14.RouteConfig(AlbumRoute.name,
                    path: 'album', parent: HomeRouter.name),
                _i14.RouteConfig(FolderRoute.name,
                    path: 'folder', parent: HomeRouter.name)
              ]),
          _i14.RouteConfig(FavoriteRouter.name,
              path: 'favorite',
              parent: MainRouter.name,
              children: [
                _i14.RouteConfig(FavoriteRoute.name,
                    path: '', parent: FavoriteRouter.name)
              ]),
          _i14.RouteConfig(PlaylistRouter.name,
              path: 'playlist',
              parent: MainRouter.name,
              children: [
                _i14.RouteConfig(PlaylistRoute.name,
                    path: '', parent: PlaylistRouter.name),
                _i14.RouteConfig(PlaylistSongRoute.name,
                    path: 'playlist-songs', parent: PlaylistRouter.name),
                _i14.RouteConfig(AddSongRoute.name,
                    path: 'addSong', parent: PlaylistRouter.name)
              ]),
          _i14.RouteConfig(SettingsRouter.name,
              path: 'settings',
              parent: MainRouter.name,
              children: [
                _i14.RouteConfig(SettingsRoute.name,
                    path: '', parent: SettingsRouter.name)
              ])
        ]),
        _i14.RouteConfig(SongRoute.name, path: '/song'),
        _i14.RouteConfig(QueueRoute.name, path: 'queue'),
        _i14.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.MainPage]
class MainRouter extends _i14.PageRouteInfo<void> {
  const MainRouter({List<_i14.PageRouteInfo>? children})
      : super(MainRouter.name, path: '/', initialChildren: children);

  static const String name = 'MainRouter';
}

/// generated route for
/// [_i2.SongPage]
class SongRoute extends _i14.PageRouteInfo<void> {
  const SongRoute() : super(SongRoute.name, path: '/song');

  static const String name = 'SongRoute';
}

/// generated route for
/// [_i3.QueuePage]
class QueueRoute extends _i14.PageRouteInfo<void> {
  const QueueRoute() : super(QueueRoute.name, path: 'queue');

  static const String name = 'QueueRoute';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class HomeRouter extends _i14.PageRouteInfo<void> {
  const HomeRouter({List<_i14.PageRouteInfo>? children})
      : super(HomeRouter.name, path: 'home', initialChildren: children);

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class FavoriteRouter extends _i14.PageRouteInfo<void> {
  const FavoriteRouter({List<_i14.PageRouteInfo>? children})
      : super(FavoriteRouter.name, path: 'favorite', initialChildren: children);

  static const String name = 'FavoriteRouter';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class PlaylistRouter extends _i14.PageRouteInfo<void> {
  const PlaylistRouter({List<_i14.PageRouteInfo>? children})
      : super(PlaylistRouter.name, path: 'playlist', initialChildren: children);

  static const String name = 'PlaylistRouter';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class SettingsRouter extends _i14.PageRouteInfo<void> {
  const SettingsRouter({List<_i14.PageRouteInfo>? children})
      : super(SettingsRouter.name, path: 'settings', initialChildren: children);

  static const String name = 'SettingsRouter';
}

/// generated route for
/// [_i5.HomePage]
class HomeRoute extends _i14.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i6.ArtistPage]
class ArtistRoute extends _i14.PageRouteInfo<ArtistRouteArgs> {
  ArtistRoute({_i16.Key? key, required String artist})
      : super(ArtistRoute.name,
            path: 'artist', args: ArtistRouteArgs(key: key, artist: artist));

  static const String name = 'ArtistRoute';
}

class ArtistRouteArgs {
  const ArtistRouteArgs({this.key, required this.artist});

  final _i16.Key? key;

  final String artist;

  @override
  String toString() {
    return 'ArtistRouteArgs{key: $key, artist: $artist}';
  }
}

/// generated route for
/// [_i7.AlbumPage]
class AlbumRoute extends _i14.PageRouteInfo<AlbumRouteArgs> {
  AlbumRoute({_i16.Key? key, required String album})
      : super(AlbumRoute.name,
            path: 'album', args: AlbumRouteArgs(key: key, album: album));

  static const String name = 'AlbumRoute';
}

class AlbumRouteArgs {
  const AlbumRouteArgs({this.key, required this.album});

  final _i16.Key? key;

  final String album;

  @override
  String toString() {
    return 'AlbumRouteArgs{key: $key, album: $album}';
  }
}

/// generated route for
/// [_i8.FolderPage]
class FolderRoute extends _i14.PageRouteInfo<FolderRouteArgs> {
  FolderRoute({_i16.Key? key, required String path})
      : super(FolderRoute.name,
            path: 'folder', args: FolderRouteArgs(key: key, path: path));

  static const String name = 'FolderRoute';
}

class FolderRouteArgs {
  const FolderRouteArgs({this.key, required this.path});

  final _i16.Key? key;

  final String path;

  @override
  String toString() {
    return 'FolderRouteArgs{key: $key, path: $path}';
  }
}

/// generated route for
/// [_i9.FavoritePage]
class FavoriteRoute extends _i14.PageRouteInfo<void> {
  const FavoriteRoute() : super(FavoriteRoute.name, path: '');

  static const String name = 'FavoriteRoute';
}

/// generated route for
/// [_i10.PlaylistPage]
class PlaylistRoute extends _i14.PageRouteInfo<void> {
  const PlaylistRoute() : super(PlaylistRoute.name, path: '');

  static const String name = 'PlaylistRoute';
}

/// generated route for
/// [_i11.PlaylistSongPage]
class PlaylistSongRoute extends _i14.PageRouteInfo<PlaylistSongRouteArgs> {
  PlaylistSongRoute({_i16.Key? key, required int id})
      : super(PlaylistSongRoute.name,
            path: 'playlist-songs',
            args: PlaylistSongRouteArgs(key: key, id: id));

  static const String name = 'PlaylistSongRoute';
}

class PlaylistSongRouteArgs {
  const PlaylistSongRouteArgs({this.key, required this.id});

  final _i16.Key? key;

  final int id;

  @override
  String toString() {
    return 'PlaylistSongRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i12.AddSongPage]
class AddSongRoute extends _i14.PageRouteInfo<AddSongRouteArgs> {
  AddSongRoute({_i16.Key? key, required int id})
      : super(AddSongRoute.name,
            path: 'addSong', args: AddSongRouteArgs(key: key, id: id));

  static const String name = 'AddSongRoute';
}

class AddSongRouteArgs {
  const AddSongRouteArgs({this.key, required this.id});

  final _i16.Key? key;

  final int id;

  @override
  String toString() {
    return 'AddSongRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i13.SettingsPage]
class SettingsRoute extends _i14.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: '');

  static const String name = 'SettingsRoute';
}
