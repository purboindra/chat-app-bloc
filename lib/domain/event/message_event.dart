import 'package:equatable/equatable.dart';

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
