import 'package:chat_app/domain/bloc/base_bloc.dart';
import 'package:chat_app/domain/event/message_event.dart';
import 'package:chat_app/domain/repositories/message_repository.dart';
import 'package:chat_app/domain/state/message_state.dart';
import 'package:chat_app/utils/app_print.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends BaseBloc<MessageEvent, MessageState> {
  MessageBloc(this.messageRepository) : super(InitialMessageState()) {
    on<FetchAllMessagesEvent>(_handleFetchAllMessages);
    on<FetchMessageEvent>(_handleFetchMessage);
    on<SendMessageEvent>(_handleSendMessage);
    on<SubscribeMessageEvent>(_handleSubscribeMessage);
    on<UpdateMessagesEvent>(_handleUpdateMessage);
  }

  void _handleSubscribeMessage(
      SubscribeMessageEvent event, Emitter<MessageState> emit) async {
    try {
      messageRepository.subscribeToMessageUpdate((p0) {
        AppPrint.debugPrint('P0 $p0');
        event.onMessageReceived(p0);
      });
    } catch (e) {
      AppPrint.debugPrint("ERRORRR $e");
    }
  }

  void _handleUpdateMessage(
      UpdateMessagesEvent event, Emitter<MessageState> emit) async {
    emit(SuccessFetchMessage(event.messages));
  }

  void _handleSendMessage(
      SendMessageEvent event, Emitter<MessageState> emit) async {
    try {
      await messageRepository.createMessage(event.message, event.token);
      // emit(SuccessSendMessage());
    } catch (e, st) {
      AppPrint.debugPrint("ERROR SEND MESSAGE $e $st");
      // emit(e());
    }
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

  void _handleFetchMessage(
      FetchMessageEvent event, Emitter<MessageState> emit) async {
    emit(LoadingFetchMessage());
    try {
      final response = await messageRepository.fetchMessages(
          event.chatRoomId, event.senderId);
      emit(SuccessFetchMessage(response));
    } catch (e, st) {
      AppPrint.debugPrint("ERROR FETCH MESSAGE $e $st");
      emit(ErrorAllMessageState(e.toString()));
    }
  }

  final MessageRepository messageRepository;
}
