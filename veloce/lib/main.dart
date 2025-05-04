import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloce/screens/routes.dart';
import 'package:veloce/screens/splash_screen.dart';
import 'package:veloce/screens/settings_screen.dart';
import 'package:veloce/theme/theme_manager.dart';
import 'package:veloce/utils/animations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    
    return MaterialApp(
      title: 'Veloce',
      theme: themeManager.getLightTheme(),
      darkTheme: themeManager.getDarkTheme(),
      themeMode: themeManager.themeMode,
      debugShowCheckedModeBanner: false,
      routes: appRoutes,
      onGenerateRoute: (settings) {
        if (settings.name == '/settings') {
          return AnimationUtils.slideTransition(
            SettingsScreen(
              themeManager: themeManager,
            ),
          );
        }
        
        // For other dynamic routes
        final routes = <String, WidgetBuilder>{
          // Add other routes that need dynamic parameters here
        };
        
        // If the route exists in our dynamic routes
        if (routes.containsKey(settings.name)) {
          return AnimationUtils.slideTransition(
            routes[settings.name]!(context),
          );
        }
        
        return null;
      },
      home: SplashScreen(),
    );
  }
}
