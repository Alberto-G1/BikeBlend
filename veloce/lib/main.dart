import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veloce/screens/routes.dart';
import 'package:veloce/theme/app_theme.dart';
import 'package:veloce/screens/splash_screen.dart';
import 'package:veloce/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final themeMode = prefs.getString('themeMode') ?? 'system';
  runApp(MyApp(initialTheme: themeMode));
}

class MyApp extends StatefulWidget {
  final String initialTheme;
  const MyApp({super.key, required this.initialTheme});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = _getThemeMode(widget.initialTheme);
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

  void _updateTheme(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode);
    setState(() => _themeMode = _getThemeMode(mode));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veloce',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      routes: appRoutes,
      // 🔥 Here’s the magic for dynamic arguments like SettingsScreen
      onGenerateRoute: (settings) {
        if (settings.name == '/settings') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => SettingsScreen(
              isDarkMode: args['isDarkMode'],
              onThemeToggle: args['onThemeToggle'],
            ),
          );
        }
        return null; // fallback for unknown routes
      },
      home: SplashScreen(onThemeChange: _updateTheme),
    );
  }
}
