import 'package:flutter/material.dart';
import 'package:humm/src/view/albums/album_song_page.dart';
import 'package:humm/src/view/artists/artist_song_page.dart';
import 'package:humm/src/view/folders/folder_page.dart';
import 'package:humm/src/view/main/main_page.dart';
import 'package:humm/src/view/songs/song_page.dart';

class RouterNav {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    //Back to old navigation
    // Getting arguments passed in while calling Navigator.pushNamed
    // Uncomment below line to use page arguments.
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case MainPage.routeName:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case SongPage.routeName:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SongPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              final tween = Tween(begin: begin, end: end);
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: curve,
              );

              return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child,
              );
            });
      case FolderPage.routeName:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => FolderPage(path: args),
          );
        }
        return _errorRoute(routeSettings.name!);
      case ArtistPage.routeName:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => ArtistPage(artist: args),
          );
        }
        return _errorRoute(routeSettings.name!);
      case AlbumPage.routeName:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => AlbumPage(album: args),
          );
        }
        return _errorRoute(routeSettings.name!);
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute(routeSettings.name!);
    }
  }

  static Route<dynamic> _errorRoute(String name) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(
            'No route defined for $name',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    });
  }
}
