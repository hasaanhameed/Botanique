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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoaded)
                    const Text(
                      'BOTANIQUE',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 38,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 5,
                        color: Color.fromARGB(255, 225, 249, 226),
                      ),
                    ),

                  if (_isLoaded) const SizedBox(height: 6),

                  if (_isLoaded)
                    const Text(
                      'Your Premium Plant Companion',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.5,
                        color: Color.fromARGB(180, 225, 249, 226),
                      ),
                    ),

                  if (_isLoaded) const SizedBox(height: 5),

                  Lottie.asset(
                    'assets/animations/plant.json',
                    width: 260,
                    height: 260,
                    onLoaded: (composition) {
                      setState(() => _isLoaded = true);
                    },
                  ),

                  if (_isLoaded) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SignUpPage(authNotifier: widget.authNotifier),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 227, 240, 227),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 227, 240, 227),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                LoginPage(authNotifier: widget.authNotifier),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 227, 240, 227),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 227, 240, 227),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
