part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

sealed class AuthState extends Equatable {
  const AuthState(
      {this.status = AuthStatus.unknown, this.username = 'Shashinoor'});
  final AuthStatus status;
  final String username;
  
  @override
  List<Object> get props => [status,username];
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
  const AuthSignedIn({AuthStatus status = AuthStatus.authenticated})
      : super(status: AuthStatus.authenticated, username: 'Shashinoor');
}