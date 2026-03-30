import 'package:flutter/material.dart';

class ThemeNotifier {
  final ValueNotifier<bool> isDarkMode = ValueNotifier(true);

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
