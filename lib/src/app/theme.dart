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
      iconTheme: IconThemeData(color: Colors.black),
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
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: base.textTheme.apply(fontFamily: "Urbanist"),
      useMaterial3: true,
    );
  }
}

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class GalleryThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
        contentTextStyle: _textTheme.titleMedium!.apply(color: _darkFillColor),
      ),
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xff06C149),
    primaryContainer: Color(0xff06C149),
    secondary: Color(0xFFEFF3F3),
    secondaryContainer: Color(0xFFFAFBFB),
    background: Color(0xFFE6EBEB),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xff06C149),
    primaryContainer: Color(0xff06C149),
    secondary: Color(0xFF4D1F7C),
    secondaryContainer: Color(0xFF451B6F),
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF), // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static final TextTheme _textTheme = TextTheme(
    headlineMedium:
        TextStyle(fontWeight: _bold, fontSize: 20.0, fontFamily: "Urbanist"),
    bodySmall: TextStyle(
        fontWeight: _semiBold, fontSize: 16.0, fontFamily: "Urbanist"),
    headlineSmall:
        TextStyle(fontWeight: _medium, fontSize: 16.0, fontFamily: "Urbanist"),
    titleMedium:
        TextStyle(fontWeight: _medium, fontSize: 16.0, fontFamily: "Urbanist"),
    labelSmall:
        TextStyle(fontWeight: _medium, fontSize: 12.0, fontFamily: "Urbanist"),
    bodyLarge:
        TextStyle(fontWeight: _regular, fontSize: 14.0, fontFamily: "Urbanist"),
    titleSmall:
        TextStyle(fontWeight: _medium, fontSize: 14.0, fontFamily: "Urbanist"),
    bodyMedium:
        TextStyle(fontWeight: _regular, fontSize: 16.0, fontFamily: "Urbanist"),
    titleLarge:
        TextStyle(fontWeight: _bold, fontSize: 16.0, fontFamily: "Urbanist"),
    labelLarge: TextStyle(
        fontWeight: _semiBold, fontSize: 14.0, fontFamily: "Urbanist"),
  );
}
