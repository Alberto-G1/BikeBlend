import 'package:flutter/material.dart';
import 'package:veloce/screens/home_screen.dart';
import 'package:veloce/widgets/animated_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          isLogin ? 'Welcome Back 👋' : 'Create Account 🚴',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isLogin ? _loginForm() : _signupForm(),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            setState(() => isLogin = !isLogin);
                          },
                          child: Text(
                            isLogin
                                ? "Don't have an account? Sign Up"
                                : "Already have an account? Login",
                            style: TextStyle(color: theme.colorScheme.secondary),
                          ),
                        ),
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

  Widget _loginForm() {
    return Column(
      key: const ValueKey('login'),
      children: [
        _inputField(label: 'Email'),
        _inputField(label: 'Password', obscure: true),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Text('Forgot Password?', style: TextStyle(color: Colors.grey[600])),
        ),
        const SizedBox(height: 20),
        _actionButton('Login'),
      ],
    );
  }

  Widget _signupForm() {
    return Column(
      key: const ValueKey('signup'),
      children: [
        _inputField(label: 'Full Name'),
        _inputField(label: 'Email'),
        _inputField(label: 'Password', obscure: true),
        const SizedBox(height: 20),
        _actionButton('Sign Up'),
      ],
    );
  }

  Widget _inputField({required String label, bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _actionButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        Navigator.push(context, animatedSlideTransition(const HomeScreen()));

      },
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}
