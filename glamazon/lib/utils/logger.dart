import 'package:flutter/foundation.dart';

/// A simple logger utility for the app
class AppLogger {
  static void info(String message) {
    if (kDebugMode) {
      print('ℹ️ INFO: $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      print('⚠️ WARNING: $message');
    }
  }

  static void error(String message, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('❌ ERROR: $message');
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }
  }

  static void success(String message) {
    if (kDebugMode) {
      print('✅ SUCCESS: $message');
    }
  }
}
