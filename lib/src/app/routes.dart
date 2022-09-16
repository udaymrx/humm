import 'package:flutter/material.dart';
import 'package:humm/src/view/folders/folder_page.dart';
import 'package:humm/src/view/home/home_page.dart';
import 'package:humm/src/view/songs/song_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../view/settings/settings_page.dart';

class RouterNav {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    //Back to old navigation
    // Getting arguments passed in while calling Navigator.pushNamed
    // Uncomment below line to use page arguments.
    final args = routeSettings.arguments;
    return MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (BuildContext context) {
        switch (routeSettings.name) {
          case HomePage.routeName:
            return const HomePage();
          case SettingsPage.routeName:
            return const SettingsPage();
          case SongPage.routeName:
            return const SongPage();
          case FolderPage.routeName:
            if (args is String) {
              return FolderPage(path: args);
            }
            return _errorRoute(routeSettings.name!);
          default:
            return _errorRoute(routeSettings.name!);
        }
      },
    );
  }

  static Widget _errorRoute(String name) {
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
  }
}
