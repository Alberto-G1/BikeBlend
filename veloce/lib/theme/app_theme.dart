import 'package:flutter/material.dart';

class AppTheme {
  // Core colors
  static const Color coral = Color(0xFFFF6B57);
  static const Color orchid = Color(0xFFD85F92);
  static const Color darkBg = Color(0xFF1E1E1E);
  static const Color lightBg = Color(0xFFFAF4ED);
  
  // Enhanced colors
  static const Color accentBlue = Color(0xFF5B9EFF);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color darkAccent = Color(0xFF2A2A2A);
  static const Color darkCardBg = Color(0xFF252525);
  static const Color lightCardBg = Color(0xFFF5EBE0);

  // Available font families
  static const List<String> availableFonts = [
    'Poppins',
    'Montserrat',
    'Roboto',
    'OpenSans',
    'Lato'
  ];

  static ThemeData getTheme({
    required bool isDark, 
    String fontFamily = 'Poppins'
  }) {
    final ColorScheme colorScheme = isDark 
      ? ColorScheme.dark(
          primary: coral,
          secondary: orchid,
          tertiary: accentBlue,
          surface: darkCardBg,
          error: Colors.redAccent,
        )
      : ColorScheme.light(
          primary: coral,
          secondary: orchid,
          tertiary: accentBlue,
          surface: lightCardBg,
          error: Colors.red,
        );

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: coral,
      scaffoldBackgroundColor: isDark ? darkBg : lightBg,
      fontFamily: fontFamily,
      cardTheme: CardTheme(
        color: isDark ? darkCardBg : lightCardBg,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? darkBg : lightBg,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontFamily,
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: fontFamily,
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontFamily: fontFamily,
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamily,
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
      colorScheme: colorScheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: coral,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkAccent : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: coral, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  // For backward compatibility
  static ThemeData get lightTheme => getTheme(isDark: false);
  static ThemeData get darkTheme => getTheme(isDark: true);
}
