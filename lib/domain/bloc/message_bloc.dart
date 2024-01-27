import 'package:chat_app/domain/bloc/base_bloc.dart';
import 'package:chat_app/domain/event/message_event.dart';
import 'package:chat_app/domain/repositories/message_repository.dart';
import 'package:chat_app/domain/state/message_state.dart';
import 'package:chat_app/utils/app_print.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends BaseBloc<MessageEvent, MessageState> {
  MessageBloc(this.messageRepository) : super(InitialMessageState()) {
    on<FetchAllMessagesEvent>(_handleFetchAllMessages);
  }

  void _handleFetchAllMessages(
      FetchAllMessagesEvent event, Emitter<MessageState> emit) async {
    emit(LoadingAllMessageState());
    try {
      final response = await messageRepository.fetchAllMessages();
      emit(SuccessAllMessageState(response));
    } catch (e, st) {
      AppPrint.debugPrint("ERROR FETCH ALL MESSAGES $e $st");
      emit(ErrorAllMessageState(e.toString()));
    }
  }

  final MessageRepository messageRepository;
}
