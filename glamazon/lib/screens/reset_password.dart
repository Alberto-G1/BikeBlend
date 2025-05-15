import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glamazon/reusable_widgets/loaders/loading_overlay.dart';
import 'package:glamazon/reusable_widgets/loaders/success_message.dart';
import 'package:glamazon/reusable_widgets/reusable_widgets.dart';
import 'package:glamazon/utils/animations.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:glamazon/utils/constants.dart';
import 'package:glamazon/utils/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:glamazon/config/theme/theme_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _animate = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppConstants.mediumAnimationDuration,
    );
    
    // Start animations after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _animate = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: themeProvider.isDarkMode ? Colors.white : AppColors.sienna,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode ? Colors.white : AppColors.sienna,
          ),
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: "Sending reset link...",
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeProvider.isDarkMode 
                    ? const Color(0xFF2D2D2D) 
                    : const Color.fromARGB(255, 250, 227, 197),
                themeProvider.isDarkMode 
                    ? const Color(0xFF1A1A1A) 
                    : const Color.fromARGB(255, 245, 215, 175),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.largeSpacing),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Logo with animation
                      AppAnimations.scale(
                        animate: _animate,
                        child: logoWidget("assets/images/logo3.png"),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Title with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          "Forgot Your Password?",
                          style: TextStyle(
                            fontSize: AppConstants.titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkMode 
                                ? Colors.white 
                                : AppColors.sienna,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.mediumSpacing),
                      
                      // Subtitle with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 150),
                        child: Text(
                          "Enter your email and we'll send you a link to reset your password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppConstants.mediumFontSize,
                            color: themeProvider.isDarkMode 
                                ? Colors.grey[300] 
                                : Colors.black54,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Error message
                      if (_errorMessage != null)
                        AppAnimations.fadeIn(
                          animate: true,
                          child: Container(
                            padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red),
                                const SizedBox(width: AppConstants.smallSpacing),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      if (_errorMessage != null)
                        const SizedBox(height: AppConstants.mediumSpacing),
                      
                      // Success message
                      if (_successMessage != null)
                        AppAnimations.fadeIn(
                          animate: true,
                          child: Container(
                            padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                              border: Border.all(color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.green),
                                const SizedBox(width: AppConstants.smallSpacing),
                                Expanded(
                                  child: Text(
                                    _successMessage!,
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      if (_successMessage != null)
                        const SizedBox(height: AppConstants.mediumSpacing),
                      
                      // Email field with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 200),
                        child: CustomTextField(
                          controller: _emailTextController,
                          labelText: "Email",
                          hintText: "Enter your email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            if (_formKey.currentState!.validate()) {
                              _resetPassword();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Reset button with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 250),
                        child: CustomButton(
                          text: "SEND RESET LINK",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _resetPassword();
                            }
                          },
                          isLoading: _isLoading,
                          icon: Icons.send,
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Back to login with animation
                      AppAnimations.fadeIn(
                        animate: _animate,
                        delay: const Duration(milliseconds: 300),
                        child: TextButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back, size: 18),
                          label: const Text(
                            "Back to Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });
    
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailTextController.text.trim(),
      );
      
      if (mounted) {
        setState(() {
          _successMessage = "Password reset link sent to your email!";
        });
        
        SuccessMessage.show(
          context, 
          "Password reset link sent to your email!"
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            _errorMessage = 'No user found with this email.';
            break;
          case 'invalid-email':
            _errorMessage = 'The email address is not valid.';
            break;
          default:
            _errorMessage = 'Error: ${e.message}';
            break;
        }
      });
      ErrorHandler.logError(e, null);
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
      ErrorHandler.logError(e, null);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
