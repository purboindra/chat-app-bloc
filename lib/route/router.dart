import 'package:chat_app/route/route_name.dart';
import 'package:chat_app/screens/authentication_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRouteName.signUpScreen,
    routes: <RouteBase>[
      // GoRoute(
      //   path: AppRouteName.splashScreen,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return BlocBuilder<authBloc.AuthBloc, authState.AuthState>(
      //       buildWhen: (previous, current) =>
      //           previous != authState.InitialAuthState(),
      //       builder: (context, state) {
      //         return const SplashScreen();
      //       },
      //     );
      //   },
      // ),

      GoRoute(
        path: AppRouteName.mainScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: AppRouteName.signUpScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const AuthenticationScreen();
        },
      ),
    ],
  );
}
