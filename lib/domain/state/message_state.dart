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
  final List<MessageEntity> messages;

  const SuccessAllMessageState(this.messages);

  @override
  List<Object> get props => [messages];
}
