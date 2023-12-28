// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

// Our light/Primary Theme
ThemeData themeData(BuildContext context) {
  return ThemeData(
    appBarTheme: appBarTheme,
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      secondary: kSecondaryLightColor,
      onSecondary: kAccentLightColor,
      background: Colors.white,
      // on light theme surface = Colors.white by default
    ),
    iconTheme: IconThemeData(color: kBodyTextColorLight),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(foregroundColor: kAccentIconLightColor),
    primaryIconTheme: IconThemeData(color: kPrimaryIconLightColor),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      bodyLarge: TextStyle(color: kBodyTextColorLight),
      bodyMedium: TextStyle(color: kBodyTextColorLight),
      headlineMedium: TextStyle(color: kTitleTextLightColor, fontSize: 32),
      displayLarge: TextStyle(color: kTitleTextLightColor, fontSize: 80),
      titleMedium: TextStyle(color: kTitleTextLightColor, fontSize: 15),
    ),
  );
}

// Dark Theme
ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Color(0xFF0D0C0E),
    appBarTheme: appBarTheme,
    colorScheme: ColorScheme.light(
        secondary: kSecondaryDarkColor,
        onSecondary: kAccentDarkColor,
        surface: kSurfaceDarkColor,
        background: kBackgroundDarkColor
        // on dark theme surface background needs to be initialised
        ),
    iconTheme: IconThemeData(color: kBodyTextColorDark),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(foregroundColor: kAccentIconDarkColor),
    primaryIconTheme: IconThemeData(color: kPrimaryIconDarkColor),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      bodyLarge: TextStyle(color: kBodyTextColorDark),
      bodyMedium: TextStyle(color: kBodyTextColorDark),
      headlineMedium: TextStyle(color: kTitleTextDarkColor, fontSize: 32),
      displayLarge: TextStyle(color: kTitleTextDarkColor, fontSize: 80),
      titleMedium: TextStyle(color: kTitleTextDarkColor, fontSize: 15),
    ),
  );
}

AppBarTheme appBarTheme = AppBarTheme(color: Colors.transparent, elevation: 0);
