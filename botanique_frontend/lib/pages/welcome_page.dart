import 'package:botanique/notifiers/auth_notifier.dart';
import 'package:botanique/pages/signup_page.dart';
import 'package:botanique/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatefulWidget {
  final AuthNotifier? authNotifier;
  const WelcomePage({super.key, this.authNotifier});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 67, 76, 68),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoaded)
                  const Text(
                    'BOTANIQUE',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 48,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 4,
                      color: Color.fromARGB(255, 225, 249, 226),
                    ),
                  ),

                if (_isLoaded) const SizedBox(height: 5),

                Lottie.asset(
                  'assets/animations/plant.json',
                  width: 280,
                  height: 280,
                  onLoaded: (composition) {
                    setState(() => _isLoaded = true);
                  },
                ),

                if (_isLoaded) ...[
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SignUpPage(authNotifier: widget.authNotifier),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(
                          255,
                          227,
                          249,
                          227,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Create Account"),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              LoginPage(authNotifier: widget.authNotifier),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(
                          255,
                          227,
                          249,
                          227,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Login"),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
