import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/routes/constants.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        GoRouter.of(context).push(AppRouteConstantsPublic.signup);
      },
      child: const Text(
        'Sign Up',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
