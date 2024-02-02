import 'package:chat_app/data/entities/user_entity.dart';
import 'package:chat_app/route/route_name.dart';
import 'package:chat_app/screens/authentication_screen.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
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
      GoRoute(
        path: AppRouteName.chatRoomScreen,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>?;

          UserEntity? userEntity;
          String? id;

          if (data != null) {
            if (data.containsKey("userId")) {
              id = data["userId"];
            }
            if (data.containsKey("user")) {
              userEntity = UserEntity.fromJson(data["user"]);
            }
          }
          return ChatRoomScreen(
            uid: id ?? "",
            participantUser: userEntity ?? UserEntity(),
          );
        },
      ),
    ],
  );
}
