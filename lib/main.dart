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
import 'package:models/models.dart';

final webSocketClient = WebSocketClient();

void main() {
  Bloc.observer = AppBlocObserver();

  DependencyInjection.setup();

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

const userId2 = 'e7bfa5fe-cdfb-43be-b55c-6ea14e05af8d';
const userId1 = '16d4a325-57db-445d-b2cf-c1369961c54f';

final chatRoom = ChatRoom(
  id: 'ad2769e8-6e72-4bee-8833-f9d8e02d6810',
  participants: const [
    User(
      id: userId1,
      phone: '1234512345',
      email: 'user1@email.com',
      avatarUrl:
          'https://images.unsplash.com/photo-1700493624764-f7524969037d?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      status: 'online',
      userName: 'User 1',
    ),
    User(
      id: userId2,
      userName: 'purboyndra',
      phone: '5432154321',
      email: 'purboyndra@email.com',
      avatarUrl:
          'https://images.unsplash.com/photo-1625008165193-addddb023516?q=80&w=3387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      status: 'online',
    ),
  ],
  lastMessage: Message(
    id: 'de120f3a-dbca-4330-9e2e-18b55a2fb9e5',
    chatRoomId: '8d162274-6cb8-4776-815a-8e721ebfb76d',
    senderUserId: userId1,
    receiverUserId: userId2,
    content: 'Hey! I am good, thanks.',
    createdAt: DateTime(2023, 12, 1, 1, 0, 0),
  ),
  unreadCount: 0,
);
