import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

sealed class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

final class FetchAllMessagesEvent extends MessageEvent {
  final String token;

  const FetchAllMessagesEvent(this.token);

  @override
  List<Object> get props => [token];
}

final class SubscribeMessageEvent extends MessageEvent {
  final void Function(Map<String, dynamic> p1) onMessageReceived;

  const SubscribeMessageEvent(this.onMessageReceived);

  @override
  List<Object> get props => [onMessageReceived];
}

final class FetchMessageEvent extends MessageEvent {
  final String chatRoomId;
  final String senderId;
  const FetchMessageEvent(this.chatRoomId, this.senderId);

  @override
  List<Object> get props => [chatRoomId, senderId];
}

final class SendMessageEvent extends MessageEvent {
  final Message message;
  final String token;

  const SendMessageEvent(this.message, this.token);

  @override
  List<Object> get props => [message, token];
}
