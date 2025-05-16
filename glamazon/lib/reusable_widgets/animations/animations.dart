import 'dart:math';

import 'package:flutter/material.dart';
import 'package:glamazon/utils/constants.dart';

class AppAnimations {
  /// Fade in animation
  static Widget fadeIn({
    required Widget child,
    required bool animate,
    Duration? duration,
    Duration? delay,
    Curve curve = Curves.easeInOut,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: animate ? 1.0 : 0.0),
      duration: duration ?? AppConstants.mediumAnimationDuration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: delay != null
          ? FutureBuilder(
              future: Future.delayed(delay),
              builder: (context, snapshot) {
                return child;
              },
            )
          : child,
    );
  }

  /// Slide in animation
  static Widget slideIn({
    required Widget child,
    required bool animate,
    Offset beginOffset = const Offset(0.0, 0.5),
    Duration? duration,
    Duration? delay,
    Curve curve = Curves.easeInOut,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
        begin: beginOffset,
        end: animate ? Offset.zero : beginOffset,
      ),
      duration: duration ?? AppConstants.mediumAnimationDuration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            value.dx * MediaQuery.of(context).size.width,
            value.dy * MediaQuery.of(context).size.height,
          ),
          child: child,
        );
      },
      child: delay != null
          ? FutureBuilder(
              future: Future.delayed(delay),
              builder: (context, snapshot) {
                return child;
              },
            )
          : child,
    );
  }

  /// Scale animation
  static Widget scale({
    required Widget child,
    required bool animate,
    double beginScale = 0.8,
    Duration? duration,
    Duration? delay,
    Curve curve = Curves.easeInOut,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: beginScale,
        end: animate ? 1.0 : beginScale,
      ),
      duration: duration ?? AppConstants.mediumAnimationDuration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: delay != null
          ? FutureBuilder(
              future: Future.delayed(delay),
              builder: (context, snapshot) {
                return child;
              },
            )
          : child,
    );
  }

  /// Rotate animation
  static Widget rotate({
    required Widget child,
    required bool animate,
    double beginAngle = 0.0,
    double endAngle = 2 * 3.14159, // 360 degrees in radians
    Duration? duration,
    Duration? delay,
    Curve curve = Curves.easeInOut,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: beginAngle,
        end: animate ? endAngle : beginAngle,
      ),
      duration: duration ?? const Duration(milliseconds: 800),
      curve: curve,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value,
          child: child,
        );
      },
      child: delay != null
          ? FutureBuilder(
              future: Future.delayed(delay),
              builder: (context, snapshot) {
                return child;
              },
            )
          : child,
    );
  }

  /// Pulse animation
  static Widget pulse({
    required Widget child,
    bool repeat = true,
    Duration? duration,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration ?? const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 1.0 + 0.1 * sin(value * 3.14159 * 2),
          child: child,
        );
      },
      child: child,
    );
  }
}
