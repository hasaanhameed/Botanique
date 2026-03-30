import 'package:flutter/material.dart';
import '../notifiers/theme_notifier.dart';
import '../notifiers/auth_notifier.dart';
import '../services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  final ThemeNotifier? themeNotifier;
  final AuthNotifier? authNotifier;
  const SettingsPage({super.key, this.themeNotifier, this.authNotifier});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    color: cs.onSurface,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Appearance',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15,
                        color: cs.onSurface,
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable:
                          widget.themeNotifier?.isDarkMode ??
                          ValueNotifier(true),
                      builder: (context, isDark, child) {
                        return Switch(
                          value: isDark,
                          onChanged: (value) {
                            widget.themeNotifier?.toggleTheme();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Account Section
              Text(
                'Account',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        title: Text(
                          'Delete Account',
                          style: TextStyle(color: cs.onSurface),
                        ),
                        content: Text(
                          'Are you sure you want to delete your account? This action cannot be undone.',
                          style: TextStyle(color: cs.secondary),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: cs.primary),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final token = widget.authNotifier?.token;
                              if (token == null) return;

                              final success = await AuthService.deleteAccount(token);
                              if (mounted) {
                                Navigator.pop(context);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Account deleted successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  widget.authNotifier?.logout();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to delete account'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red.shade400),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // About Section
              Text(
                'About',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        title: Text(
                          'About Botanique',
                          style: TextStyle(color: cs.onSurface),
                        ),
                        content: Text(
                          'Botanique \n\nYour personal plant identification assistant. Take a photo of any plant to learn its name, description, and optimal growth conditions.\n\n',
                          style: TextStyle(color: cs.secondary, height: 1.4),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Close',
                              style: TextStyle(color: cs.primary),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.primary,
                    side: BorderSide(color: cs.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'About Botanique',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
