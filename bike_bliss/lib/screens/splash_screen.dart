import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bike_bliss/screens/onboarding_screen.dart';
import 'package:bike_bliss/theme/app_theme.dart';
import 'package:bike_bliss/utils/page_transitions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        FadePageRoute(page: const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF121212),
                    const Color(0xFF1E1E1E),
                    const Color(0xFF2A2A2A),
                  ]
                : [
                    const Color(0xFFF8F9FA),
                    const Color(0xFFF1E6EA),
                    const Color(0xFFE9D8E4),
                  ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_qdcacwgx.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'BikeBliss',
                    textStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                      letterSpacing: 1.5,
                    ),
                    speed: const Duration(milliseconds: 200),
                  ),
                ],
                totalRepeatCount: 1,
              ),
              const SizedBox(height: 16),
              AnimatedTextKit(
                animatedTexts: [
                  FadeAnimatedText(
                    'Ride. Share. Enjoy.',
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                    ),
                    duration: const Duration(milliseconds: 2000),
                  ),
                ],
                totalRepeatCount: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
