import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kReleaseMode) {
      // TODO: Replace with your actual production backend URL (must be HTTPS)
      return 'https://api.botanique.app';
    }
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }
    return Platform.isAndroid ? 'http://10.7.64.231:8000' : 'http://127.0.0.1:8000';
  }
}
