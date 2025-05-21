import 'package:flutter/material.dart';

class AppColors {
  // Primary sienna colors
  static const Color siennaVeryLight = Color(0xFFF8ECDC);
  static const Color siennaVeryDark = Color(0xFF5A2E1A);
  
  // Success and error colors (sienna-tinted)
  static const Color success = Color.fromARGB(255, 37, 161, 84);
  static const Color error = Color.fromARGB(255, 154, 50, 36);
  
  // Background colors
  static const Color lightBackground = Colors.white;
  static const Color darkBackground = Color.fromARGB(255, 197, 98, 98);
  
  // Text colors
  static const Color lightTextPrimary = Color(0xFF703A1F);
  static const Color lightTextSecondary = Color(0xFFA0522D);
  static const Color darkTextPrimary = Color(0xFFD2A084);
  static const Color darkTextSecondary = Color(0xFFBE8E6C);
  
  // Primary colors (sienna variants)
  static const Color teal = Color(0xFFA0522D);
  
  // Secondary colors (sienna-complementary)
  static const Color cream = Color(0xFFF8ECDC);
  static const Color gold = Color(0xFFA07D2D);
  
  // Dark mode colors
  static const Color darkSurface = Color(0xFF1E1E1E);
  
  // Text colors
  static const Color darkText = Color(0xFF703A1F);
  static const Color lightText = Color(0xFFF5F5DC);
  
  // Status colors (sienna variants)
  static const Color warning = Color(0xFFA0752D);
  static const Color info = Color(0xFFA0522D);
  static const tealAccent = Color(0xFFD2A084);
  static const Color beige = Color(0xFFF5F5DC);
  
  // Text colors (sienna-based)
  static const Color textPrimary = Color(0xFF703A1F);
  static const Color textSecondary = Color(0xFFA0522D);
  static const Color textHint = Color(0xFFBE8E6C);

  // Main colors
  static const Color sienna = Color.fromARGB(179, 181, 81, 31);
  static const Color siennaLight = Color(0xFFC0724A);
  static const Color siennaDark = Color(0xFF8B4513);
  
  // Background colors
  static const Color backgroundLight = Color.fromARGB(255, 248, 236, 220);
  static const Color backgroundDark = Color(0xFF121212);
  
  // Card colors
  static const Color cardDark = Color(0xFF2A2A2A);
  static const Color cardLight = Colors.white;
  
  // Status colors
  static const Color confirmed = Colors.green;
  static const Color pending = Colors.orange;
  static const Color cancelled = Colors.red;
  
  // Helper method to convert hex string to color
  static Color hexStringToColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return Colors.black;
  }
}
