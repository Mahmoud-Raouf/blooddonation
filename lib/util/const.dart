import 'package:flutter/material.dart';

class Constants {
  static String appName = "Flutter Travel";

  //Colors for theme
  static Color lightPrimary = const Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color? lightAccent = Colors.blueGrey[900];
  static Color darkAccent = Colors.white;
  static Color lightBG = const Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color badgeColor = Colors.red;

  static ThemeData lightTheme = ThemeData(
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).bodyMedium,
      titleTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).titleLarge,
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: lightAccent),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightAccent),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    hintColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cardColor: darkAccent,
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).bodyMedium,
      titleTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).titleLarge,
    ),
  );
}
