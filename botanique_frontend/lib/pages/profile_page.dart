import 'package:botanique/notifiers/auth_notifier.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../schemas/user_schema.dart';

class ProfilePage extends StatefulWidget {
  final AuthNotifier? authNotifier;

  const ProfilePage({super.key, this.authNotifier});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final token = widget.authNotifier?.token;
    if (token == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final profile = await AuthService.getProfile(token);
    if (mounted) {
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    }
  }

  Future<void> _showChangePasswordDialog() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final cs = Theme.of(context).colorScheme;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text('Change Password', style: TextStyle(color: cs.onSurface)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              style: TextStyle(color: cs.onSurface),
              decoration: InputDecoration(
                hintText: 'Current Password',
                hintStyle: TextStyle(color: cs.secondary),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: cs.primary.withOpacity(0.5)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: cs.primary),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              style: TextStyle(color: cs.onSurface),
              decoration: InputDecoration(
                hintText: 'New Password',
                hintStyle: TextStyle(color: cs.secondary),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: cs.primary.withOpacity(0.5)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: cs.primary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: cs.primary)),
          ),
          TextButton(
            onPressed: () async {
              final currentPassword = currentPasswordController.text.trim();
              final newPassword = newPasswordController.text.trim();
              if (currentPassword.isEmpty || newPassword.isEmpty) return;

              final token = widget.authNotifier?.token;
              if (token == null) return;

              final success = await AuthService.updatePassword(
                token,
                currentPassword,
                newPassword,
              );
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Password updated' : 'Invalid current password',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: Text('Update', style: TextStyle(color: cs.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: cs.primary));
    }

    final name = _profile?.name ?? 'User';
    final email = _profile?.email ?? 'Unknown Email';
    final count = _profile?.identificationCount ?? 0;
    final memberSince = _profile?.memberSince ?? 'Unknown Date';

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Profile',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                  color: cs.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: cs.onSurface,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                email,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14,
                  color: cs.secondary,
                ),
              ),

              const SizedBox(height: 12),

              Divider(color: cs.primary.withValues(alpha: 0.5), thickness: 1),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Text(
                      "$count Plants Identified",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Member Since $memberSince",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Divider(color: cs.primary.withValues(alpha: 0.5), thickness: 1),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: _showChangePasswordDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Change Password",
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    widget.authNotifier?.logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Logout",
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
