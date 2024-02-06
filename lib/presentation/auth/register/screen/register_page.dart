import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:talk/bloc/auth/auth_bloc.dart';
import 'package:talk/presentation/auth/register/widgets/sign_up_button.dart';

class RegisterPage extends StatelessWidget {
  final GlobalKey<FormState> _registerForm = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final passwordStrengthNotifier = ValueNotifier<PasswordStrength?>(null);
  final passwordVisible = ValueNotifier<bool>(false);

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Loading'),
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          executeSignUpProcess() {
            if (_registerForm.currentState!.validate()) {
              context.read<AuthBloc>().add(
                    SignUpEvent(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ),
                  );
            }
          }

          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _registerForm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address.';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: passwordStrengthNotifier,
                          builder: (context, value, child) {
                            return ValueListenableBuilder(
                              valueListenable: passwordVisible,
                              builder: (context, value, child) {
                                return TextFormField(
                                  controller: _passwordController,
                                  obscureText: !passwordVisible.value,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        passwordVisible.value =
                                            !passwordVisible.value;
                                      },
                                    ),
                                    hintText: 'Password',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: passwordStrengthNotifier
                                                .value?.statusColor ??
                                            Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: passwordStrengthNotifier
                                                .value?.statusColor ??
                                            Colors.grey,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    if (PasswordStrength.calculate(
                                            text: value) ==
                                        PasswordStrength.weak) {
                                      return 'Password is weak';
                                    }
                                    if (PasswordStrength.calculate(
                                            text: value) ==
                                        PasswordStrength.alreadyExposed) {
                                      return 'Password is already exposed';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    passwordStrengthNotifier.value =
                                        PasswordStrength.calculate(text: value);
                                    _passwordController.text = value;
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (state is AuthSignUpError) Text(state.message),
                SignUpButton(onPressed: executeSignUpProcess)
              ],
            ),
          );
        },
      ),
    );
  }
}
