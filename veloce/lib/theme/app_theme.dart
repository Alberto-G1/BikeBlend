import 'package:flutter/material.dart';

class AppTheme {
  static const Color coral = Color(0xFFFF6B57);
  static const Color orchid = Color(0xFFD85F92);
  static const Color darkBg = Color(0xFF1E1E1E);
  static const Color lightBg = Color(0xFFFAF4ED);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: coral,
    scaffoldBackgroundColor: lightBg,
    fontFamily: 'Poppins',
    appBarTheme: AppBarTheme(
      backgroundColor: lightBg,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    colorScheme: ColorScheme.light(
      primary: coral,
      secondary: orchid,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: coral,
    scaffoldBackgroundColor: darkBg,
    fontFamily: 'Poppins',
    appBarTheme: AppBarTheme(
      backgroundColor: darkBg,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
    colorScheme: ColorScheme.dark(
      primary: coral,
      secondary: orchid,
    ),
  );
}
