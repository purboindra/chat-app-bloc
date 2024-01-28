import 'dart:developer';

import 'package:chat_app/data/entities/user_entity.dart';
import 'package:chat_app/domain/bloc/message_bloc.dart';
import 'package:chat_app/domain/event/message_event.dart';
import 'package:chat_app/domain/state/message_state.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/widgets/avatar.dart';
import 'package:chat_app/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final List<Message> messages = [];
  final messageController = TextEditingController();

  final bool _isLoading = false;

  @override
  void initState() {
    context
        .read<MessageBloc>()
        .add(const FetchMessageEvent("ad2769e8-6e72-4bee-8833-f9d8e02d6810"));
    // _loadMessages();
    // _startWebSocket();
    // messageRepository.subscribeToMessageUpdate((p0) {
    //   log("MESSAGE UPDATE $p0");
    //   final message = Message.fromJson(p0);

    //   log("CHAT ROOM: ${message.chatRoomId} || ${widget.chatRoom.id}");
    //   if (message.chatRoomId == widget.chatRoom.id) {
    //     messages.add(message);
    //     messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    //     setState(() {});
    //   }
    // });
    super.initState();
  }

  // _loadMessages() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     final tempMessage =
  //         await widget.messageRepository.fetchMessages(widget.chatRoom.id);
  //     tempMessage.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  //     setState(() {
  //       messages.addAll(tempMessage);
  //     });
  //   } catch (e, st) {
  //     log("ERROR LOAD MESSAGE $e $st");
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  _startWebSocket() {
    log("WEB SOCKET STARTED");
    webSocketClient.connect('ws://localhost:8080/ws', {
      "Authorization": 'Bearer ...',
    });
  }

  // void _sendMessage() async {
  //   final message = Message(
  //     chatRoomId: widget.chatRoom.id,
  //     senderUserId: userId1,
  //     receiverUserId: userId2,
  //     content: messageController.text,
  //     createdAt: DateTime.now(),
  //   );

  //   await widget.messageRepository.createMessage(message);
  //   messageController.clear();
  // }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);

    // final currentParticipantUser = widget.chatRoom.participants.firstWhere(
    //   (element) => element.id == userId1,
    // );

    // final otherParticipantUser = widget.chatRoom.participants.firstWhere(
    //   (element) => element.id != currentParticipantUser.id,
    // );
    return BlocConsumer<MessageBloc, MessageState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is LoadingFetchMessage) {
          return const Scaffold(
            body: Center(
              child: Column(
                children: [CircularProgressIndicator.adaptive()],
              ),
            ),
          );
        } else if (state is SuccessFetchMessage) {
          return Scaffold(
            appBar: AppBar(
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
                    widget.participantUser.userName ?? "",
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
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
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
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final message = messages[index];

                                  final showImage =
                                      index + 1 == messages.length ||
                                          messages[index + 1].senderUserId !=
                                              message.senderUserId;

                                  return Row(
                                    mainAxisAlignment:
                                        (message.senderUserId == userId1)
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.end,
                                    children: [
                                      if (showImage &&
                                          message.senderUserId == userId1)
                                        const Avatar(
                                            imageUrl:
                                                "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=3276&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                            radius: 12),
                                      if (showImage &&
                                          message.senderUserId != userId1)
                                        const Avatar(
                                            imageUrl:
                                                "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=3387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                            radius: 12),
                                      MessageBubble(message: message),
                                    ],
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
                                  controller: messageController,
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
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        final message = Message(
                                            chatRoomId:
                                                widget.participantUser.id ?? "",
                                            senderUserId:
                                                prefs.getString("user_id") ??
                                                    "",
                                            receiverUserId:
                                                widget.participantUser.id ?? "",
                                            content: messageController.text,
                                            createdAt: DateTime.now());
                                        await Future.delayed(Duration.zero, () {
                                          context
                                              .read<MessageBloc>()
                                              .add(SendMessageEvent(
                                                message,
                                                prefs.getString("token") ?? "",
                                              ));
                                        });
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
