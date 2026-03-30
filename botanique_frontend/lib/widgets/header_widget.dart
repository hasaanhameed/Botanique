import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: cs.surface,
      automaticallyImplyLeading: false,
      title: Text(
        'BOTANIQUE',
        style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 24,
          fontWeight: FontWeight.w300,
          letterSpacing: 2,
          color: cs.onSurface,
        ),
      ),
      actions: [
        Lottie.asset(
          'assets/animations/login.json',
          width: 40,
          height: 40,
        ),
      ],
    );
  }
}
