import 'dart:async';
import 'dart:convert';

import 'package:chat_app/data/entities/user_entity.dart';
import 'package:chat_app/domain/bloc/message_bloc.dart';
import 'package:chat_app/domain/event/message_event.dart';
import 'package:chat_app/domain/state/message_state.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/route/route_name.dart';
import 'package:chat_app/utils/app_print.dart';
import 'package:chat_app/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    super.key,
    required this.participantUser,
    required this.uid,
  });

  final UserEntity participantUser;
  final String uid;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageController = TextEditingController();
  late StreamSubscription streamSubscription;
  String currentUid = '';

  final uri = Uri.parse('ws://localhost:8080/ws');

  void sendWs(String data) {
    webSocketClient!.send(data);
  }

  @override
  void initState() {
    context.read<MessageBloc>().add(FetchMessageEvent(widget.uid));
    _startWebSocket();
    listenMessage();
    // context.read<MessageBloc>().add(SubscribeMessageEvent((p1) {
    //   AppPrint.debugPrint("MESSAGE UPDATE $p1");
    // }));
    super.initState();
  }

  void listenMessage() {
    AppPrint.debugPrint('LISTEN MESSAGE CALLED');
    streamSubscription = webSocketClient!.messageUpdate().listen((event) {
      AppPrint.debugPrint('LISTEN MESSAGE $event');
      BlocProvider.of<MessageBloc>(context).add(FetchMessageEvent(widget.uid));
    });
  }

  void _sendMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final message = Message(
        chatRoomId: widget.uid,
        senderUserId: prefs.getString("user_id") ?? "",
        receiverUserId: widget.uid,
        content: _messageController.text,
        createdAt: DateTime.now());
    sendWs(jsonEncode({
      "event": "message.created",
      "message": message.toJson(),
      "token": prefs.getString("token") ?? "",
    }));
    _messageController.clear();
  }

  void onMessageReceived(Map<String, dynamic> message) {
    // Lakukan sesuatu dengan pesan yang diterima
    print('Pesan diterima: $message');
  }

  @override
  void dispose() {
    _messageController.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  _startWebSocket() {
    if (webSocketClient != null) {
      AppPrint.debugPrint('WEBSOCKET NOT NULL');
      webSocketClient!.connect(
        'ws://localhost:8080/ws',
        {
          'Authorization': 'Bearer ',
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return BlocConsumer<MessageBloc, MessageState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        // if (state is LoadingFetchMessage) {
        //   return const Scaffold(
        //     body: Center(
        //       child: Column(
        //         children: [CircularProgressIndicator.adaptive()],
        //       ),
        //     ),
        //   );
        // } else
        if (state is SuccessFetchMessage) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  //  context.read<MessageBloc>().add(FetchAllMessagesEvent(state.message.firstWhere((element) => element.id==widget.uid)));
                  context.pushReplacement(AppRouteName.mainScreen);
                },
                icon: const Icon(
                  Icons.chevron_left,
                ),
              ),
              centerTitle: true,
              title: Column(
                children: [
                  const SizedBox(
                    height: 3.0,
                  ),
                  const Avatar(
                    imageUrl:
                        "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=3387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    radius: 20,
                  ),
                  Text(
                    "",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            body: state.message.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Start a new messages..."),
                      ],
                    ),
                  )
                : SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 0,
                          bottom: (viewInsets.bottom > 0) ? 8 : 0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: state.message.length,
                                itemBuilder: (context, index) {
                                  final message = state.message[index];
                                  String timestampString = message.createdAt!;
                                  DateTime timestamp =
                                      DateTime.parse(timestampString);
                                  int hour = timestamp.hour;
                                  int minute = timestamp.minute;
                                  return Align(
                                    alignment:
                                        message.senderUserId != currentUid
                                            ? Alignment.topLeft
                                            : Alignment.topRight,
                                    child: Column(
                                      crossAxisAlignment:
                                          message.senderUserId != currentUid
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(4)
                                              .copyWith(right: 0),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: message.senderUserId !=
                                                    currentUid
                                                ? Colors.blue
                                                : Colors.purple,
                                          ),
                                          child: Text(
                                            message.message ?? "",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "$hour:$minute",
                                          style: const TextStyle(),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.attach_file,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withAlpha(100),
                                    hintText: "Type a message",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        _sendMessage();
                                      },
                                      icon: const Icon(Icons.send),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text("data"),
          ),
        );
      },
    );
  }
}
