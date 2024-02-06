import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/bloc/auth/auth_bloc.dart';
import 'package:talk/presentation/auth/login/widgets/google_button.dart';
import 'package:talk/presentation/auth/login/widgets/guest_button.dart';
import 'package:talk/presentation/auth/login/widgets/sign_up_button.dart';
import 'package:talk/register_dependencies.dart';
import 'package:talk/routes/constants.dart';
import 'package:talk/routes/redirected.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedIn) {
          final redirectedFrom = getIt<Redirected>().getRedirectedUrl();
          if (redirectedFrom.isNotEmpty) {
            GoRouter.of(context).go(redirectedFrom);
            getIt<Redirected>().setRedirectedUrl('');
          } else {
            GoRouter.of(context).push(AppRouteConstantsPublic.home);
          }
          // GoRouter.of(context).push(redirectedFrom.isNotEmpty
          //     ? redirectedFrom
          //     : AppRouteConstantsPublic.home);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Login Page'),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!EmailValidator.validate(value)) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                          ),
                        ],
                      )),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(SignInEvent(
                            email: _emailController.text,
                            password: _passwordController.text));
                      }
                    },
                    child: const Text('Login'),
                  ),
                  BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                    if (state is AuthSignInError) {
                      return Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    return Container();
                  }),
                  const SignUpButton(),
                  const GoogleSignInButton(),
                  const SignInAsGuestButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
