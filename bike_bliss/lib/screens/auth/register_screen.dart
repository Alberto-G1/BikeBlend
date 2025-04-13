import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:bike_bliss/theme/app_theme.dart';
import 'package:bike_bliss/utils/page_transitions.dart';
import 'package:bike_bliss/widgets/custom_text_field.dart';
import 'package:bike_bliss/screens/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate registration delay
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          SlidePageRoute(page: const MainScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
          ),
          
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Animation
                    Center(
                      child: Hero(
                        tag: 'logo',
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Lottie.network(
                              'https://assets10.lottiefiles.com/packages/lf20_qdcacwgx.json',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Welcome text
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Join BikeBliss and start your cycling adventure",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 30),
                          
                          // Registration form
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: _nameController,
                                  hintText: "Full Name",
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your name";
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                CustomTextField(
                                  controller: _emailController,
                                  hintText: "Email",
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your email";
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                CustomTextField(
                                  controller: _passwordController,
                                  hintText: "Password",
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: !_isPasswordVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                      color: AppTheme.primaryColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a password";
                                    }
                                    if (value.length < 6) {
                                      return "Password must be at least 6 characters";
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                CustomTextField(
                                  controller: _confirmPasswordController,
                                  hintText: "Confirm Password",
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: !_isConfirmPasswordVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                      color: AppTheme.primaryColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                      });
                                    },
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please confirm your password";
                                    }
                                    if (value != _passwordController.text) {
                                      return "Passwords do not match";
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 30),
                                
                                // Register button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _register,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : const Text(
                                            "Sign Up",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                                
                                const SizedBox(height: 30),
                                
                                // Terms and conditions
                                Text(
                                  "By signing up, you agree to our Terms of Service and Privacy Policy",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Login link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Text(
                                        "Sign In",
                                        style: TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
