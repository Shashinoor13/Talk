import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk/bloc/auth/auth_bloc.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      InkWell(
        onTap: () {
          context.read<AuthBloc>().add(SignInWithGoogleEvent());
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/google_logo.webp',
                height: 20,
                width: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'Sign in with Google',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
