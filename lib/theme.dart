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
    dividerTheme: DividerThemeData(color: kPrimaryColor),
    colorScheme: ColorScheme.light(
      secondary: kSecondaryLightColor,
      onSecondary: kAccentLightColor,
      onSecondaryContainer: kOnAccentLightColor,
      tertiary: kSecondaryDarkColor,
      onTertiary: kAccentDarkColor,
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
      displayMedium: TextStyle(
        color: kSecondaryDarkColor,
        fontSize: 60,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(color: kTitleTextLightColor, fontSize: 15),
      titleLarge: TextStyle(color: kBodyTextColorLight, fontSize: 20),
      titleSmall: TextStyle(color: kTitleTextDarkColor, fontSize: 15),
    ),
  );
}

// Dark Theme
ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Color(0xFF0D0C0E),
    appBarTheme: appBarTheme,
    dividerTheme: DividerThemeData(color: kPrimaryColor),
    colorScheme: ColorScheme.light(
        secondary: kSecondaryDarkColor,
        onSecondary: kAccentDarkColor,
        onSecondaryContainer: kAccentDarkColor,
        tertiary: kSecondaryLightColor,
        onTertiary: kAccentLightColor,
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
      displayMedium: TextStyle(
        color: kSecondaryLightColor,
        fontSize: 60,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(color: kTitleTextDarkColor, fontSize: 15),
      titleLarge: TextStyle(color: kBodyTextColorDark, fontSize: 20),
      titleSmall: TextStyle(color: kTitleTextLightColor, fontSize: 15),
    ),
  );
}

AppBarTheme appBarTheme = AppBarTheme(color: Colors.transparent, elevation: 0);
