// import 'dart:developer';

// import 'package:chat_app/data/repositories/message_repository.dart';
// import 'package:chat_app/domain/repositories/message_repository.dart';
// import 'package:chat_app/main.dart';
// import 'package:chat_app/widgets/avatar.dart';
// import 'package:chat_app/widgets/message_bubble.dart';
// import 'package:flutter/material.dart';
// import 'package:models/models.dart';

// class ChatRoomScreen extends StatefulWidget {
//   const ChatRoomScreen(
//       {super.key, required this.messageRepository, required this.chatRoom});

//   final ChatRoom chatRoom;
//   final MessageRepository messageRepository;

//   @override
//   State<ChatRoomScreen> createState() => _ChatRoomScreenState();
// }

// class _ChatRoomScreenState extends State<ChatRoomScreen> {
//   final List<Message> messages = [];
//   final messageController = TextEditingController();

//   bool _isLoading = false;

//   @override
//   void initState() {
//     _loadMessages();
//     _startWebSocket();
//     widget.messageRepository.subscribeToMessageUpdate((p0) {
//       log("MESSAGE UPDATE $p0");
//       final message = Message.fromJson(p0);

//       log("CHAT ROOM: ${message.chatRoomId} || ${widget.chatRoom.id}");
//       if (message.chatRoomId == widget.chatRoom.id) {
//         messages.add(message);
//         messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
//         setState(() {});
//       }
//     });
//     super.initState();
//   }

//   _loadMessages() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final tempMessage =
//           await widget.messageRepository.fetchMessages(widget.chatRoom.id);
//       tempMessage.sort((a, b) => a.createdAt.compareTo(b.createdAt));
//       setState(() {
//         messages.addAll(tempMessage);
//       });
//     } catch (e, st) {
//       log("ERROR LOAD MESSAGE $e $st");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   _startWebSocket() {
//     log("WEB SOCKET STARTED");
//     webSocketClient.connect('ws://localhost:8080/ws', {
//       "Authorization": 'Bearer ...',
//     });
//   }

//   void _sendMessage() async {
//     final message = Message(
//       chatRoomId: widget.chatRoom.id,
//       senderUserId: userId1,
//       receiverUserId: userId2,
//       content: messageController.text,
//       createdAt: DateTime.now(),
//     );

//     await widget.messageRepository.createMessage(message);
//     messageController.clear();
//   }

//   @override
//   void dispose() {
//     messageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final viewInsets = MediaQuery.viewInsetsOf(context);

//     final currentParticipantUser = widget.chatRoom.participants.firstWhere(
//       (element) => element.id == userId1,
//     );

//     final otherParticipantUser = widget.chatRoom.participants.firstWhere(
//       (element) => element.id != currentParticipantUser.id,
//     );
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Column(
//           children: [
//             const SizedBox(
//               height: 3.0,
//             ),
//             Avatar(
//               imageUrl: otherParticipantUser.avatarUrl,
//               radius: 20,
//             ),
//             Text(
//               otherParticipantUser.userName,
//               style: Theme.of(context).textTheme.bodySmall,
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.more_vert,
//             ),
//           ),
//           const SizedBox(
//             width: 8,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : !_isLoading && messages.isEmpty
//               ? Center(
//                   child: Text("Chat with ${otherParticipantUser.userName}"),
//                 )
//               : SafeArea(
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                         left: 16.0,
//                         right: 16.0,
//                         top: 0,
//                         bottom: (viewInsets.bottom > 0) ? 8 : 0),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: ListView.builder(
//                               itemCount: messages.length,
//                               itemBuilder: (context, index) {
//                                 final message = messages[index];

//                                 final showImage =
//                                     index + 1 == messages.length ||
//                                         messages[index + 1].senderUserId !=
//                                             message.senderUserId;

//                                 return Row(
//                                   mainAxisAlignment:
//                                       (message.senderUserId == userId1)
//                                           ? MainAxisAlignment.start
//                                           : MainAxisAlignment.end,
//                                   children: [
//                                     if (showImage &&
//                                         message.senderUserId == userId1)
//                                       Avatar(
//                                           imageUrl:
//                                               otherParticipantUser.avatarUrl,
//                                           radius: 12),
//                                     if (showImage &&
//                                         message.senderUserId != userId1)
//                                       Avatar(
//                                           imageUrl:
//                                               currentParticipantUser.avatarUrl,
//                                           radius: 12),
//                                     MessageBubble(message: message),
//                                   ],
//                                 );
//                               }),
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               onPressed: () {},
//                               icon: const Icon(
//                                 Icons.attach_file,
//                               ),
//                             ),
//                             Expanded(
//                               child: TextFormField(
//                                 controller: messageController,
//                                 decoration: InputDecoration(
//                                   filled: true,
//                                   fillColor: Theme.of(context)
//                                       .colorScheme
//                                       .primary
//                                       .withAlpha(100),
//                                   hintText: "Type a message",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   suffixIcon: IconButton(
//                                     onPressed: () {
//                                       _sendMessage();
//                                     },
//                                     icon: const Icon(Icons.send),
//                                   ),
//                                 ),
//                               ),
//                             ),s
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//     );
//   }
// }
