import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:talk/data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthEventLoggedIn) {
        emit(const AuthSignedIn());
      }
      if (event is AuthEventLoggedOut) {
        emit(AuthSignedOut());
      }
      if (event is AuthEventStarted) {
        emit(AuthLoading());
        await Future.delayed(const Duration(seconds: 2));
        emit(AuthSignedOut());
      }
    });
  }
}
