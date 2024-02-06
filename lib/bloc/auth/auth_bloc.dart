import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:talk/data/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  late StreamSubscription _authSubscription;
  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    _authSubscription = authRepository.user.listen(_onUserStatusChanged);
    on<AuthEvent>((event, emit) async {
      if (event is AuthEventStarted) {
        print("AuthEventStarted");
      }
      if (event is AuthEventLoggedIn) {
        emit(AuthSignedIn(event.user));
      }

      if (event is SignInEvent) {
        emit(AuthLoading());
        try {
          final user = await authRepository.signIn(
              email: event.email, password: event.password);

          emit(AuthSignedIn(user.user!));
        } catch (e) {
          // emit(AuthSignInError(message: e.toString()));
          emit(AuthSignInError(message: e.toString()));
        }
      }
      if (event is SignUpEvent) {
        emit(AuthLoading());
        try {
          final user = await authRepository.signUp(
              email: event.email, password: event.password);
          emit(AuthSignedIn(
            user.user!,
          ));
        } catch (e) {
          emit(AuthSignUpError(message: e.toString()));
        }
      }
      if (event is SignOutEvent) {
        emit(AuthLoading());
        try {
          await authRepository.signOut();
          emit(AuthSignedOut());
        } catch (e) {
          print(e);
        }
      }
      if (event is SignInWithGoogleEvent) {
        emit(AuthLoading());
        try {
          final userCredentials = await authRepository.signInWithGoogle();
          emit(AuthSignedIn(userCredentials.user!));
        } catch (e) {
          emit(AuthSignInError(message: e.toString()));
        }
      }
    });
  }

  void _onUserStatusChanged(User? user) {
    if (user != null) {
      add(
        AuthEventLoggedIn(user: user),
      );
    } else {
      add(AuthEventLoggedOut());
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
