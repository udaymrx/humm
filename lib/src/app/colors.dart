import 'package:flutter/material.dart';

class AppColors {
  /// Common
  static const Color primary = Color(0xff06C149);
  static const Color grey = Color(0xff9E9E9E);
  static const Color accent1 = Color(0xFFE4935D);
  static const Color accent2 = Color(0xFFBEABA1);
  static const Color offWhite = Color(0xFFF8ECE5);
  static const Color caption = Color(0xFF7D7873);
  static const Color body = Color(0xFF514F4D);
  static const Color greyStrong = Color(0xFF616161);
  static const Color greyMedium = Color(0xFF9D9995);
  static const Color white = Colors.white;
  static const Color black = Color(0xFF1E1B18);

  final bool isDark = false;

  // Color shift(Color c, double d) => ColorUtils.shiftHsl(c, d * (isDark ? -1 : 1));

  ThemeData toThemeData() {
    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    TextTheme txtTheme =
        (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;
    Color txtColor = white;
    ColorScheme colorScheme = ColorScheme(
        // Decide how you want to apply your own custom them, to the MaterialApp
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: accent1,
        primaryContainer: accent1,
        secondary: accent1,
        secondaryContainer: accent1,
        background: offWhite,
        surface: offWhite,
        onBackground: txtColor,
        onSurface: txtColor,
        onError: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        error: Colors.red.shade400);

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    /// Also add on some extra properties that ColorScheme seems to miss
    var t =
        ThemeData.from(textTheme: txtTheme, colorScheme: colorScheme).copyWith(
      textSelectionTheme: const TextSelectionThemeData(cursorColor: accent1),
      highlightColor: accent1,
    );

    /// Return the themeData which MaterialApp can now use
    return t;
  }
}
