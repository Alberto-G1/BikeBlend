import 'package:flutter/material.dart';

class FadeScaleTransition extends PageRouteBuilder {
  final Widget page;
  
  FadeScaleTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.easeInOutCubic;
            var curveTween = CurveTween(curve: curve);
            
            var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
            var fadeAnimation = fadeTween.animate(
              animation.drive(curveTween),
            );
            
            var scaleTween = Tween<double>(begin: 0.92, end: 1.0);
            var scaleAnimation = scaleTween.animate(
              animation.drive(curveTween),
            );
            
            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
}

class SlideUpTransition extends PageRouteBuilder {
  final Widget page;
  
  SlideUpTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.easeOutQuint;
            var curveTween = CurveTween(curve: curve);
            
            var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
            var fadeAnimation = fadeTween.animate(
              animation.drive(CurveTween(curve: Curves.easeInOut)),
            );
            
            var slideTween = Tween<Offset>(
              begin: const Offset(0.0, 0.15),
              end: Offset.zero,
            );
            var slideAnimation = slideTween.animate(
              animation.drive(curveTween),
            );
            
            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
}
