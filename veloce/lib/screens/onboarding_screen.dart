import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloce/theme/theme_manager.dart';
import 'package:veloce/utils/animations.dart';
import 'package:veloce/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Veloce',
      description: 'The easiest way to rent bikes and explore the city at your own pace.',
      image: Icons.pedal_bike_rounded,
      backgroundColor: Color(0xFFFF6B57),
    ),
    OnboardingPage(
      title: 'Scan & Unlock',
      description: 'Simply scan the QR code on any Veloce bike to start your journey.',
      image: Icons.qr_code_scanner,
      backgroundColor: Color(0xFFD85F92),
    ),
    OnboardingPage(
      title: 'Track Your Rides',
      description: 'Monitor your route, distance, and cost in real-time.',
      image: Icons.map_outlined,
      backgroundColor: Color(0xFF5B9EFF),
    ),
    OnboardingPage(
      title: 'Eco-Friendly',
      description: 'Join us in reducing carbon emissions and making cities greener.',
      image: Icons.eco_outlined,
      backgroundColor: Color(0xFF4CAF50),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      AnimationUtils.scaleTransition(const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final isDark = themeManager.isDarkMode;
    
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(
                _pages[index],
                isDark,
              );
            },
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildDot(index),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _currentPage > 0
                          ? TextButton(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            )
                          : const SizedBox(width: 80),
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: _pages[_currentPage].backgroundColor,
                        ),
                        child: Text(
                          _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _currentPage < _pages.length - 1
                          ? TextButton(
                              onPressed: _goToLogin,
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            )
                          : const SizedBox(width: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, bool isDark) {
    return Container(
      color: isDark ? Colors.black : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: page.backgroundColor.withOpacity(isDark ? 0.8 : 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                page.image,
                size: 100,
                color: isDark ? Colors.white : page.backgroundColor,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  page.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: page.backgroundColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  page.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.black54,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? _pages[_currentPage].backgroundColor
            : Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData image;
  final Color backgroundColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
  });
}
