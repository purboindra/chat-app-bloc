import 'dart:async';

import 'package:chat_app/data/entities/chat_room_entity.dart';
import 'package:chat_app/data/entities/message_entity.dart';
import 'package:models/models.dart';

abstract class MessageRepository {
  Future<List<ChatRoomEntity>> fetchAllMessages();
  Future<List<MessageEntity>> fetchMessages(String chatRoomId);
  Future<void> createMessage(Message message, String token);
  void subscribeToMessageUpdate(
      void Function(Map<String, dynamic>) onMEssageReceived);
  void unSubscribeFromMessageUpdates(StreamSubscription streamSubscription);
}
