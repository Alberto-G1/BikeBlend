import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Find a Ride',
      'desc': 'Locate nearby bikes and unlock in seconds with Veloce.',
      'image': 'assets/onboard1.png',
    },
    {
      'title': 'Scan and Go',
      'desc': 'Use the in-app scanner to securely unlock your bike.',
      'image': 'assets/onboard2.png',
    },
    {
      'title': 'Track Your Journey',
      'desc': 'See your ride history, CO₂ savings, and stats.',
      'image': 'assets/onboard3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: onboardingData.length,
                    itemBuilder: (_, index) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            Image.asset(
                              onboardingData[index]['image']!,
                              height: size.height * 0.4,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 30),
                            Text(
                              onboardingData[index]['title']!,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                onboardingData[index]['desc']!,
                                style: theme.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(onboardingData.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      height: 10,
                      width: _currentPage == index ? 30 : 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? theme.colorScheme.primary
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }),
                ),
                if (_currentPage == 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 55),
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const LoginScreen(),
                            transitionsBuilder: (_, anim, __, child) => FadeTransition(
                              opacity: anim,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: const Text('Get Started',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
