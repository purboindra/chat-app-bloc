import 'package:chat_app/data/entities/user_entity.dart';
import 'package:chat_app/domain/bloc/auth_bloc.dart';
import 'package:chat_app/domain/bloc/message_bloc.dart';
import 'package:chat_app/domain/event/auth_event.dart';
import 'package:chat_app/domain/event/message_event.dart';
import 'package:chat_app/domain/state/auth_state.dart';
import 'package:chat_app/domain/state/message_state.dart';
import 'package:chat_app/route/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<AuthenticationBloc>().add(GetUserFromPrefsEvent());
    final state = context.read<AuthenticationBloc>().state;
    if (state is ResultGetUserFromPrefsState) {
      BlocProvider.of<MessageBloc>(context)
          .add(FetchAllMessagesEvent(state.token));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;
    return Scaffold(
      body: BlocBuilder<MessageBloc, MessageState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is LoadingAllMessageState) {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator.adaptive(),
              ],
            ));
          } else if (state is SuccessAllMessageState) {
            if (state.messages.isEmpty) {
              return const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Chat"),
                ],
              ));
            }
            if (authState is LoadingSignOutState) {
              return const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(),
                ],
              ));
            }
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                final user = UserEntity.fromJson({
                                  "token": state.messages[index].token,
                                  "username": state.messages[index].username,
                                  "id": state.messages[index].id,
                                });

                                context.pushReplacement(
                                    AppRouteName.chatRoomScreen,
                                    extra: {
                                      "user": user.toJson(),
                                    });
                              },
                              child: Text("${state.messages[index].email}"));
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          onPressed: () =>
              context.read<AuthenticationBloc>().add(SignOutEvent()),
          heroTag: null,
          child: const Icon(Icons.logout),
        ),
        const SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          onPressed: () => context.push(AppRouteName.searchScreen),
          heroTag: null,
          child: const Icon(Icons.add),
        )
      ]),
    );
  }
}
