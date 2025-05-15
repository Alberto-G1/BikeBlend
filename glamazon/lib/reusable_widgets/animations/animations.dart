import 'package:flutter/material.dart';

class AppAnimations {
  // Fade in animation
  static Widget fadeIn({
    required Widget child,
    required bool animate,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return AnimatedOpacity(
      opacity: animate ? 1.0 : 0.0,
      duration: duration,
      child: child,
    );
  }

  // Slide in animation
  static Widget slideIn({
    required Widget child,
    required bool animate,
    Duration duration = const Duration(milliseconds: 300),
    Offset beginOffset = const Offset(0.0, 0.1),
  }) {
    return AnimatedSlide(
      offset: animate ? Offset.zero : beginOffset,
      duration: duration,
      child: AnimatedOpacity(
        opacity: animate ? 1.0 : 0.0,
        duration: duration,
        child: child,
      ),
    );
  }

  // Scale animation
  static Widget scale({
    required Widget child,
    required bool animate,
    Duration duration = const Duration(milliseconds: 300),
    double beginScale = 0.9,
  }) {
    return AnimatedScale(
      scale: animate ? 1.0 : beginScale,
      duration: duration,
      child: AnimatedOpacity(
        opacity: animate ? 1.0 : 0.0,
        duration: duration,
        child: child,
      ),
    );
  }
}

// Page transition animations
class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  
  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

class FadePageRoute extends PageRouteBuilder {
  final Widget page;
  
  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
