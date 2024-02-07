import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk/bloc/auth/auth_bloc.dart';
import 'package:talk/bloc/homeData/home_data_bloc.dart';
import 'package:talk/bloc/post/post_bloc.dart';
import 'package:talk/data/repository/auth_repository.dart';
import 'package:talk/data/repository/homeData_repository.dart';
import 'package:talk/data/repository/post_repository.dart';
import 'package:talk/presentation/profile/screen/cubit/addPost/add_post_cubit.dart';
import 'package:talk/presentation/profile/screen/cubit/imageSelect/image_select_cubit.dart';
import 'package:talk/register_dependencies.dart';
import 'package:talk/routes/routes.dart';

class MyApp extends StatelessWidget {
  final _router = getIt<AppRouter>();
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => getIt<AuthRepository>()),
        RepositoryProvider(create: (context) => HomeDataRepository()),
        RepositoryProvider(create: (context) => PostDataRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<AuthBloc>()),
          BlocProvider(create: (context) => HomeDataBloc()),
          BlocProvider(
              create: (context) => PostBloc()..add(const GetInitialPosts())),
          BlocProvider(create: (context) => AddPostCubit()),
          BlocProvider(create: (context) => ImageSelectCubit()),
        ],
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
