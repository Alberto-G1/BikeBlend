import 'package:flutter/material.dart';
import 'package:glamazon/reusable_widgets/animations/animations.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';


Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
  );
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus = false,
    this.focusNode,
    this.onEditingComplete,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      autofocus: autofocus,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          borderSide: BorderSide(color: AppColors.sienna, width: 2),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double width;
  final double height;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width = double.infinity,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.sienna),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                ),
              ),
              child: _buildButtonContent(),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sienna,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                ),
              ),
              child: _buildButtonContent(),
            ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final int index;
  final bool animate;
  final Duration delay;

  const AnimatedListItem({
    Key? key,
    required this.child,
    required this.index,
    this.animate = true,
    this.delay = const Duration(milliseconds: 100),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppAnimations.slideIn(
      animate: animate,
      beginOffset: const Offset(0, 0.1),
      duration: AppConstants.mediumAnimationDuration + Duration(milliseconds: index * 50),
      child: AppAnimations.fadeIn(
        animate: animate,
        duration: AppConstants.mediumAnimationDuration + Duration(milliseconds: index * 50),
        child: child,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAllPressed;

  const SectionTitle({
    Key? key,
    required this.title,
    this.subtitle,
    this.onSeeAllPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.mediumSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppConstants.titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: AppConstants.smallFontSize,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
            ],
          ),
          if (onSeeAllPressed != null)
            TextButton(
              onPressed: onSeeAllPressed,
              child: Text(
                'See All',
                style: TextStyle(
                  color: AppColors.sienna,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import '../utils/colors.dart';
// import '../utils/constants.dart';

// // Improved TextField widget
// class CustomTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final String hintText;
//   final bool isPassword;
//   final TextInputType keyboardType;
//   final Icon? prefixIcon;
//   final String? Function(String?)? validator;
//   final TextInputAction? textInputAction;
//   final Function()? onEditingComplete;

//   const CustomTextField({
//     Key? key,
//     required this.controller,
//     required this.labelText,
//     required this.hintText,
//     this.isPassword = false,
//     this.keyboardType = TextInputType.text,
//     this.prefixIcon,
//     this.validator,
//     this.textInputAction,
//     this.onEditingComplete,
//   }) : super(key: key);

//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<CustomTextField> {
//   bool _obscureText = true;

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: widget.controller,
//       obscureText: widget.isPassword ? _obscureText : false,
//       keyboardType: widget.keyboardType,
//       validator: widget.validator,
//       textInputAction: widget.textInputAction,
//       onEditingComplete: widget.onEditingComplete,
//       decoration: InputDecoration(
//         labelText: widget.labelText,
//         hintText: widget.hintText,
//         prefixIcon: widget.prefixIcon,
//         suffixIcon: widget.isPassword
//             ? IconButton(
//                 icon: Icon(
//                   _obscureText ? Icons.visibility_off : Icons.visibility,
//                   color: AppColors.sienna,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscureText = !_obscureText;
//                   });
//                 },
//               )
//             : null,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppConstants.borderRadius),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: AppColors.sienna, width: 2.0),
//           borderRadius: BorderRadius.circular(AppConstants.borderRadius),
//         ),
//       ),
//     );
//   }
// }

// // Improved Button widget
// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final bool isLoading;
//   final IconData? icon;
//   final Color? backgroundColor;
//   final Color? textColor;

//   const CustomButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//     this.isLoading = false,
//     this.icon,
//     this.backgroundColor,
//     this.textColor,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: isLoading ? null : onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: backgroundColor ?? AppColors.sienna,
//         foregroundColor: textColor ?? Colors.white,
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
//         ),
//         minimumSize: const Size(double.infinity, 50),
//       ),
//       child: isLoading
//           ? const SizedBox(
//               height: 20,
//               width: 20,
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2.0,
//               ),
//             )
//           : Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (icon != null) ...[
//                   Icon(icon),
//                   const SizedBox(width: 8),
//                 ],
//                 Text(
//                   text,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// // Logo widget
// Widget logoWidget(String imagePath) {
//   return Image.asset(
//     imagePath,
//     fit: BoxFit.contain,
//     width: 150,
//     height: 150,
//   );
// }

// // Legacy reusable text field (for backward compatibility)
// TextField reusableTextField(String text, IconData icon, bool isPasswordType,
//     TextEditingController controller) {
//   return TextField(
//     controller: controller,
//     obscureText: isPasswordType,
//     enableSuggestions: !isPasswordType,
//     autocorrect: !isPasswordType,
//     cursorColor: Colors.black,
//     style: TextStyle(color: Colors.black.withOpacity(0.9)),
//     decoration: InputDecoration(
//       prefixIcon: Icon(
//         icon,
//         color: const Color(0xffa0522d),
//       ),
//       labelText: text,
//       labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
//       filled: true,
//       floatingLabelBehavior: FloatingLabelBehavior.never,
//       fillColor: Colors.white.withOpacity(0.3),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30.0),
//         borderSide: const BorderSide(width: 0, style: BorderStyle.none),
//       ),
//     ),
//     keyboardType: isPasswordType
//         ? TextInputType.visiblePassword
//         : TextInputType.emailAddress,
//   );
// }

// // Legacy sign in/sign up button (for backward compatibility)
// Container signInSignUpButton(
//     BuildContext context, bool isLogin, Function onTap) {
//   return Container(
//     width: MediaQuery.of(context).size.width,
//     height: 50,
//     margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
//     decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
//     child: ElevatedButton(
//       onPressed: () {
//         onTap();
//       },
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.resolveWith((states) {
//           if (states.contains(MaterialState.pressed)) {
//             return const Color(0xff089be3);
//           }
//           return const Color(0xffa0522d);
//         }),
//         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         ),
//       ),
//       child: Text(
//         isLogin ? 'LOG IN' : 'SIGN UP',
//         style: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           fontSize: 16,
//         ),
//       ),
//     ),
//   );
// }







// import 'package:flutter/material.dart';

// Image logoWidget(String imageName) {
//   return Image.asset(
//     imageName,
//     fit: BoxFit.fitWidth,
//     width: 240,
//     height: 240,
//   );
// }

// TextField reusableTextField(String text, IconData icon, bool isPassword,
//     TextEditingController controller) {
//   return TextField(
//     controller: controller,
//     obscureText: isPassword,
//     enableSuggestions: !isPassword,
//     autocorrect: !isPassword,
//     cursorColor: Colors.brown,
//     style: const TextStyle(
//       color: Colors.brown,
//     ),
//     decoration: InputDecoration(
//         prefixIcon: Icon(
//           icon,
//           color: const Color.fromARGB(179, 249, 119, 32),
//         ),
//         labelText: text,
//         labelStyle: TextStyle(
//           color: const Color.fromARGB(255, 234, 111, 66).withOpacity(0.9),
//         ),
//         filled: true,
//         floatingLabelBehavior: FloatingLabelBehavior.never,
//         fillColor: const Color.fromARGB(255, 240, 123, 81).withOpacity(0.3),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30.0),
//           borderSide: const BorderSide(width: 0, style: BorderStyle.none),
//         )),
//     keyboardType:
//         isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
//   );
// }

// Container signInSignUpButton(
//     BuildContext context, bool isLogin, Function onTap) {
//   return Container(
//     width: MediaQuery.of(context).size.width,
//     height: 50,
//     margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
//     decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
//     child: ElevatedButton(
//       onPressed: () {
//         onTap();
//       },
//       style: ButtonStyle(
//         backgroundColor: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.pressed)) {
//             return Colors.green;
//           }
//           return Colors.white;
//         }),
//         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
//       ),
//       child: Text(
//         isLogin ? 'LOG IN' : 'SIGN UP',
//         style: const TextStyle(
//             color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
//       ),
//     ),
//   );
// }


