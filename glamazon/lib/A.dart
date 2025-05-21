// WE HAD IMPROVED  SOME SCREENS BUT BEFORE WE GO AHEAD THESE ARE THE UNIVERSAL CODES WE R USING 
// import 'package:flutter/material.dart';
// import '../../utils/colors.dart';


// final ThemeData darkTheme = ThemeData(
//   primaryColor: AppColors.sienna,
//   scaffoldBackgroundColor: Color(0xFF121212),
//   colorScheme: ColorScheme.dark(
//     primary: AppColors.sienna,
//     secondary: AppColors.sienna.withOpacity(0.7),
//     surface: Color(0xFF1E1E1E),
//     error: Colors.red.shade300,
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: Color(0xFF1E1E1E),
//     foregroundColor: Colors.white,
//     elevation: 0,
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: AppColors.sienna,
//       foregroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//     ),
//   ),
//   textTheme: TextTheme(
//     displayLarge: TextStyle(color: Colors.white),
//     displayMedium: TextStyle(color: Colors.white),
//     bodyLarge: TextStyle(color: Colors.white),
//     bodyMedium: TextStyle(color: Colors.white),
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: AppColors.sienna),
//       borderRadius: BorderRadius.circular(8),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Colors.grey.shade700),
//       borderRadius: BorderRadius.circular(8),
//     ),
//   ),
// );


// import 'package:flutter/material.dart';
// import '../../utils/colors.dart';


// final ThemeData lightTheme = ThemeData(
//   primaryColor: AppColors.sienna,
//   scaffoldBackgroundColor: Colors.white,
//   colorScheme: ColorScheme.light(
//     primary: AppColors.sienna,
//     secondary: AppColors.sienna.withOpacity(0.7),
//     surface: Colors.white,
//     error: Colors.red,
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: AppColors.sienna,
//     foregroundColor: Colors.white,
//     elevation: 0,
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: AppColors.sienna,
//       foregroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//     ),
//   ),
//   textTheme: TextTheme(
//     displayLarge: TextStyle(color: Colors.black87),
//     displayMedium: TextStyle(color: Colors.black87),
//     bodyLarge: TextStyle(color: Colors.black87),
//     bodyMedium: TextStyle(color: Colors.black87),
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: AppColors.sienna),
//       borderRadius: BorderRadius.circular(8),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Colors.grey),
//       borderRadius: BorderRadius.circular(8),
//     ),
//   ),
// );

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../utils/colors.dart';


