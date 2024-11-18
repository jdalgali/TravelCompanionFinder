import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message, {Object? error}) {
    if (kDebugMode) {
      print('📝 LOG: $message');
      if (error != null) {
        print('❌ ERROR: $error');
      }
    }
  }
}