import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_app/data/entities/message_entity.dart';
import 'package:chat_app/data/entities/user_entity.dart';
import 'package:chat_app/domain/bloc/message_bloc.dart';
import 'package:chat_app/domain/event/message_event.dart';
import 'package:chat_app/domain/state/message_state.dart';
import 'package:chat_app/env/env.dart';
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
  });

  final UserEntity participantUser;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageController = TextEditingController();
  late StreamSubscription streamSubscription;
  String currentUid = '';

  String wsUrl = 'ws://${Platform.isIOS ? "localhost" : Env.IP}:8080/ws';

  @override
  void initState() {
    getData();
    context.read<MessageBloc>().add(FetchMessageEvent(
        widget.participantUser.id!, widget.participantUser.id!));
    _startWebSocket();
    listenMessage();
    super.initState();
  }

  void _sendMessageCreatedWs(String data) {
    webSocketClient!.send(data);
  }

  void _sendMessageReceivedWs(String data) {
    webSocketClient!.send(data);
    AppPrint.debugPrint("SEND MESSAGE RECEIVED CALLED $data");
  }

  void listenMessage() {
    streamSubscription = webSocketClient!.messageUpdate().listen((event) {
      onMessageReceived(event);
    });
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    currentUid = prefs.getString("user_id") ?? "No User Id";
  }

  void _sendMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final message = Message(
        chatRoomId: widget.participantUser.id!,
        senderUserId: prefs.getString("user_id") ?? "",
        receiverUserId: widget.participantUser.id!,
        content: _messageController.text,
        createdAt: DateTime.now());

    _sendMessageCreatedWs(jsonEncode({
      "event": "message.created",
      "message": message.toJson(),
      "token": prefs.getString("token") ?? "",
    }));

    _messageController.clear();
  }

  void onMessageReceived(Map<String, dynamic> message) {
    AppPrint.debugPrint('ON MESSAGE RECEIVED $message');
    List<MessageEntity> messages = [];
    final state = BlocProvider.of<MessageBloc>(context).state;
    if (state is SuccessFetchMessage) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pesan baru")));
      messages.addAll(state.message);
      messages.add(MessageEntity.fromJson(message));
      BlocProvider.of<MessageBloc>(context).add(UpdateMessagesEvent(messages));
    }
    _sendMessageReceivedWs(jsonEncode({
      "event": "message.received",
      "message": message,
    }));
  }

  @override
  void dispose() {
    _messageController.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  _startWebSocket() {
    if (webSocketClient != null) {
      webSocketClient!.connect(
        wsUrl,
        // TODO TOKEN
        {
          'Authorization': 'Bearer ',
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
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
              widget.participantUser.userName ?? "Anonymous",
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
      body: BlocBuilder<MessageBloc, MessageState>(builder: (context, state) {
        if (state is LoadingFetchMessage) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator.adaptive(),
              ],
            ),
          );
        }
        if (state is SuccessFetchMessage) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 0,
                  bottom: (viewInsets.bottom > 0) ? 8 : 0),
              child: Column(
                children: [
                  state.message.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Start a new messages..."),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              itemCount: state.message.length,
                              itemBuilder: (context, index) {
                                final message = state.message[index];
                                String timestampString = message.createdAt ??
                                    DateTime.now().toIso8601String();
                                DateTime timestamp =
                                    DateTime.parse(timestampString);
                                int hour = timestamp.hour;
                                int minute = timestamp.minute;
                                return Align(
                                  alignment: message.senderUserId ==
                                          widget.participantUser.id
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                                  child: Column(
                                    crossAxisAlignment: message.senderUserId ==
                                            widget.participantUser.id
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
                                          color: message.senderUserId ==
                                                  widget.participantUser.id
                                              ? Colors.purple
                                              : Colors.blue,
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
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      }),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
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
                    fillColor:
                        Theme.of(context).colorScheme.primary.withAlpha(100),
                    hintText: "Type a message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: _messageController.text.isEmpty
                          ? null
                          : () async {
                              _sendMessage();
                            },
                      icon: const Icon(Icons.send),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