// class ThemeProvider extends ChangeNotifier {
//   bool _isDarkMode = false;
//   String _fontFamily = 'Roboto'; // Default font
//   static const String _themePreferenceKey = 'theme_preference';
//   
//   String get fontFamily => _fontFamily;
//   
//   ThemeProvider() {
//     _loadThemePreference();
//   }
//   
//   bool get isDarkMode => _isDarkMode;
//   
//   ThemeData get themeData {
//     return _isDarkMode ? _darkTheme : _lightTheme;
//   }
//   
//   final ThemeData _lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: AppColors.sienna,
//     scaffoldBackgroundColor: Colors.white,
//     colorScheme: ColorScheme.light(
//       primary: AppColors.sienna,
//       secondary: AppColors.teal,
//       surface: Colors.white,
//       background: Colors.grey[50]!,
//       error: AppColors.error,
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: Colors.white,
//       foregroundColor: AppColors.sienna,
//       elevation: 0,
//       iconTheme: IconThemeData(color: AppColors.sienna),
//       titleTextStyle: TextStyle(
//         color: AppColors.darkText,
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.sienna,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     ),
//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(
//         foregroundColor: AppColors.sienna,
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: Colors.grey[100],
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: AppColors.sienna, width: 2),
//       ),
//     ),
//     cardTheme: CardTheme(
//       color: Colors.white,
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//     ),
//     // Additional theme data for profile screens
//     outlinedButtonTheme: OutlinedButtonThemeData(
//       style: OutlinedButton.styleFrom(
//         foregroundColor: AppColors.sienna,
//         side: BorderSide(color: AppColors.sienna),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     ),
//     chipTheme: ChipThemeData(
//       backgroundColor: Colors.grey[200],
//       selectedColor: AppColors.sienna.withOpacity(0.7),
//       labelStyle: TextStyle(color: Colors.black87),
//       secondaryLabelStyle: TextStyle(color: Colors.white),
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//     ),
//     textTheme: TextTheme(
//       displayLarge: TextStyle(color: AppColors.darkText),
//       displayMedium: TextStyle(color: AppColors.darkText),
//       displaySmall: TextStyle(color: AppColors.darkText),
//       headlineLarge: TextStyle(color: AppColors.darkText),
//       headlineMedium: TextStyle(color: AppColors.darkText),
//       headlineSmall: TextStyle(color: AppColors.darkText),
//       titleLarge: TextStyle(color: AppColors.darkText),
//       titleMedium: TextStyle(color: AppColors.darkText),
//       titleSmall: TextStyle(color: AppColors.darkText),
//       bodyLarge: TextStyle(color: AppColors.darkText),
//       bodyMedium: TextStyle(color: AppColors.darkText),
//       bodySmall: TextStyle(color: AppColors.lightText),
//       labelLarge: TextStyle(color: AppColors.darkText),
//       labelMedium: TextStyle(color: AppColors.darkText),
//       labelSmall: TextStyle(color: AppColors.lightText),
//     ),
//   );
//   
//   final ThemeData _darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: Colors.teal[700],
//     scaffoldBackgroundColor: AppColors.darkBackground,
//     colorScheme: ColorScheme.dark(
//       primary: Colors.teal[700]!,
//       secondary: Colors.tealAccent,
//       surface: AppColors.darkSurface,
//       background: AppColors.darkBackground,
//       error: AppColors.error,
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: AppColors.darkBackground,
//       foregroundColor: Colors.white,
//       elevation: 0,
//       iconTheme: IconThemeData(color: Colors.white),
//       titleTextStyle: TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.teal[700],
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     ),
//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(
//         foregroundColor: Colors.tealAccent,
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: Colors.grey[900],
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.tealAccent, width: 2),
//       ),
//     ),
//     cardTheme: CardTheme(
//       color: AppColors.darkSurface,
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//     ),
//     // Additional theme data for profile screens
//     outlinedButtonTheme: OutlinedButtonThemeData(
//       style: OutlinedButton.styleFrom(
//         foregroundColor: Colors.tealAccent,
//         side: BorderSide(color: Colors.tealAccent),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     ),
//     chipTheme: ChipThemeData(
//       backgroundColor: Colors.grey[800],
//       selectedColor: Colors.teal.shade700,
//       labelStyle: TextStyle(color: Colors.grey[300]),
//       secondaryLabelStyle: TextStyle(color: Colors.white),
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//     ),
//     textTheme: TextTheme(
//       displayLarge: TextStyle(color: Colors.white),
//       displayMedium: TextStyle(color: Colors.white),
//       displaySmall: TextStyle(color: Colors.white),
//       headlineLarge: TextStyle(color: Colors.white),
//       headlineMedium: TextStyle(color: Colors.white),
//       headlineSmall: TextStyle(color: Colors.white),
//       titleLarge: TextStyle(color: Colors.white),
//       titleMedium: TextStyle(color: Colors.white),
//       titleSmall: TextStyle(color: Colors.white),
//       bodyLarge: TextStyle(color: Colors.white),
//       bodyMedium: TextStyle(color: Colors.white),
//       bodySmall: TextStyle(color: Colors.grey[400]),
//       labelLarge: TextStyle(color: Colors.white),
//       labelMedium: TextStyle(color: Colors.white),
//       labelSmall: TextStyle(color: Colors.grey[400]),
//     ),
//   );
//   
//   void toggleTheme() {
//     _isDarkMode = !_isDarkMode;
//     _saveThemePreference();
//     notifyListeners();
//   }
//   
//   Future<void> _loadThemePreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     _isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
//     _fontFamily = prefs.getString('fontFamily') ?? 'Roboto';
//     notifyListeners();
//   }
//     
//   Future<void> setSystemTheme(BuildContext context) async {
//     final brightness = MediaQuery.of(context).platformBrightness;
//     _isDarkMode = brightness == Brightness.dark;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isDarkMode', _isDarkMode);
//     notifyListeners();
//   }
//   
//   Future<void> _saveThemePreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_themePreferenceKey, _isDarkMode);
//   }
//     
//   Future<void> setFont(String fontFamily) async {
//     _fontFamily = fontFamily;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('fontFamily', fontFamily);
//     notifyListeners();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:glamazon/config/theme/theme_provider.dart';
// import 'package:glamazon/utils/colors.dart';
// import 'package:provider/provider.dart';


