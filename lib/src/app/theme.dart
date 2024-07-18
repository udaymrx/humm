import 'package:flutter/material.dart';

class HAppTheme {
  ThemeData get lightTheme {
    final ThemeData base = ThemeData.light();

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        primary: const Color(0xff06C149),
        onPrimary: Colors.black,
        onSurface: Colors.black,
        onBackground: Colors.black,
        seedColor: const Color(0xff06C149),
        secondary: const Color(0xff06C149),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      textTheme: base.textTheme.apply(fontFamily: "Urbanist"),
      useMaterial3: true,
    );
  }

  ThemeData get darkTheme {
    final ThemeData base = ThemeData.dark();

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color(0xff06C149),
        primary: const Color(0xff06C149),
        secondary: const Color(0xff06C149),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: base.textTheme.apply(fontFamily: "Urbanist"),
      useMaterial3: true,
    );
  }
}
