import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bike_blend/providers/theme_provider.dart';
import 'package:bike_blend/theme/app_theme.dart';
import 'package:bike_blend/screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const BikeBlendApp(),
    ),
  );
}

class BikeBlendApp extends StatelessWidget {
  const BikeBlendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'BikeBlend',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const SplashScreen(),
        );
      },
    );
  }
}
