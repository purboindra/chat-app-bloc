import 'package:equatable/equatable.dart';

sealed class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

final class FetchAllMessagesEvent extends MessageEvent {
  final String userId;

  const FetchAllMessagesEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