// class ThemeToggle extends StatelessWidget {
//   final bool showLabel;
//   final double size;
//   final Color? iconColor;
//   
//   const ThemeToggle({
//     Key? key,
//     this.showLabel = false,
//     this.size = 24.0,
//     this.iconColor,
//   }) : super(key: key);


//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.isDarkMode;


//     return GestureDetector(
//       onTap: () {
//         themeProvider.toggleTheme();
//       },
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             transitionBuilder: (Widget child, Animation<double> animation) {
//               return RotationTransition(
//                 turns: animation,
//                 child: ScaleTransition(
//                   scale: animation,
//                   child: child,
//                 ),
//               );
//             },
//             child: Icon(
//               isDarkMode ? Icons.dark_mode : Icons.light_mode,
//               key: ValueKey<bool>(isDarkMode),
//               color: isDarkMode ? Colors.amber : AppColors.sienna,
//               size: size,
//             ),
//           ),
//           if (showLabel) ...[
//             const SizedBox(width: 8),
//             Text(
//               isDarkMode ? 'Dark Mode' : 'Light Mode',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isDarkMode ? Colors.white70 : Colors.black87,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// import 'dart:math';


// import 'package:flutter/material.dart';
// import 'package:glamazon/utils/constants.dart';


// class AppAnimations {
//   /// Fade in animation
//   static Widget fadeIn({
//     required Widget child,
//     required bool animate,
//     Duration? duration,
//     Duration? delay,
//     Curve curve = Curves.easeInOut,
//   }) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween<double>(begin: 0.0, end: animate ? 1.0 : 0.0),
//       duration: duration ?? AppConstants.mediumAnimationDuration,
//       curve: curve,
//       builder: (context, value, child) {
//         return Opacity(
//           opacity: value,
//           child: child,
//         );
//       },
//       child: delay != null
//           ? FutureBuilder(
//               future: Future.delayed(delay),
//               builder: (context, snapshot) {
//                 return child;
//               },
//             )
//           : child,
//     );
//   }


//   /// Slide in animation
//   static Widget slideIn({
//     required Widget child,
//     required bool animate,
//     Offset beginOffset = const Offset(0.0, 0.5),
//     Duration? duration,
//     Duration? delay,
//     Curve curve = Curves.easeInOut,
//   }) {
//     return TweenAnimationBuilder<Offset>(
//       tween: Tween<Offset>(
//         begin: beginOffset,
//         end: animate ? Offset.zero : beginOffset,
//       ),
//       duration: duration ?? AppConstants.mediumAnimationDuration,
//       curve: curve,
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(
//             value.dx * MediaQuery.of(context).size.width,
//             value.dy * MediaQuery.of(context).size.height,
//           ),
//           child: child,
//         );
//       },
//       child: delay != null
//           ? FutureBuilder(
//               future: Future.delayed(delay),
//               builder: (context, snapshot) {
//                 return child;
//               },
//             )
//           : child,
//     );
//   }


//   /// Scale animation
//   static Widget scale({
//     required Widget child,
//     required bool animate,
//     double beginScale = 0.8,
//     Duration? duration,
//     Duration? delay,
//     Curve curve = Curves.easeInOut,
//   }) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween<double>(
//         begin: beginScale,
//         end: animate ? 1.0 : beginScale,
//       ),
//       duration: duration ?? AppConstants.mediumAnimationDuration,
//       curve: curve,
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: value,
//           child: child,
//         );
//       },
//       child: delay != null
//           ? FutureBuilder(
//               future: Future.delayed(delay),
//               builder: (context, snapshot) {
//                 return child;
//               },
//             )
//           : child,
//     );
//   }


//   /// Rotate animation
//   static Widget rotate({
//     required Widget child,
//     required bool animate,
//     double beginAngle = 0.0,
//     double endAngle = 2 * 3.14159, // 360 degrees in radians
//     Duration? duration,
//     Duration? delay,
//     Curve curve = Curves.easeInOut,
//   }) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween<double>(
//         begin: beginAngle,
//         end: animate ? endAngle : beginAngle,
//       ),
//       duration: duration ?? const Duration(milliseconds: 800),
//       curve: curve,
//       builder: (context, value, child) {
//         return Transform.rotate(
//           angle: value,
//           child: child,
//         );
//       },
//       child: delay != null
//           ? FutureBuilder(
//               future: Future.delayed(delay),
//               builder: (context, snapshot) {
//                 return child;
//               },
//             )
//           : child,
//     );
//   }


//   /// Pulse animation
//   static Widget pulse({
//     required Widget child,
//     bool repeat = true,
//     Duration? duration,
//   }) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween<double>(begin: 0.0, end: 1.0),
//       duration: duration ?? const Duration(milliseconds: 1500),
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: 1.0 + 0.1 * sin(value * 3.14159 * 2),
//           child: child,
//         );
//       },
//       child: child,
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../../utils/colors.dart';


// class ErrorMessage extends StatelessWidget {
//   final String message;
//   final Duration duration;
//   final VoidCallback? onDismissed;


//   const ErrorMessage({
//     super.key,
//     required this.message,
//     this.duration = const Duration(seconds: 3),
//     this.onDismissed,
//   });


//   static void show(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: ErrorMessage(message: message),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: AppColors.error,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.error_outline, color: Colors.white),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               message,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:glamazon/config/theme/theme_provider.dart';
// import 'package:provider/provider.dart';


// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final Color backgroundColor;
//   final List<Widget>? actions;
//   final bool showThemeToggle;
//   final bool automaticallyImplyLeading;
//   final double elevation;
//   final Widget? leading;
//   final VoidCallback? onLeadingPressed;


//   const CustomAppBar({
//     Key? key,
//     required this.title,
//     required this.backgroundColor,
//     this.actions,
//     this.showThemeToggle = false,
//     this.automaticallyImplyLeading = true,
//     this.elevation = 0,
//     this.leading,
//     this.onLeadingPressed,
//   }) : super(key: key);


//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     
//     List<Widget> finalActions = actions ?? [];
//     
//     if (showThemeToggle) {
//       finalActions.add(
//         IconButton(
//           icon: Icon(
//             themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             themeProvider.toggleTheme();
//           },
//         ),
//       );
//     }
//     
//     return AppBar(
//       title: Text(
//         title,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 20,
//         ),
//       ),
//       backgroundColor: backgroundColor,
//       elevation: elevation,
//       automaticallyImplyLeading: automaticallyImplyLeading,
//       leading: leading ?? (automaticallyImplyLeading && Navigator.canPop(context)
//           ? IconButton(
//               icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//               onPressed: onLeadingPressed ?? () => Navigator.pop(context),
//             )
//           : null),
//       actions: finalActions,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         ),
//       ),
//     );
//   }


//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

// import 'package:flutter/material.dart';
// import 'package:glamazon/reusable_widgets/animations/animations.dart';
// import '../utils/colors.dart';
// import '../utils/constants.dart';



// Image logoWidget(String imageName) {
//   return Image.asset(
//     imageName,
//     fit: BoxFit.fitWidth,
//     width: 240,
//     height: 240,
//   );
// }


// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final String? hintText;
//   final bool isPassword;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final bool autofocus;
//   final FocusNode? focusNode;
//   final VoidCallback? onEditingComplete;
//   final TextInputAction? textInputAction;


//   const CustomTextField({
//     Key? key,
//     required this.controller,
//     required this.labelText,
//     this.hintText,
//     this.isPassword = false,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.autofocus = false,
//     this.focusNode,
//     this.onEditingComplete,
//     this.textInputAction,
//   }) : super(key: key);


//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword,
//       keyboardType: keyboardType,
//       validator: validator,
//       autofocus: autofocus,
//       focusNode: focusNode,
//       onEditingComplete: onEditingComplete,
//       textInputAction: textInputAction,
//       decoration: InputDecoration(
//         labelText: labelText,
//         hintText: hintText,
//         prefixIcon: prefixIcon,
//         suffixIcon: suffixIcon,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
//           borderSide: BorderSide(color: AppColors.sienna, width: 2),
//         ),
//       ),
//     );
//   }
// }


// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final bool isLoading;
//   final bool isOutlined;
//   final IconData? icon;
//   final double width;
//   final double height;


//   const CustomButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//     this.isLoading = false,
//     this.isOutlined = false,
//     this.icon,
//     this.width = double.infinity,
//     this.height = 50,
//   }) : super(key: key);


//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       height: height,
//       child: isOutlined
//           ? OutlinedButton(
//               onPressed: isLoading ? null : onPressed,
//               style: OutlinedButton.styleFrom(
//                 side: BorderSide(color: AppColors.sienna),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
//                 ),
//               ),
//               child: _buildButtonContent(),
//             )
//           : ElevatedButton(
//               onPressed: isLoading ? null : onPressed,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.sienna,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
//                 ),
//               ),
//               child: _buildButtonContent(),
//             ),
//     );
//   }


//   Widget _buildButtonContent() {
//     if (isLoading) {
//       return const SizedBox(
//         width: 24,
//         height: 24,
//         child: CircularProgressIndicator(
//           strokeWidth: 2,
//           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//         ),
//       );
//     }


//     if (icon != null) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 20),
//           const SizedBox(width: 8),
//           Text(text),
//         ],
//       );
//     }


//     return Text(text);
//   }
// }


// class AnimatedListItem extends StatelessWidget {
//   final Widget child;
//   final int index;
//   final bool animate;
//   final Duration delay;


//   const AnimatedListItem({
//     Key? key,
//     required this.child,
//     required this.index,
//     this.animate = true,
//     this.delay = const Duration(milliseconds: 100),
//   }) : super(key: key);


//   @override
//   Widget build(BuildContext context) {
//     return AppAnimations.slideIn(
//       animate: animate,
//       beginOffset: const Offset(0, 0.1),
//       duration: AppConstants.mediumAnimationDuration + Duration(milliseconds: index * 50),
//       child: AppAnimations.fadeIn(
//         animate: animate,
//         duration: AppConstants.mediumAnimationDuration + Duration(milliseconds: index * 50),
//         child: child,
//       ),
//     );
//   }
// }


// class SectionTitle extends StatelessWidget {
//   final String title;
//   final String? subtitle;
//   final VoidCallback? onSeeAllPressed;


//   const SectionTitle({
//     Key? key,
//     required this.title,
//     this.subtitle,
//     this.onSeeAllPressed,
//   }) : super(key: key);


//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: AppConstants.mediumSpacing),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: AppConstants.titleFontSize,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).textTheme.bodyLarge?.color,
//                 ),
//               ),
//               if (subtitle != null)
//                 Text(
//                   subtitle!,
//                   style: TextStyle(
//                     fontSize: AppConstants.smallFontSize,
//                     color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
//                   ),
//                 ),
//             ],
//           ),
//           if (onSeeAllPressed != null)
//             TextButton(
//               onPressed: onSeeAllPressed,
//               child: Text(
//                 'See All',
//                 style: TextStyle(
//                   color: AppColors.sienna,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';


// class SmoothPageIndicator extends StatelessWidget {
//   final int count;
//   final int activeIndex;
//   final Color activeColor;
//   final Color inactiveColor;
//   final double dotWidth;
//   final double dotHeight;
//   final double spacing;
//   final double radius;


//   const SmoothPageIndicator({
//     Key? key,
//     required this.count,
//     required this.activeIndex,
//     this.activeColor = Colors.teal,
//     this.inactiveColor = Colors.grey,
//     this.dotWidth = 8.0,
//     this.dotHeight = 8.0,
//     this.spacing = 8.0,
//     this.radius = 4.0,
//   }) : super(key: key);


//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(count, (index) {
//         final isActive = index == activeIndex;
//         return Container(
//           margin: EdgeInsets.symmetric(horizontal: spacing / 2),
//           width: isActive ? dotWidth * 2 : dotWidth,
//           height: dotHeight,
//           decoration: BoxDecoration(
//             color: isActive ? activeColor : inactiveColor,
//             borderRadius: BorderRadius.circular(radius),
//           ),
//         );
//       }),
//     );
//   }
// }


// class AnimatedSmoothIndicator extends StatelessWidget {
//   final PageController controller;
//   final int count;
//   final Color activeColor;
//   final Color inactiveColor;
//   final double dotWidth;
//   final double dotHeight;
//   final double spacing;
//   final double radius;
//   final Axis axisDirection;
//   final Function(int)? onDotClicked;


//   const AnimatedSmoothIndicator({
//     Key? key,
//     required this.controller,
//     required this.count,
//     this.activeColor = Colors.teal,
//     this.inactiveColor = Colors.grey,
//     this.dotWidth = 8.0,
//     this.dotHeight = 8.0,
//     this.spacing = 8.0,
//     this.radius = 4.0,
//     this.axisDirection = Axis.horizontal,
//     this.onDotClicked,
//   }) : super(key: key);


//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (context, child) {
//         final activeIndex = _calculateActiveIndex();
//         return _buildIndicator(activeIndex);
//       },
//     );
//   }


//   double _calculateActiveIndex() {
//     try {
//       final position = controller.page ?? controller.initialPage.toDouble();
//       return position;
//     } catch (e) {
//       return controller.initialPage.toDouble();
//     }
//   }


//   Widget _buildIndicator(double activeIndex) {
//     return axisDirection == Axis.horizontal
//         ? Row(
//             mainAxisSize: MainAxisSize.min,
//             children: _buildDots(activeIndex),
//           )
//         : Column(
//             mainAxisSize: MainAxisSize.min,
//             children: _buildDots(activeIndex),
//           );
//   }


//   List<Widget> _buildDots(double activeIndex) {
//     return List.generate(count, (index) {
//       final isActive = (index == activeIndex.floor() && activeIndex % 1 < 0.5) ||
//           (index == activeIndex.ceil() && activeIndex % 1 >= 0.5);
//       
//       // Calculate width based on how close this dot is to being active
//       double width = dotWidth;
//       if (index == activeIndex.floor() && index == activeIndex.ceil()) {
//         width = dotWidth * 2; // Fully active
//       } else if (index == activeIndex.floor()) {
//         width = dotWidth + (dotWidth * (1 - (activeIndex % 1)));
//       } else if (index == activeIndex.ceil()) {
//         width = dotWidth + (dotWidth * (activeIndex % 1));
//       }
//       
//       return GestureDetector(
//         onTap: onDotClicked != null ? () => onDotClicked!(index) : null,
//         child: Container(
//           margin: EdgeInsets.symmetric(
//             horizontal: axisDirection == Axis.horizontal ? spacing / 2 : 0,
//             vertical: axisDirection == Axis.vertical ? spacing / 2 : 0,
//           ),
//           width: axisDirection == Axis.horizontal ? width : dotWidth,
//           height: axisDirection == Axis.vertical ? width : dotHeight,
//           decoration: BoxDecoration(
//             color: isActive ? activeColor : inactiveColor,
//             borderRadius: BorderRadius.circular(radius),
//           ),
//         ),
//       );
//     });
//   }
// }

// import 'package:flutter/material.dart';


// class AppColors {
//   static const Color sienna = Color(0xFFA0522D);
//   static const Color siennaLight = Color(0xFFD2A084);
//   static const Color siennaDark = Color(0xFF703A1F);
//   
//   // Success and error colors
//   static const Color success = Color(0xFF4CAF50);
//   static const Color error = Color(0xFFE53935);
//   
//   // Background colors
//   static const Color lightBackground = Colors.white;
//   static const Color darkBackground = Color(0xFF121212);
//   
//   // Text colors
//   static const Color lightTextPrimary = Color(0xFF212121);
//   static const Color lightTextSecondary = Color(0xFF757575);
//   static const Color darkTextPrimary = Color(0xFFEEEEEE);
//   static const Color darkTextSecondary = Color(0xFFBDBDBD);


//   // Primary colors
//   static const Color teal = Color(0xFF008080);
//   
//   // Secondary colors
//   static const Color cream = Color(0xFFF8ECDC);
//   static const Color gold = Color(0xFFD4AF37);
//   
//   // Dark mode colors
//   static const Color darkSurface = Color(0xFF1E1E1E);
//   
//   // Text colors
//   static const Color darkText = Color(0xFF212121);
//   static const Color lightText = Color(0xFFF5F5F5);
//   
//   // Status colors
//   static const Color warning = Color(0xFFFFC107);
//   static const Color info = Color(0xFF2196F3);


//   static const tealAccent = Colors.tealAccent;


//   static const Color beige = Color(0xFFF5F5DC);


//   // Text colors
//   static const Color textPrimary = Color(0xFF212121);
//   static const Color textSecondary = Color(0xFF757575);
//   static const Color textHint = Color(0xFFBDBDBD);
// }

// class AppConstants {
//   // App info
//   static const String appName = 'Glamazon';
//   static const String appVersion = '1.0.0';
//   
//   // Animation durations
//   static const Duration shortAnimationDuration = Duration(milliseconds: 200);
//   static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
//   static const Duration longAnimationDuration = Duration(milliseconds: 500);
//   
//   // Spacing
//   static const double smallSpacing = 8.0;
//   static const double mediumSpacing = 16.0;
//   static const double largeSpacing = 24.0;
//   
//   // Border radius
//   static const double smallRadius = 4.0;
//   static const double mediumRadius = 8.0;
//   static const double largeRadius = 16.0;
//   
//   // Font sizes
//   static const double smallFontSize = 12.0;
//   static const double mediumFontSize = 14.0;
//   static const double largeFontSize = 16.0;
//   static const double titleFontSize = 20.0;
//   static const double headingFontSize = 24.0;
//   
//   // Storage keys
//   static const String themeKey = 'theme_mode';
//   static const String fontKey = 'font_family';
//   static const String loginKey = 'is_logged_in';
//   
//   // Border radius
//   static const double borderRadius = 8.0;
//   static const double buttonBorderRadius = 12.0;
//   
//   // Available fonts
//   static const List<String> availableFonts = [
//     'Roboto',
//     'Poppins',
//     'Montserrat',
//     'OpenSans',
//     'Lato',
//   ];
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:glamazon/utils/constants.dart';
// import 'package:glamazon/utils/logger.dart';


// class ErrorHandler {
//   /// Log errors to console and potentially to a remote service
//   static void logError(dynamic error, StackTrace? stackTrace) {
//     AppLogger.error('Error occurred: ${error.toString()}', stackTrace);
//     
//     // Here you could also send the error to a service like Firebase Crashlytics
//     // or another error tracking service
//   }


//   /// Show a snackbar with an error message
//   static void showError(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(AppConstants.mediumSpacing),
//         duration: const Duration(seconds: 4),
//         action: SnackBarAction(
//           label: 'DISMISS',
//           textColor: Colors.white,
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }


//   /// Get a user-friendly error message from Firebase Auth exceptions
//   static String getFirebaseAuthErrorMessage(FirebaseAuthException exception) {
//     switch (exception.code) {
//       case 'user-not-found':
//         return 'No user found with this email.';
//       case 'wrong-password':
//         return 'Wrong password provided.';
//       case 'email-already-in-use':
//         return 'The email address is already in use by another account.';
//       case 'invalid-email':
//         return 'The email address is not valid.';
//       case 'weak-password':
//         return 'The password is too weak.';
//       case 'operation-not-allowed':
//         return 'This sign-in method is not allowed.';
//       case 'user-disabled':
//         return 'This user account has been disabled.';
//       case 'too-many-requests':
//         return 'Too many login attempts. Please try again later.';
//       case 'network-request-failed':
//         return 'Network error. Please check your internet connection.';
//       default:
//         return 'An error occurred: ${exception.message}';
//     }
//   }


//   /// Handle Firebase Auth exceptions in a consistent way
//   static void handleFirebaseAuthError(
//     BuildContext context, 
//     FirebaseAuthException exception,
//   ) {
//     final message = getFirebaseAuthErrorMessage(exception);
//     showError(context, message);
//     logError(exception, null);
//   }
// }

// import 'package:flutter/foundation.dart';


// /// A simple logger utility for the app
// class AppLogger {
//   static void info(String message) {
//     if (kDebugMode) {
//       print('ℹ️ INFO: $message');
//     }
//   }


//   static void warning(String message) {
//     if (kDebugMode) {
//       print('⚠️ WARNING: $message');
//     }
//   }


//   static void error(String message, [StackTrace? stackTrace]) {
//     if (kDebugMode) {
//       print('❌ ERROR: $message');
//       if (stackTrace != null) {
//         print('Stack trace: $stackTrace');
//       }
//     }
//   }


//   static void success(String message) {
//     if (kDebugMode) {
//       print('✅ SUCCESS: $message');
//     }
//   }
// }

// import 'package:shared_preferences/shared_preferences.dart';


// class SharedPreferencesHelper {
//   static late SharedPreferences _prefs;
//   
//   // Initialize shared preferences
//   static Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//   }
//   
//   // Theme preferences
//   static Future<void> setDarkMode(bool isDarkMode) async {
//     await _prefs.setBool('isDarkMode', isDarkMode);
//   }
//   
//   static bool getDarkMode() {
//     return _prefs.getBool('isDarkMode') ?? false;
//   }
//   
//   // Font preferences
//   static Future<void> setFontFamily(String fontFamily) async {
//     await _prefs.setString('fontFamily', fontFamily);
//   }
//   
//   static String getFontFamily() {
//     return _prefs.getString('fontFamily') ?? 'Roboto';
//   }
//   
//   // Auth preferences
//   static Future<void> setLoggedIn(bool isLoggedIn) async {
//     await _prefs.setBool('isLoggedIn', isLoggedIn);
//   }
//   
//   static bool getLoggedIn() {
//     return _prefs.getBool('isLoggedIn') ?? false;
//   }
//   
//   // Clear all preferences
//   static Future<void> clearAll() async {
//     await _prefs.clear();
//   }
// }


// FROM OUR UNIVERSAL CODES ABOVE
