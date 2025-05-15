import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences _prefs;
  
  // Initialize shared preferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Theme preferences
  static Future<void> setDarkMode(bool isDarkMode) async {
    await _prefs.setBool('isDarkMode', isDarkMode);
  }
  
  static bool getDarkMode() {
    return _prefs.getBool('isDarkMode') ?? false;
  }
  
  // Font preferences
  static Future<void> setFontFamily(String fontFamily) async {
    await _prefs.setString('fontFamily', fontFamily);
  }
  
  static String getFontFamily() {
    return _prefs.getString('fontFamily') ?? 'Roboto';
  }
  
  // Auth preferences
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    await _prefs.setBool('isLoggedIn', isLoggedIn);
  }
  
  static bool getLoggedIn() {
    return _prefs.getBool('isLoggedIn') ?? false;
  }
  
  // Clear all preferences
  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
