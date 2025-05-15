import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glamazon/reusable_widgets/loaders/loading_overlay.dart';
import 'package:glamazon/reusable_widgets/loaders/success_message.dart';
import 'package:glamazon/reusable_widgets/reusable_widgets.dart';
import 'package:glamazon/screens/salonownerhome%20copy.dart';
import 'package:glamazon/screens/ownersignup.dart';
import 'package:glamazon/utils/animations.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:glamazon/utils/constants.dart';
import 'package:glamazon/utils/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:glamazon/config/theme/theme_provider.dart';

class SalonOwnerLogin extends StatefulWidget {
  const SalonOwnerLogin({super.key});

  @override
  _SalonOwnerLoginState createState() => _SalonOwnerLoginState();
}

class _SalonOwnerLoginState extends State<SalonOwnerLogin> with SingleTickerProviderStateMixin {
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
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? Colors.black : AppColors.sienna,
        elevation: 0,
        title: const Text(
          'Salon Owner Login',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppConstants.largeSpacing,
                    MediaQuery.of(context).size.height * 0.05,
                    AppConstants.largeSpacing,
                    AppConstants.largeSpacing
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        // Logo with animation
                        AppAnimations.scale(
                          animate: _animate,
                          child: logoWidget("assets/images/logo3.png"),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Welcome text with animation
                        AppAnimations.slideIn(
                          animate: _animate,
                          beginOffset: const Offset(0, 0.2),
                          delay: const Duration(milliseconds: 100),
                          child: Text(
                            "Salon Owner Portal",
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
                            "Login to manage your salon",
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
                            prefixIcon: const Icon(Icons.lock_outlined),
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              if (_formKey.currentState!.validate()) {
                                _login();
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
                        
                        const SizedBox(height: AppConstants.largeSpacing),
                        
                        // Login button with animation
                        AppAnimations.slideIn(
                          animate: _animate,
                          beginOffset: const Offset(0, 0.2),
                          delay: const Duration(milliseconds: 300),
                          child: CustomButton(
                            text: "LOGIN",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _login();
                              }
                            },
                            isLoading: _isLoading,
                            // backgroundColor: const Color(0xff089be3),
                            icon: Icons.login,
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Sign up option with animation
                        AppAnimations.fadeIn(
                          animate: _animate,
                          delay: const Duration(milliseconds: 350),
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
                                    MaterialPageRoute(builder: (context) => const SalonOwnerSignUp()),
                                  );
                                },
                                child: const Text(
                                  "   SIGN UP",
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text,
      );
      
      // Check the role of the user
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('owners')
          .doc(userCredential.user?.uid)
          .get();
          
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String? role = userData['role'];
        
        if (role == 'salon_owner') {
          if (mounted) {
            SuccessMessage.show(context, "Successfully logged in!");
            
            // Navigate with animation
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const SalonOwnerHome(),
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
        } else {
          setState(() {
            _errorMessage = 'You do not have permission to log in from this screen.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'No salon owner account found for this email.';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            _errorMessage = 'No user found with this email.';
            break;
          case 'wrong-password':
            _errorMessage = 'Wrong password provided.';
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



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:glamazon/screens/salonownerhome%20copy.dart';
// import 'ownersignup.dart';

// class SalonOwnerLogin extends StatefulWidget {
//   const SalonOwnerLogin({super.key});

//   @override
//   _SalonOwnerLoginState createState() => _SalonOwnerLoginState();
// }

// class _SalonOwnerLoginState extends State<SalonOwnerLogin> {
//   final TextEditingController _emailTextController = TextEditingController();
//   final TextEditingController _passwordTextController = TextEditingController();
//   bool _isLoading = false;
//   String? _errorMessage;

//   Future<void> _login() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null; // Clear previous error messages
//     });

//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailTextController.text,
//         password: _passwordTextController.text,
//       );

//       // Check the role of the user
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('owners')
//           .doc(userCredential.user?.uid)
//           .get();

//       if (userDoc.exists) {
//         String? role = userDoc['role'];
//         if (role == 'salon_owner') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const SalonOwnerHome()),
//           );
//         } else {
//           setState(() {
//             _errorMessage = 'You do not have permission to log in from this screen.';
//           });
//         }
//       } else {
//         setState(() {
//           _errorMessage = 'No user found for this email.';
//         });
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         setState(() {
//           _errorMessage = 'No user found for that email.';
//         });
//       } else if (e.code == 'wrong-password') {
//         setState(() {
//           _errorMessage = 'Wrong password provided.';
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'Error: ${e.message}';
//         });
//       }
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Salon Login'),
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: const BoxDecoration(
//           color: Color.fromARGB(255, 250, 227, 197),
//         ),
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(
//                     20, MediaQuery.of(context).size.height * 0.1, 20, 0),
//                 child: Column(
//                   children: <Widget>[
//                     logoWidget("assets/images/logo3.png"),
//                     const SizedBox(height: 30),
//                     reusableTextField("Enter Email", Icons.email_outlined, false,
//                         _emailTextController),
//                     const SizedBox(height: 20),
//                     reusableTextField("Enter Password", Icons.lock_outlined, true,
//                         _passwordTextController),
//                     const SizedBox(height: 20),
//                     _isLoading
//                         ? const CircularProgressIndicator()
//                         : ElevatedButton(
//                             onPressed: _login,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xff089be3),
//                               foregroundColor: Colors.white,
//                             ),
//                             child: const Text('Login'),
//                           ),
//                     signUpOption(context),
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ),
//             if (_errorMessage != null)
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   color: Colors.red[100],
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error_outline, color: Colors.red[700]),
//                       const SizedBox(width: 8),
//                       Flexible(
//                         child: Text(
//                           _errorMessage!,
//                           style: TextStyle(color: Colors.red[700]),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Row signUpOption(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text(
//           'Don\'t have an account?',
//           style: TextStyle(color: Color(0xffd05325)),
//         ),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const SalonOwnerSignUp()),
//             );
//           },
//           child: const Text(
//             '   SIGN UP',
//             style: TextStyle(
//                 color: Color(0xff089be3), fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }
