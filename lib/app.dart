import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk/bloc/auth/auth_bloc.dart';
import 'package:talk/data/repository/auth_repository.dart';
import 'package:talk/register_dependencies.dart';
import 'package:talk/routes/routes.dart';

class MyApp extends StatelessWidget {
  final _router = getIt<AppRouter>();
   MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => getIt<AuthRepository>(),
      child: BlocProvider(
        create: (context) => getIt<AuthBloc>(),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Talk',
          routeInformationProvider: _router.router.routeInformationProvider,
          routerDelegate: _router.router.routerDelegate,
          routeInformationParser: _router.router.routeInformationParser,
        ),
      ),
    );
  }
}