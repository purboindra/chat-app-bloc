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

final class FetchMessageEvent extends MessageEvent {
  final String chatRoomId;
  const FetchMessageEvent(this.chatRoomId);

  @override
  List<Object> get props => [chatRoomId];
}

final class SendMessageEvent extends MessageEvent {
  final Message message;
  final String token;

  const SendMessageEvent(this.message, this.token);

  @override
  List<Object> get props => [message, token];
}
