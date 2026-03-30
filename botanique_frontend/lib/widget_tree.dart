import 'package:botanique/notifiers/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'widgets/header_widget.dart';
import 'widgets/footer_widget.dart';
import 'notifiers/navigation_notifier.dart';
import 'notifiers/auth_notifier.dart';

class WidgetTree extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  const WidgetTree({super.key, required this.themeNotifier});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final NavigationNotifier _navigationNotifier = NavigationNotifier();
  final AuthNotifier _authNotifier = AuthNotifier();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _authNotifier.isLoggedIn,
      builder: (context, isLoggedIn, child) {
        if (!isLoggedIn) {
          return WelcomePage(authNotifier: _authNotifier);
        }
        return Scaffold(
          appBar: const Header(),
          body: ValueListenableBuilder<int>(
            valueListenable: _navigationNotifier.currentIndex,
            builder: (context, index, child) {
              switch (index) {
                case 0:
                  return DashboardPage(authNotifier: _authNotifier);
                case 1:
                  return ProfilePage(authNotifier: _authNotifier);
                case 2:
                  return SettingsPage(
                    themeNotifier: widget.themeNotifier,
                    authNotifier: _authNotifier,
                  );
                default:
                  return DashboardPage(authNotifier: _authNotifier);
              }
            },
          ),
          bottomNavigationBar: ValueListenableBuilder<int>(
            valueListenable: _navigationNotifier.currentIndex,
            builder: (context, value, child) {
              return Footer(
                currentIndex: value,
                onTap: _navigationNotifier.changePage,
              );
            },
          ),
        );
      },
    );
  }
}
