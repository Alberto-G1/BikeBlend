import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glamazon/reusable_widgets/loaders/loading_overlay.dart';
import 'package:glamazon/reusable_widgets/loaders/success_message.dart';
import 'package:glamazon/reusable_widgets/reusable_widgets.dart';
import 'package:glamazon/screens/customer_profile_creation.dart';
import 'package:glamazon/screens/customer_signin.dart';
import 'package:glamazon/reusable_widgets/animations/animations.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:glamazon/utils/constants.dart';
import 'package:glamazon/utils/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:glamazon/config/theme/theme_provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
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
    _usernameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordController.dispose();
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
          'Create Account',
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode ? Colors.white : AppColors.sienna,
          ),
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: "Creating your account...",
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
                      
                      const SizedBox(height: AppConstants.largeSpacing),
                      
                      // Welcome text with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          "Join Glamazon",
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
                          "Create an account to get started",
                          style: TextStyle(
                            fontSize: AppConstants.mediumFontSize,
                            color: themeProvider.isDarkMode 
                                ? Colors.grey[300] 
                                : Colors.black54,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
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
                      
                      // Username field with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 200),
                        child: CustomTextField(
                          controller: _usernameTextController,
                          labelText: "Username",
                          hintText: "Enter your username",
                          prefixIcon: const Icon(Icons.person_outline),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.mediumSpacing),
                      
                      // Email field with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 250),
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
                        delay: const Duration(milliseconds: 300),
                        child: CustomTextField(
                          controller: _passwordTextController,
                          labelText: "Password",
                          hintText: "Enter your password",
                          isPassword: true,
                          prefixIcon: const Icon(Icons.lock_outline),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.mediumSpacing),
                      
                      // Confirm Password field with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 350),
                        child: CustomTextField(
                          controller: _confirmPasswordController,
                          labelText: "Confirm Password",
                          hintText: "Confirm your password",
                          isPassword: true,
                          prefixIcon: const Icon(Icons.lock_outline),
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            if (_formKey.currentState!.validate()) {
                              _signUp();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordTextController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Sign up button with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 400),
                        child: CustomButton(
                          text: "CREATE ACCOUNT",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _signUp();
                            }
                          },
                          isLoading: _isLoading,
                          icon: Icons.person_add,
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Sign in option with animation
                      AppAnimations.fadeIn(
                        animate: _animate,
                        delay: const Duration(milliseconds: 450),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: themeProvider.isDarkMode 
                                    ? Colors.grey[300] 
                                    : const Color(0xffbe4a21),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignIn()),
                                );
                              },
                              child: const Text(
                                " LOGIN",
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

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text,
      );
      
      // Send email verification
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      
      if (mounted) {
        SuccessMessage.show(
          context, 
          "Account created successfully! A verification email has been sent."
        );
        
        // Navigate with animation
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ProfileCreationScreen(),
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
          case 'email-already-in-use':
            _errorMessage = 'The email address is already in use by another account.';
            break;
          case 'invalid-email':
            _errorMessage = 'The email address is not valid.';
            break;
          case 'weak-password':
            _errorMessage = 'The password is too weak. It should be at least 6 characters long.';
            break;
          case 'operation-not-allowed':
            _errorMessage = 'This sign-up method is not allowed.';
            break;
          case 'network-request-failed':
            _errorMessage = 'Network error. Please check your internet connection.';
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
// import 'package:glamazon/screens/profile-edit.dart';
// import 'package:glamazon/screens/signin.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final TextEditingController _usernameTextController = TextEditingController();
//   final TextEditingController _emailTextController = TextEditingController();
//   final TextEditingController _passwordTextController = TextEditingController();
//   bool _isLoading = false;
//   String? _errorMessage; // Added variable to store error message

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       backgroundColor: const Color.fromARGB(255, 248, 236, 220),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           'Sign Up',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: const BoxDecoration(
//           color: Color.fromARGB(255, 250, 227, 197),
//         ),
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(
//                       20, MediaQuery.of(context).size.height * 0.1, 20, 0),
//                   child: Column(
//                     children: <Widget>[
//                       if (_errorMessage != null) // Display error message at the top
//                         Container(
//                           padding: const EdgeInsets.symmetric(vertical: 10.0),
//                           child: Text(
//                             _errorMessage!,
//                             style: const TextStyle(color: Colors.red, fontSize: 16.0),
//                           ),
//                         ),
//                       logoWidget("assets/images/logo3.png"),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       reusableTextField("Enter Username", Icons.person_2_outlined,
//                           false, _usernameTextController),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       reusableTextField("Enter Email", Icons.email_outlined, false,
//                           _emailTextController),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       reusableTextField("Enter Password", Icons.lock_outlined, true,
//                           _passwordTextController),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       signInSignUpButton(context, false, () {
//                         _signUp();
//                       }),
//                       signUpOption(),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   Future<void> _signUp() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null; // Reset error message on new attempt
//     });

//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailTextController.text,
//         password: _passwordTextController.text,
//       );

//       // Send email verification
//       User? user = userCredential.user;
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//         print("Verification email sent");
//       }

//       // Navigate to profile edit screen or other page
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
//       );
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         switch (e.code) {
//           case 'email-already-in-use':
//             _errorMessage = 'The email address is already in use by another account.';
//             break;
//           case 'invalid-email':
//             _errorMessage = 'The email address is not valid.';
//             break;
//           case 'weak-password':
//             _errorMessage = 'The password is too weak. It should be at least 6 characters long.';
//             break;
//           case 'operation-not-allowed':
//             _errorMessage = 'This sign-up method is not allowed.';
//             break;
//           case 'network-request-failed':
//             _errorMessage = 'Network error. Please check your internet connection.';
//             break;
//           default:
//             _errorMessage = 'An unknown error occurred. Please try again.';
//             break;
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'An error occurred. Please try again later.';
//       });
//       print("Error: ${e.toString()}");
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
//           'Have an account?',
//           style: TextStyle(color: Color(0xffbe4a21)),
//         ),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const SignIn()),
//             );
//           },
//           child: const Text(
//             ' LOGIN',
//             style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }
