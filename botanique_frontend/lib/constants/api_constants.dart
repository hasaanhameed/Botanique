import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kReleaseMode) {
      // Will change in production
      return 'https://api.botanique.app';
    }
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }
    // Using 127.0.0.1 for mobile devices because we are using ADB Reverse
    return 'http://127.0.0.1:8000';
  }
}
