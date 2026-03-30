import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/auth_service.dart';
import '../schemas/user_schema.dart';
import '../notifiers/auth_notifier.dart';

class LoginPage extends StatefulWidget {
  final AuthNotifier? authNotifier;
  const LoginPage({super.key, this.authNotifier});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    final result = await AuthService.signin(
      SignInRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (result != null) {
      widget.authNotifier?.login(result.accessToken);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const green = Color.fromARGB(255, 225, 249, 226);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 67, 76, 68),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                    color: green,
                  ),
                ),
                const SizedBox(height: 10),
                Lottie.asset(
                  'assets/animations/login.json',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 10),
                _field(_emailController, 'Email', Icons.email),
                const SizedBox(height: 10),
                _field(
                  _passwordController,
                  'Password',
                  Icons.lock,
                  obscure: true,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 31, 32, 31),
                      backgroundColor: const Color.fromARGB(255, 227, 249, 227),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    bool obscure = false,
  }) {
    const green = Color.fromARGB(255, 225, 249, 226);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: ctrl,
        obscureText: obscure,
        style: const TextStyle(color: green, fontFamily: 'Raleway'),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: green),
          prefixIcon: Icon(icon, color: green),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: green.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: green, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: green),
          ),
        ),
      ),
    );
  }
}
