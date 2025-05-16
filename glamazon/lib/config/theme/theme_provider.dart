import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _fontFamily = 'Roboto'; // Default font
  static const String _themePreferenceKey = 'theme_preference';
  String get fontFamily => _fontFamily;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData {
    return _isDarkMode ? _darkTheme : _lightTheme;

  }

  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.sienna,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: AppColors.sienna,
      secondary: AppColors.teal,
      surface: Colors.white,
      background: Colors.grey[50]!,
      error: AppColors.error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.sienna,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.sienna),
      titleTextStyle: TextStyle(
        color: AppColors.darkText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.sienna,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.sienna,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.sienna, width: 2),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.teal[700],
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme.dark(
      primary: Colors.teal[700]!,
      secondary: Colors.tealAccent,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      error: AppColors.error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.tealAccent,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.tealAccent, width: 2),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemePreference();
    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
    _fontFamily = prefs.getString('fontFamily') ?? 'Roboto';
    notifyListeners();
  }

    Future<void> setSystemTheme(BuildContext context) async {
    final brightness = MediaQuery.of(context).platformBrightness;
    _isDarkMode = brightness == Brightness.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePreferenceKey, _isDarkMode);
  }

    Future<void> setFont(String fontFamily) async {
    _fontFamily = fontFamily;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', fontFamily);
    notifyListeners();
  }
}


// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'light_theme.dart';
// import 'dark_theme.dart';

// class ThemeProvider with ChangeNotifier {
//   bool _isDarkMode = false;
//   String _fontFamily = 'Roboto'; // Default font
  
//   bool get isDarkMode => _isDarkMode;
//   String get fontFamily => _fontFamily;
  
//   ThemeData get themeData {
//     // Start with the base theme
//     final baseTheme = _isDarkMode ? darkTheme : lightTheme;
    
//     // Create a new theme with the updated font family
//     return baseTheme.copyWith(
//       textTheme: baseTheme.textTheme.apply(
//         fontFamily: _fontFamily,
//       ),
//       primaryTextTheme: baseTheme.primaryTextTheme.apply(
//         fontFamily: _fontFamily,
//       ),
//     );
//   }
    
//   ThemeProvider() {
//     _loadPreferences();
//   }
  
//   Future<void> _loadPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     _isDarkMode = prefs.getBool('isDarkMode') ?? false;
//     _fontFamily = prefs.getString('fontFamily') ?? 'Roboto';
//     notifyListeners();
//   }
  
//   Future<void> toggleTheme() async {
//     _isDarkMode = !_isDarkMode;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isDarkMode', _isDarkMode);
//     notifyListeners();
//   }
  
//   Future<void> setSystemTheme(BuildContext context) async {
//     final brightness = MediaQuery.of(context).platformBrightness;
//     _isDarkMode = brightness == Brightness.dark;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isDarkMode', _isDarkMode);
//     notifyListeners();
//   }
  
//   Future<void> setFont(String fontFamily) async {
//     _fontFamily = fontFamily;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('fontFamily', fontFamily);
//     notifyListeners();
//   }
// }
