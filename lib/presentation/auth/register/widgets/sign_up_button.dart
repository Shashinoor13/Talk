import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk/bloc/auth/auth_bloc.dart';

class SignUpButton extends StatelessWidget {
  final Function? onPressed;
  const SignUpButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed!();
      },
      child: const Text(
        'Sign Up',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
