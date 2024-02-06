import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/bloc/auth/auth_bloc.dart';
import 'package:talk/navigationShell/navigationShell.dart';
import 'package:talk/presentation/chat/home/chat_home.dart';
import 'package:talk/presentation/chat/inbox/inbox_page.dart';
import 'package:talk/presentation/home/screen/home_page.dart';
import 'package:talk/presentation/auth/login/screen/login_page.dart';
import 'package:talk/presentation/profile/screen/posts_page.dart';
import 'package:talk/presentation/profile/screen/profile_page.dart';
import 'package:talk/presentation/auth/register/screen/register_page.dart';
import 'package:talk/presentation/profile/screen/settings_page.dart';
import 'package:talk/register_dependencies.dart';
import 'package:talk/routes/constants.dart';
import 'package:talk/routes/redirected.dart';

class StatefulShellBranchWithIcon extends StatefulShellBranch {
  final IconData icon;
  final String label;

  StatefulShellBranchWithIcon({
    required List<GoRoute> routes,
    required this.icon,
    required this.label,
  }) : super(routes: routes);
}

class AppRouter {
  final AuthBloc authBloc;
  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    initialLocation: AppRouteConstantsPublic.home,
    routes: [
      GoRoute(
        name: AppRouteConstantsPublic.login,
        path: '/login',
        pageBuilder: (context, state) => buildPage(context, state, LoginPage()),
      ),
      GoRoute(
        name: AppRouteConstantsPublic.signup,
        path: '/signup',
        pageBuilder: (context, state) =>
            buildPage(context, state, RegisterPage()),
      ),
      StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranchWithIcon(
              routes: [
                GoRoute(
                  name: AppRouteConstantsPublic.home,
                  path: '/',
                  pageBuilder: (context, state) =>
                      buildPage(context, state, HomePage()),
                ),
              ],
              icon: Icons.home,
              label: 'Home',
            ),
            StatefulShellBranchWithIcon(routes: [
              GoRoute(
                name: AppRouteConstantsPrivate.chat,
                path: '/chat',
                pageBuilder: (context, state) =>
                    buildPage(context, state, const ChatHomePage()),
              ),
              GoRoute(
                name: AppRouteConstantsPrivate.chatInbox,
                path: '/chat/inbox/:room_id',
                pageBuilder: (context, state) =>
                    buildPage(context, state, const ChatInboxPage()),
              ),
            ], icon: Icons.message, label: 'Chat'),
            StatefulShellBranchWithIcon(
              routes: [
                GoRoute(
                  name: AppRouteConstantsPrivate.profile,
                  path: '/profile',
                  pageBuilder: (context, state) =>
                      buildPage(context, state, const ProfilePage()),
                ),
                GoRoute(
                  path: '/profile/settings',
                  name: AppRouteConstantsPrivate.settings,
                  pageBuilder: (context, state) => buildPage(
                    context,
                    state,
                    const ProfileSettings(),
                  ),
                ),
                GoRoute(
                  path: '/profile/myPost/:id',
                  name: AppRouteConstantsPrivate.myPost,
                  pageBuilder: (context, state) => buildPage(
                    context,
                    state,
                    MyPostsPage(
                      userId: state.pathParameters['id']!,
                    ),
                  ),
                ),
              ],
              icon: Icons.person,
              label: 'Profile',
            ),
          ])
    ],
    redirect: (context, state) {
      final bool isTryingToLogin =
          state.matchedLocation == AppRouteConstantsPublic.login;
      final bool isTryingToSignup =
          state.matchedLocation == AppRouteConstantsPublic.signup;

      final List<String> privateRoutes = AppRouteConstantsPrivate.all;

      final bool isAuthenticated = authBloc.state is AuthSignedIn;

      if (privateRoutes.any((route) => state.matchedLocation.contains(route))) {
        if (!isAuthenticated) {
          getIt<Redirected>().setRedirectedUrl(state.matchedLocation);
          return "${AppRouteConstantsPublic.login}?redirectFrom=${state.matchedLocation}";
        } else {
          return null;
        }
      }

      if (isTryingToLogin || isTryingToSignup) {
        if (isAuthenticated) {
          return AppRouteConstantsPublic.home;
        } else {
          return null;
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((event) {
      notifyListeners();
    });
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

MaterialPage buildPage(BuildContext context, dynamic state, Widget child) {
  return MaterialPage(child: child);
}
