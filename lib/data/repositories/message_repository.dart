import 'dart:async';
import 'dart:convert';

import 'package:chat_app/services/api_client.dart';
import 'package:chat_app/services/web_socket_client.dart';
import 'package:models/models.dart';

class MessageRepository {
  final ApiClient apiClient;
  final WebSocketClient webSocketClient;
  StreamSubscription? _messageSubscription;

  MessageRepository({required this.apiClient, required this.webSocketClient});

  Future<void> createMessage(Message message) async {
    final payload = {
      'event': 'message.create',
      'data': message.toJson(),
    };
    webSocketClient.send(jsonEncode(payload));
  }

  Future<List<Message>> fetchMessages(String chatRoomId) async {
    final response = await apiClient.fetchMessages(chatRoomId);
    final message = response["messages"] as List<dynamic>;
    return message.map((e) => Message.fromJson(e)).toList();
  }

  void subscribeToMessageUpdate(
    void Function(Map<String, dynamic>) onMEssageReceived,
  ) {
    _messageSubscription = webSocketClient.messageUpdate().listen((event) {
      onMEssageReceived(event);
    });
  }

  void unSubscribeFromMessageUpdates() {
    _messageSubscription?.cancel();
    _messageSubscription = null;
  }
}
