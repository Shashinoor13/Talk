import 'package:get_it/get_it.dart';
import 'package:talk/bloc/auth/auth_bloc.dart';
import 'package:talk/data/repository/auth_repository.dart';
import 'package:talk/routes/redirected.dart';
import 'package:talk/routes/routes.dart';

final getIt = GetIt.instance;

void registerDependencies() {
  getIt.registerSingleton<AuthRepository>(AuthRepository());
  AuthBloc authBloc = AuthBloc(authRepository: getIt<AuthRepository>());
  getIt.registerSingleton<AuthBloc>(authBloc);
  authBloc.add(AuthEventStarted());

  getIt.registerSingleton<AppRouter>(AppRouter(authBloc: getIt<AuthBloc>()));
  getIt.registerSingleton<Redirected>(Redirected());
}
