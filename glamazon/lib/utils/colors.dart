import 'package:flutter/material.dart';

class AppColors {
  static const Color sienna = Color(0xFFA0522D);
  static const Color siennaLight = Color(0xFFD2A084);
  static const Color siennaDark = Color(0xFF703A1F);
  
  // Success and error colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  
  // Background colors
  static const Color lightBackground = Colors.white;
  static const Color darkBackground = Color(0xFF121212);
  
  // Text colors
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color darkTextPrimary = Color(0xFFEEEEEE);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);

  // Primary colors
  static const Color teal = Color(0xFF008080);
  
  // Secondary colors
  static const Color cream = Color(0xFFF8ECDC);
  static const Color gold = Color(0xFFD4AF37);
  
  // Dark mode colors
  static const Color darkSurface = Color(0xFF1E1E1E);
  
  // Text colors
  static const Color darkText = Color(0xFF212121);
  static const Color lightText = Color(0xFFF5F5F5);
  
  // Status colors
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  static const tealAccent = Colors.tealAccent;

  static const Color beige = Color(0xFFF5F5DC);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
}

// import 'package:flutter/material.dart';

// class AppTheme {
//   static const Color customColor =  Color.fromARGB(255, 181, 81, 31)
// ;

//   // Define lighter shades of the custom color
//   static final Color lighterColor1 = customColor.withOpacity(0.1);
//   static final Color lighterColor2 = customColor.withOpacity(0.2);
//   static final Color lighterColor3 = customColor.withOpacity(0.3);
//   static final Color lighterColor4 = customColor.withOpacity(0.4);
//   static final Color lighterColor5 = customColor.withOpacity(0.5);
//   static final Color lighterColor6 = customColor.withOpacity(0.6);
//   static final Color lighterColor7 = customColor.withOpacity(0.7);
//   static final Color lighterColor8 = customColor.withOpacity(0.8);
//   static final Color lighterColor9 = customColor.withOpacity(0.9);

//   static ThemeData get lightTheme {
//     return ThemeData(
//       brightness: Brightness.light,
//       primarySwatch: createMaterialColor(customColor),
//       primaryColor: customColor,
//       appBarTheme: AppBarTheme(
//         backgroundColor: lighterColor7,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         selectedItemColor: customColor,
//         unselectedItemColor: lighterColor4,
//         backgroundColor: Colors.white,
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ButtonStyle(
//           backgroundColor: WidgetStateProperty.all<Color>(lighterColor7),
//           foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
//         ),
//       ),
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: ButtonStyle(
//           side: WidgetStateProperty.all<BorderSide>(
//             BorderSide(color: lighterColor5),
//           ),
//           foregroundColor: WidgetStateProperty.all<Color>(lighterColor5),
//         ),
//       ),
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//         backgroundColor: lighterColor8,
//       ),
//       textTheme: TextTheme(
//         headlineLarge: TextStyle(color: lighterColor8),
//         headlineMedium: TextStyle(color: lighterColor7),
//         bodySmall: const TextStyle(color: Colors.black),
//         bodyMedium: const TextStyle(color: Colors.black),
//       ),
//       iconTheme: IconThemeData(color: lighterColor6),
//     );
//   }

//   static ThemeData get darkTheme {
//     return ThemeData(
//       brightness: Brightness.dark,
//       primarySwatch: createMaterialColor(customColor),
//       primaryColor: customColor,
//       appBarTheme: AppBarTheme(
//         backgroundColor: lighterColor6,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         selectedItemColor: customColor,
//         unselectedItemColor: lighterColor4,
//         backgroundColor: Colors.black,
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ButtonStyle(
//           backgroundColor: WidgetStateProperty.all<Color>(lighterColor7),
//           foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
//         ),
//       ),
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: ButtonStyle(
//           side: WidgetStateProperty.all<BorderSide>(
//             BorderSide(color: lighterColor5),
//           ),
//           foregroundColor: WidgetStateProperty.all<Color>(lighterColor5),
//         ),
//       ),
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//         backgroundColor: lighterColor8,
//       ),
//       textTheme: TextTheme(
//         headlineLarge: TextStyle(color: lighterColor8),
//         headlineMedium: TextStyle(color: lighterColor7),
//         bodyMedium: const TextStyle(color: Colors.white),
//         bodySmall: const TextStyle(color: Colors.white),
//       ),
//       iconTheme: IconThemeData(color: lighterColor6),
//     );
//   }

//   static MaterialColor createMaterialColor(Color color) {
//     List strengths = <double>[.05];
//     final Map<int, Color> swatch = {};
//     final int r = color.red, g = color.green, b = color.blue;

//     for (int i = 1; i < 10; i++) {
//       strengths.add(0.1 * i);
//     }
//     for (var strength in strengths) {
//       final double ds = 0.5 - strength;
//       swatch[(strength * 1000).round()] = Color.fromRGBO(
//         r + ((ds < 0 ? r : (255 - r)) * ds).round(),
//         g + ((ds < 0 ? g : (255 - g)) * ds).round(),
//         b + ((ds < 0 ? b : (255 - b)) * ds).round(),
//         1,
//       );
//     }
//     return MaterialColor(color.value, swatch);
//   }
// }
