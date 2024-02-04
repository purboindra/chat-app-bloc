import 'package:chat_app/app_bloc.dart';
import 'package:chat_app/di/dependency_injection.dart';
import 'package:chat_app/di/inject.dart';
import 'package:chat_app/domain/bloc/auth_bloc.dart';
import 'package:chat_app/domain/bloc/message_bloc.dart';
import 'package:chat_app/domain/bloc/search_bloc.dart';
import 'package:chat_app/domain/event/auth_event.dart';
import 'package:chat_app/route/router.dart';
import 'package:chat_app/services/web_socket_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

WebSocketClient? webSocketClient;

void main() {
  Bloc.observer = AppBlocObserver();

  DependencyInjection.setup();
  webSocketClient = WebSocketClient();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AuthenticationBloc(inject())..add(GetUserFromPrefsEvent()),
        ),
        BlocProvider(
          create: (_) => MessageBloc(inject()),
        ),
        BlocProvider(
          create: (_) => SearchBloc(inject()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
