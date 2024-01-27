import 'dart:async';

import 'package:chat_app/data/entities/message_entity.dart';
import 'package:chat_app/domain/repositories/message_repository.dart';
import 'package:chat_app/services/api_client.dart';

class MessageRepositoryImpl implements MessageRepository {
  final ApiClient apiClient;

  const MessageRepositoryImpl(this.apiClient);

  @override
  Future<List<MessageEntity>> fetchAllMessages() async {
    List<MessageEntity> messages = [];
    final response = await apiClient.fetchAllMessages();
    if (response.isEmpty) return messages;
    for (final message in response) {
      messages.add(MessageEntity.fromJson(message));
    }
    return messages;
  }
}

// class MessageRepository {
//   final ApiClient apiClient;
//   final WebSocketClient webSocketClient;
//   StreamSubscription? _messageSubscription;

//   MessageRepository({required this.apiClient, required this.webSocketClient});

//   Future<void> createMessage(Message message) async {
//     final payload = {
//       'event': 'message.create',
//       'data': message.toJson(),
//     };
//     webSocketClient.send(jsonEncode(payload));
//   }

//   Future<List<Message>> fetchMessages(String chatRoomId) async {
//     final response = await apiClient.fetchMessages(chatRoomId);
//     final message = response["messages"] as List<dynamic>;
//     return message.map((e) => Message.fromJson(e)).toList();
//   }

//   void subscribeToMessageUpdate(
//     void Function(Map<String, dynamic>) onMEssageReceived,
//   ) {
//     _messageSubscription = webSocketClient.messageUpdate().listen((event) {
//       onMEssageReceived(event);
//     });
//   }

//   void unSubscribeFromMessageUpdates() {
//     _messageSubscription?.cancel();
//     _messageSubscription = null;
//   }
// }
