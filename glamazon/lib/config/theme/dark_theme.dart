import 'package:flutter/material.dart';
import '../../utils/colors.dart';

final ThemeData darkTheme = ThemeData(
  primaryColor: AppColors.sienna,
  scaffoldBackgroundColor: Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: AppColors.sienna,
    secondary: AppColors.sienna.withOpacity(0.7),
    surface: Color(0xFF1E1E1E),
    error: Colors.red.shade300,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.sienna,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.sienna),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade700),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
