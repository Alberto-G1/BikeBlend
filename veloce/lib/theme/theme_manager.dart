import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

class ThemeManager extends ChangeNotifier {
  late ThemeMode _themeMode;
  late String _fontFamily;
  
  ThemeMode get themeMode => _themeMode;
  String get fontFamily => _fontFamily;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  ThemeManager() {
    _themeMode = ThemeMode.system;
    _fontFamily = 'Poppins';
    _loadPreferences();
  }
  
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('themeMode') ?? 'system';
    _themeMode = _getThemeMode(themeString);
    _fontFamily = prefs.getString('fontFamily') ?? 'Poppins';
    notifyListeners();
  }
  
  ThemeMode _getThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
  
  Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode);
    _themeMode = _getThemeMode(mode);
    notifyListeners();
  }
  
  Future<void> setFontFamily(String fontFamily) async {
    if (!AppTheme.availableFonts.contains(fontFamily)) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', fontFamily);
    _fontFamily = fontFamily;
    notifyListeners();
  }
  
  ThemeData getLightTheme() {
    return AppTheme.getTheme(isDark: false, fontFamily: _fontFamily);
  }
  
  ThemeData getDarkTheme() {
    return AppTheme.getTheme(isDark: true, fontFamily: _fontFamily);
  }
  
  void toggleTheme() {
    final newMode = isDarkMode ? 'light' : 'dark';
    setThemeMode(newMode);
  }
}
