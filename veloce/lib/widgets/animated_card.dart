import 'package:flutter/material.dart';

Route animatedSlideTransition(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, anim, secondaryAnim) => page,
    transitionsBuilder: (context, anim, _, child) {
      final offsetAnim = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(anim);

      return SlideTransition(position: offsetAnim, child: child);
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}
