import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../schemas/user_schema.dart';
import '../notifiers/auth_notifier.dart';

class SignUpPage extends StatefulWidget {
  final AuthNotifier? authNotifier;
  const SignUpPage({super.key, this.authNotifier});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    final result = await AuthService.signup(
      SignUpRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (result.containsKey('user_id')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created! Please log in.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['detail'] ?? 'Signup failed'),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                    color: green,
                  ),
                ),
                const SizedBox(height: 20),
                _field(_nameController, 'Name', Icons.person),
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
                        : const Text('Submit'),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: green),
          ),
        ),
      ),
    );
  }
}
