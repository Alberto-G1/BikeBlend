import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glamazon/utils/constants.dart';
import 'package:glamazon/utils/logger.dart';

class ErrorHandler {
  /// Log errors to console and potentially to a remote service
  static void logError(dynamic error, StackTrace? stackTrace) {
    AppLogger.error('Error occurred: ${error.toString()}', stackTrace);
    
    // Here you could also send the error to a service like Firebase Crashlytics
    // or another error tracking service
  }

  /// Show a snackbar with an error message
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppConstants.mediumSpacing),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Get a user-friendly error message from Firebase Auth exceptions
  static String getFirebaseAuthErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'This sign-in method is not allowed.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An error occurred: ${exception.message}';
    }
  }

  /// Handle Firebase Auth exceptions in a consistent way
  static void handleFirebaseAuthError(
    BuildContext context, 
    FirebaseAuthException exception,
  ) {
    final message = getFirebaseAuthErrorMessage(exception);
    showError(context, message);
    logError(exception, null);
  }
}
