import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glamazon/reusable_widgets/loaders/loading_overlay.dart';
import 'package:glamazon/reusable_widgets/loaders/success_message.dart';
import 'package:glamazon/reusable_widgets/reusable_widgets.dart';
import 'package:glamazon/screens/customer-home.dart';
import 'package:glamazon/screens/reset_password.dart';
import 'package:glamazon/screens/customer_signup.dart';
import 'package:glamazon/reusable_widgets/animations/animations.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:glamazon/utils/constants.dart';
import 'package:glamazon/utils/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:glamazon/config/theme/theme_provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
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
    _passwordTextController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: "Signing in...",
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Logo with animation
                      AppAnimations.scale(
                        animate: _animate,
                        child: logoWidget("assets/images/logo3.png"),
                      ),
                      
                      SizedBox(height: 30),
                      
                      // Welcome text with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          "Welcome Back",
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
                          "Sign in to continue",
                          style: TextStyle(
                            fontSize: AppConstants.mediumFontSize,
                            color: themeProvider.isDarkMode 
                                ? Colors.grey[300] 
                                : Colors.black54,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 30),
                      
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
                          textInputAction: TextInputAction.next,
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
                      
                      const SizedBox(height: AppConstants.mediumSpacing),
                      
                      // Password field with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 250),
                        child: CustomTextField(
                          controller: _passwordTextController,
                          labelText: "Password",
                          hintText: "Enter your password",
                          isPassword: true,
                          prefixIcon: const Icon(Icons.lock_outline),
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            if (_formKey.currentState!.validate()) {
                              _signIn();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.mediumSpacing),
                      
                      // Forgot password with animation
                      AppAnimations.fadeIn(
                        animate: _animate,
                        delay: const Duration(milliseconds: 300),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: AppColors.sienna,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.largeSpacing),
                      
                      // Sign in button with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 350),
                        child: CustomButton(
                          text: "SIGN IN",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _signIn();
                            }
                          },
                          isLoading: _isLoading,
                          icon: Icons.login,
                        ),
                      ),
                      
                      SizedBox(height: 30),
                      
                      // Sign up option with animation
                      AppAnimations.fadeIn(
                        animate: _animate,
                        delay: const Duration(milliseconds: 400),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: themeProvider.isDarkMode 
                                    ? Colors.grey[300] 
                                    : const Color(0xffd05325),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUp()),
                                );
                              },
                              child: const Text(
                                "  SIGN UP ",
                                style: TextStyle(
                                  color: Color(0xff089be3),
                                  fontWeight: FontWeight.bold,
                                ),
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
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text,
      );
      
      if (mounted) {
        SuccessMessage.show(context, "Successfully signed in!");
        
        // Navigate with animation
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ImageSlider(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'wrong-password':
            _errorMessage = 'Incorrect password. Please try again.';
            break;
          case 'user-not-found':
            _errorMessage = 'No user found with this email.';
            break;
          case 'invalid-email':
            _errorMessage = 'Invalid email address.';
            break;
          case 'user-disabled':
            _errorMessage = 'This user account has been disabled.';
            break;
          case 'too-many-requests':
            _errorMessage = 'Too many login attempts. Please try again later.';
            break;
          default:
            _errorMessage = 'An error occurred. Please try again.';
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




// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:glamazon/screens/customer-home.dart';
// import 'package:glamazon/screens/signup.dart';

// class SignIn extends StatefulWidget {
//   const SignIn({super.key});

//   @override
//   State<SignIn> createState() => _SignInState();
// }

// class _SignInState extends State<SignIn> {
//   final TextEditingController _emailTextController = TextEditingController();
//   final TextEditingController _passwordTextController = TextEditingController();
//   bool _isLoading = false;
//   String? _errorMessage; // Variable to store error message

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 248, 236, 220),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: const BoxDecoration(
//           color: Color.fromARGB(255, 250, 227, 197), // Single background color
//         ),
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(
//                       20, MediaQuery.of(context).size.height * 0.1, 20, 0),
//                   child: Column(
//                     children: <Widget>[
//                       logoWidget("assets/images/logo3.png"),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       if (_errorMessage != null) // Display error message above text inputs
//                         Container(
//                           padding: const EdgeInsets.symmetric(vertical: 10.0),
//                           child: Text(
//                             _errorMessage!,
//                             style: const TextStyle(color: Colors.red, fontSize: 16.0),
//                           ),
//                         ),
//                       reusableTextField("Enter Your Email", Icons.email_outlined,
//                           false, _emailTextController),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       reusableTextField("Enter Password", Icons.lock_outlined, true,
//                           _passwordTextController),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           _signIn();
//                         },
//                         child: const Text("Sign In"),
//                       ),
//                       signUpOption(),
//                       const SizedBox(
//                         height: 40,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   Future<void> _signIn() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null; // Reset error message on new attempt
//     });

//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailTextController.text,
//         password: _passwordTextController.text,
//       );

//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const ImageSlider()),
//       );
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         switch (e.code) {
//           case 'wrong-password':
//             _errorMessage = 'Incorrect password. Please try again.';
//             break;
//           case 'user-not-found':
//             _errorMessage = 'No user found with this email.';
//             break;
//           case 'invalid-email':
//             _errorMessage = 'Invalid email address.';
//             break;
//           case 'user-disabled':
//             _errorMessage = 'This user account has been disabled.';
//             break;
//           case 'too-many-requests':
//             _errorMessage = 'Too many login attempts. Please try again later.';
//             break;
//           default:
//             _errorMessage = 'An error occurred. Please try again.';
//             break;
//         }
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Row signUpOption() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text(
//           'Don\'t Have an account?',
//           style: TextStyle(color: Color(0xffd05325)),
//         ),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const SignUp()),
//             );
//           },
//           child: const Text(
//             '  SIGN UP ',
//             style: TextStyle(
//                 color: Color(0xff089be3), fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }
