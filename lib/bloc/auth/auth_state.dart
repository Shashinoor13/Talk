part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, error }

sealed class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.unknown});
  final AuthStatus status;

  @override
  List<Object> get props => [status];
}

final class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class AuthSignedOut extends AuthState {}

final class AuthSignedUp extends AuthState {}

final class AuthSignedIn extends AuthState {
  //update the status to authenticated
  const AuthSignedIn(this.user, {AuthStatus status = AuthStatus.authenticated})
      : super(status: AuthStatus.authenticated);
  final User user;
}

final class AuthSignInError extends AuthState {
  final String message;

  const AuthSignInError({required this.message});

  @override
  List<Object> get props => [message];
}

final class AuthSignUpError extends AuthState {
  final String message;

  const AuthSignUpError({required this.message});

  @override
  List<Object> get props => [message];
}
