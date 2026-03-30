import 'package:flutter/material.dart';
import 'widget_tree.dart';
import 'notifiers/theme_notifier.dart';

final ThemeNotifier themeNotifier = ThemeNotifier();

// ── Shared brand colors ────────────────────────────────────────────────────
const Color _darkBg = Color.fromARGB(255, 30, 35, 30);
const Color _darkSurface = Color.fromARGB(255, 67, 76, 68);
const Color _primaryFg = Color.fromARGB(255, 225, 249, 226);
const Color _secondaryFg = Color.fromARGB(255, 204, 223, 205);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier.isDarkMode,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Botanique",
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

          // ── Dark Theme ────────────────────────────────────────────────
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: _darkBg,
            colorScheme: const ColorScheme.dark(
              primary: _primaryFg,
              onPrimary: _darkSurface,
              secondary: _secondaryFg,
              surface: _darkSurface,
              onSurface: _primaryFg,
              onSecondary: _darkSurface,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: _primaryFg),
              titleTextStyle: TextStyle(
                fontFamily: 'Raleway',
                color: _primaryFg,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            cardTheme: CardThemeData(
              color: _primaryFg.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: _primaryFg.withValues(alpha: 0.3)),
              ),
            ),
            dividerColor: _primaryFg,
            progressIndicatorTheme:
                const ProgressIndicatorThemeData(color: _primaryFg),
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.all(_primaryFg),
              trackColor: WidgetStateProperty.all(
                  _primaryFg.withValues(alpha: 0.5)),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontFamily: 'Raleway', color: _secondaryFg),
              bodyLarge: TextStyle(fontFamily: 'Raleway', color: _primaryFg),
            ),
          ),

          // ── Light Theme ───────────────────────────────────────────────
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: _darkSurface,
              onPrimary: Colors.white,
              secondary: Color(0xFF5A6B5B),
              surface: Color(0xFFF0F4F0),
              onSurface: _darkSurface,
              onSecondary: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: _darkSurface),
              titleTextStyle: TextStyle(
                fontFamily: 'Raleway',
                color: _darkSurface,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFFF0F4F0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: _darkSurface.withValues(alpha: 0.3)),
              ),
            ),
            dividerColor: _darkSurface,
            progressIndicatorTheme:
                const ProgressIndicatorThemeData(color: _darkSurface),
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.all(_primaryFg),
              trackColor: WidgetStateProperty.all(
                  _darkSurface.withValues(alpha: 0.6)),
            ),
            textTheme: const TextTheme(
              bodyMedium:
                  TextStyle(fontFamily: 'Raleway', color: Color(0xFF5A6B5B)),
              bodyLarge: TextStyle(fontFamily: 'Raleway', color: _darkSurface),
            ),
          ),

          home: WidgetTree(themeNotifier: themeNotifier),
        );
      },
    );
  }
}
