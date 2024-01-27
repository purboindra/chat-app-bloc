import 'package:chat_app/route/route_name.dart';
import 'package:chat_app/screens/authentication_screen.dart';
import 'package:chat_app/screens/messages_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRouteName.authenticationScreen,
    routes: <RouteBase>[
      GoRoute(
        path: AppRouteName.mainScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: AppRouteName.authenticationScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const AuthenticationScreen();
        },
      ),
      GoRoute(
        path: AppRouteName.searchScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const SearchScreen();
        },
      ),
    ],
  );
}
