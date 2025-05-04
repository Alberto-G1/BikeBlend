import 'package:flutter/material.dart';
import 'package:veloce/screens/home_screen.dart';
import 'package:veloce/utils/animations.dart';
import 'package:veloce/widgets/animated_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
  
  void _toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
    _animationController.reset();
    _animationController.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo and header section
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            _buildLogo(theme),
                            const SizedBox(height: 30),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideInAnimation(
                                direction: SlideDirection.down,
                                offset: 50,
                                child: Text(
                                  isLogin ? 'Welcome Back 👋' : 'Create Account 🚴',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text(
                                isLogin 
                                    ? 'Sign in to continue your journey'
                                    : 'Join us and start your biking adventure',
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black54,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        
                        // Form section
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0, 0.2),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: isLogin ? _loginForm() : _signupForm(),
                                ),
                                const SizedBox(height: 20),
                                AnimatedCard(
                                  child: TextButton(
                                    onPressed: _toggleAuthMode,
                                    child: Text(
                                      isLogin
                                          ? "Don't have an account? Sign Up"
                                          : "Already have an account? Login",
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Copyright section
                        _buildCopyright(isDark),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildLogo(ThemeData theme) {
    return Column(
      children: [
        PulseAnimation(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pedal_bike_rounded,
              size: 60,
              color: theme.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Veloce',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCopyright(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            '© 2023 Veloce',
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black45,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Developed by L@ GR@NDE',
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black45,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Column(
      key: const ValueKey('login'),
      children: [
        _inputField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        _inputField(
          controller: _passwordController,
          label: 'Password',
          icon: Icons.lock_outline,
          obscure: true,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Forgot password functionality
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _actionButton('LOGIN'),
        const SizedBox(height: 20),
        _buildSocialLogin(),
      ],
    );
  }

  Widget _signupForm() {
    return Column(
      key: const ValueKey('signup'),
      children: [
        _inputField(
          controller: _nameController,
          label: 'Full Name',
          icon: Icons.person_outline,
        ),
        _inputField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        _inputField(
          controller: _passwordController,
          label: 'Password',
          icon: Icons.lock_outline,
          obscure: true,
        ),
        const SizedBox(height: 20),
        _actionButton('SIGN UP'),
        const SizedBox(height: 20),
        _buildSocialLogin(),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String text) {
    return AnimatedCard(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        onPressed: () {
          Navigator.push(
            context, 
            AnimationUtils.slideTransition(const HomeScreen())
          );
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
  
  Widget _buildSocialLogin() {
    return Column(
      children: [
        Text(
          'Or continue with',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialButton(Icons.g_mobiledata, 'Google'),
            const SizedBox(width: 16),
            _socialButton(Icons.facebook, 'Facebook'),
          ],
        ),
      ],
    );
  }
  
  Widget _socialButton(IconData icon, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
