import 'package:chat_app/domain/bloc/base_bloc.dart';
import 'package:chat_app/domain/event/search_event.dart';
import 'package:chat_app/domain/repositories/search_repository.dart';
import 'package:chat_app/domain/state/search_state.dart';
import 'package:chat_app/utils/app_print.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends BaseBloc<SearchEvent, SearchState> {
  SearchBloc(this.searchRepository) : super(const InitialLoadingSearch()) {
    on<SearchUserEvent>(_handleSearchUser);
  }

  void _handleSearchUser(
      SearchUserEvent event, Emitter<SearchState> emit) async {
    emit(const LoadingSearchUser());
    try {
      final result = await searchRepository.searchUser(event.query);
      emit(SuccessGetSearchUser(result));
    } catch (e, st) {
      AppPrint.debugPrint("ERROR SEARCH: $e $st");
      emit(const InitialLoadingSearch());
    }
  }

  final SearchRepository searchRepository;
}
