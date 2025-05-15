import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glamazon/reusable_widgets/loaders/loading_overlay.dart';
import 'package:glamazon/reusable_widgets/loaders/success_message.dart';
import 'package:glamazon/reusable_widgets/reusable_widgets.dart';
import 'package:glamazon/screens/edit_profile_page.dart';
import 'package:glamazon/screens/salonownerlogin.dart';
import 'package:glamazon/utils/animations.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:glamazon/utils/constants.dart';
import 'package:glamazon/utils/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:glamazon/config/theme/theme_provider.dart';

class SalonOwnerSignUp extends StatefulWidget {
  const SalonOwnerSignUp({super.key});

  @override
  _SalonOwnerSignUpState createState() => _SalonOwnerSignUpState();
}

class _SalonOwnerSignUpState extends State<SalonOwnerSignUp> with SingleTickerProviderStateMixin {
  final TextEditingController _salonNameController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
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
    _salonNameController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
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
          'Register as Salon Owner',
          style: TextStyle(
            fontSize: 22, 
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
                          "Salon Owner Registration",
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
                          "Create an account to list your salon",
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
                      
                      // Salon Name field with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 200),
                        child: CustomTextField(
                          controller: _salonNameController,
                          labelText: "Salon Name",
                          hintText: "Enter your salon name",
                          prefixIcon: const Icon(Icons.business),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your salon name';
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
                      
                      // Phone field with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 300),
                        child: CustomTextField(
                          controller: _phoneController,
                          labelText: "Phone Number",
                          hintText: "Enter your phone number",
                          prefixIcon: const Icon(Icons.phone),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                              return 'Please enter a valid phone number';
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
                        delay: const Duration(milliseconds: 350),
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
                        delay: const Duration(milliseconds: 400),
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
                      
                      const SizedBox(height: 60),
                      
                      // Sign up button with animation
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 450),
                        child: CustomButton(
                          text: "REGISTER",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _signUp();
                            }
                          },
                          isLoading: _isLoading,
                          // backgroundColor: const Color(0xff089be3),
                          icon: Icons.business_center,
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Sign in option with animation
                      AppAnimations.fadeIn(
                        animate: _animate,
                        delay: const Duration(milliseconds: 500),
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
                                  MaterialPageRoute(builder: (context) => const SalonOwnerLogin()),
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
      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text,
      );
      
      // Store additional salon owner information in Firestore
      await FirebaseFirestore.instance.collection('owners').doc(userCredential.user!.uid).set({
        'salonName': _salonNameController.text.trim(),
        'email': _emailTextController.text.trim(),
        'phone': _phoneController.text.trim(),
        'role': 'salon_owner',
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending', // Pending approval from admin
      });
      
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
            pageBuilder: (context, animation, secondaryAnimation) => const EditProfilePage(),
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
// import 'package:glamazon/screens/edit_profile_page.dart';
// import 'package:glamazon/screens/salonownerlogin.dart';

// class SalonOwnerSignUp extends StatefulWidget {
//   const SalonOwnerSignUp({super.key});

//   @override
//   _SalonOwnerSignUpState createState() => _SalonOwnerSignUpState();
// }

// class _SalonOwnerSignUpState extends State<SalonOwnerSignUp> {
//   final TextEditingController _emailTextController = TextEditingController();
//   final TextEditingController _passwordTextController = TextEditingController();
//   final TextEditingController _confirmPasswordTextController = TextEditingController();
//   bool _isLoading = false;
//   String? _errorMessage;
//   String? _successMessage; // Added variable to store success message

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: const BoxDecoration(
//           color: Color.fromARGB(255, 250, 227, 197),
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(
//                 20, MediaQuery.of(context).size.height * 0.1, 20, 0),
//             child: Column(
//               children: <Widget>[
//                 if (_errorMessage != null)
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 20),
//                     padding: const EdgeInsets.all(10),
//                     color: Colors.redAccent,
//                     child: Row(
//                       children: [
//                         const Icon(Icons.error, color: Colors.white),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Text(
//                             _errorMessage!,
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 if (_successMessage != null) // Display success message
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 20),
//                     padding: const EdgeInsets.all(10),
//                     color: Colors.greenAccent,
//                     child: Row(
//                       children: [
//                         const Icon(Icons.check_circle, color: Colors.white),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Text(
//                             _successMessage!,
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 logoWidget("assets/images/logo3.png"),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 reusableTextField("Enter Email", Icons.email_outlined, false,
//                     _emailTextController),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 reusableTextField("Enter Password", Icons.lock_outlined, true,
//                     _passwordTextController),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 reusableTextField("Confirm Password", Icons.lock_outlined, true,
//                     _confirmPasswordTextController),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 _isLoading
//                     ? const CircularProgressIndicator()
//                     : signInSignUpButton(context, false, () {
//                         _signUp();
//                       }),
//                 signUpOption(context),
//                 const SizedBox(
//                   height: 40,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _signUp() async {
//     if (_passwordTextController.text != _confirmPasswordTextController.text) {
//       setState(() {
//         _errorMessage = 'Passwords do not match';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//       _successMessage = null;
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
//         setState(() {
//           _successMessage = 'Registration successful! A verification email has been sent.';
//         });
//       }

//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const EditProfilePage()),
//       );
//     } on FirebaseAuthException catch (e) {
//       String errorMessage;

//       switch (e.code) {
//         case 'email-already-in-use':
//           errorMessage = 'The email address is already in use by another account.';
//           break;
//         case 'invalid-email':
//           errorMessage = 'The email address is not valid.';
//           break;
//         case 'weak-password':
//           errorMessage = 'The password is too weak. It should be at least 6 characters long.';
//           break;
//         case 'operation-not-allowed':
//           errorMessage = 'This sign-up method is not allowed.';
//           break;
//         case 'network-request-failed':
//           errorMessage = 'Network error. Please check your internet connection.';
//           break;
//         default:
//           errorMessage = 'An unknown error occurred. Please try again.';
//       }

//       setState(() {
//         _errorMessage = errorMessage;
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

//   Row signUpOption(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text(
//           'Have an account?',
//           style: TextStyle(color: Color(0xffb53405)),
//         ),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const SalonOwnerLogin()),
//             );
//           },
//           child: const Text(
//             '    LOGIN',
//             style: TextStyle(
//                 color: Color(0xff089be3), fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }
