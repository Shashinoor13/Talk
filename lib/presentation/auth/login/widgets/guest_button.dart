import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/routes/constants.dart';

class SignInAsGuestButton extends StatelessWidget {
  const SignInAsGuestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        GoRouter.of(context).go(AppRouteConstantsPublic.home);
      },
      child: const Text(
        'Sign in as Guest',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
