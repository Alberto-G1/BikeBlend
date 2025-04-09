// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:bike_blend/main.dart';
import 'package:bike_blend/providers/theme_provider.dart';

void main() {
  testWidgets('App initializes with onboarding screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const BikeBlendApp(),
      ),
    );

    // Verify that the onboarding screen appears
    expect(find.text('BikeBlend'), findsOneWidget);
    
    // You might also want to check for specific onboarding elements
    expect(find.byType(PageView), findsOneWidget);
  });

  testWidgets('Theme toggle works correctly', (WidgetTester tester) async {
    // Build our app with the ThemeProvider
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const BikeBlendApp(),
      ),
    );

    // Navigate to settings (this would need to be adapted based on your actual navigation)
    // For example, if you need to login first, then navigate to home, then settings
    
    // This is a simplified example - you'll need to adjust based on your actual UI flow
    // await tester.tap(find.byIcon(Icons.person));
    // await tester.pumpAndSettle();
    // await tester.tap(find.text('Settings'));
    // await tester.pumpAndSettle();
    
    // Check if theme mode dropdown exists
    // expect(find.text('Theme Mode'), findsOneWidget);
    
    // Test theme switching functionality
    // This would need to be implemented based on your actual UI
  });
}
