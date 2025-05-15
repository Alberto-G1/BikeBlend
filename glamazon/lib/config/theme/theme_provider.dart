import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  String _fontFamily = 'Roboto'; // Default font
  
  bool get isDarkMode => _isDarkMode;
  String get fontFamily => _fontFamily;
  
  ThemeData get themeData {
    // Start with the base theme
    final baseTheme = _isDarkMode ? darkTheme : lightTheme;
    
    // Create a new theme with the updated font family
    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        fontFamily: _fontFamily,
      ),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(
        fontFamily: _fontFamily,
      ),
    );
  }
    
  ThemeProvider() {
    _loadPreferences();
  }
  
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _fontFamily = prefs.getString('fontFamily') ?? 'Roboto';
    notifyListeners();
  }
  
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
  
  Future<void> setSystemTheme(BuildContext context) async {
    final brightness = MediaQuery.of(context).platformBrightness;
    _isDarkMode = brightness == Brightness.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
  
  Future<void> setFont(String fontFamily) async {
    _fontFamily = fontFamily;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', fontFamily);
    notifyListeners();
  }
}
