import 'package:flutter/material.dart';
import 'package:glamazon/screens/splash.dart';
import 'package:glamazon/screens/profile_page.dart'; 
import 'package:glamazon/screens/edit_profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'firebase_options.dart';

// Initialize Firebase and set up FCM
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set up FCM
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  // Request permissions (iOS only)
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApplication(),
    ),
  );
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the theme provider
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      theme: themeProvider.isDarkMode ? themeProvider.themeData : themeProvider.themeData,
      darkTheme: themeProvider.isDarkMode ? themeProvider.themeData : themeProvider.themeData,
      themeMode: ThemeMode.system,
      home: const Splash(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/profile': (context) => const ProfilePage(),
        '/edit-profile': (context) => const EditProfilePage(),
      },
    );
  }
}
