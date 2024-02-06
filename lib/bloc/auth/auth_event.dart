part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthEventStarted extends AuthEvent {}

class AuthEventLoggedIn extends AuthEvent {
  final User user;

  const AuthEventLoggedIn({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthEventLoggedOut extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;

  const SignUpEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignOutEvent extends AuthEvent {}

//google
class SignInWithGoogleEvent extends AuthEvent {}
