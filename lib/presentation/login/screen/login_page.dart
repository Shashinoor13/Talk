
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/bloc/auth/auth_bloc.dart';
import 'package:talk/register_dependencies.dart';
import 'package:talk/routes/constants.dart';
import 'package:talk/routes/redirected.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedIn) {
          final redirectedFrom = getIt<Redirected>().getRedirectedUrl();
          context.go(redirectedFrom.isNotEmpty
              ? redirectedFrom
              : AppRouteConstantsPublic.home);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  const Text('Login Page'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthEventLoggedIn());
                    },
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.go(AppRouteConstantsPublic.signup);
                    },
                    child: const Text('SignUp'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
