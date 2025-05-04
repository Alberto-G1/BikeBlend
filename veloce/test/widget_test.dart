// This is a basic Flutter widget test for the Veloce app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:veloce/main.dart';
import 'package:veloce/theme/theme_manager.dart';

// Mock ThemeManager for testing
class MockThemeManager extends Mock implements ThemeManager {
  @override
  ThemeMode get themeMode => ThemeMode.light;
  
  @override
  bool get isDarkMode => false;
  
  @override
  String get fontFamily => 'Poppins';
  
  @override
  ThemeData getLightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: const Color(0xFFFF6B57),
    );
  }
  
  @override
  ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: const Color(0xFFFF6B57),
    );
  }
}

void main() {
  testWidgets('Veloce app splash screen test', (WidgetTester tester) async {
    // Create a mock ThemeManager
    final mockThemeManager = MockThemeManager();
    
    // Build our app and trigger a frame with the mocked ThemeManager
    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeManager>.value(
        value: mockThemeManager,
        child: const MyApp(),
      ),
    );
    
    // Verify that the splash screen shows the app name
    expect(find.text('Veloce'), findsOneWidget);
    
    // Verify that the splash screen shows the bike icon
    expect(find.byIcon(Icons.pedal_bike_rounded), findsOneWidget);
    
    // Wait for the splash screen animation
    await tester.pump(const Duration(seconds: 3));
    
    // Pump the widget tree to trigger the navigation to onboarding
    await tester.pumpAndSettle();
    
    // Verify that we've navigated to the onboarding screen
    // This might need adjustment based on your actual onboarding screen content
    expect(find.text('Welcome to Veloce'), findsOneWidget);
  });
}
