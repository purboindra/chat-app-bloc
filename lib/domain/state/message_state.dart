import 'package:chat_app/data/entities/chat_room_entity.dart';
import 'package:chat_app/data/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

sealed class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class InitialMessageState extends MessageState {}

class LoadingAllMessageState extends MessageState {}

class ErrorAllMessageState extends MessageState {
  final String errorMessage;

  const ErrorAllMessageState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class SuccessAllMessageState extends MessageState {
  final List<ChatRoomEntity> messages;

  const SuccessAllMessageState(this.messages);

  @override
  List<Object> get props => [messages];
}

final class LoadingFetchMessage extends MessageState {}

final class SuccessFetchMessage extends MessageState {
  final List<MessageEntity> message;

  const SuccessFetchMessage(this.message);

  @override
  List<Object> get props => [message];
}

final class SuccessAddMessageState extends MessageState {}

final class LoadingAddMessageState extends MessageState {}
