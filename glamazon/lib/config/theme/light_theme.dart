import 'package:flutter/material.dart';
import '../../utils/colors.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.sienna,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: AppColors.sienna,
    secondary: AppColors.sienna.withOpacity(0.7),
    surface: Colors.white,
    error: Colors.red,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.sienna,
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
    displayLarge: TextStyle(color: Colors.black87),
    displayMedium: TextStyle(color: Colors.black87),
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.sienna),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
