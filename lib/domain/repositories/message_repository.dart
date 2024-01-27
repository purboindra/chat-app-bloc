import 'package:chat_app/data/entities/message_entity.dart';

abstract class MessageRepository {
  Future<List<MessageEntity>> fetchAllMessages();
}
