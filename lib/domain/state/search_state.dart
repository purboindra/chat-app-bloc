import 'package:chat_app/data/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class InitialLoadingSearch extends SearchState {
  const InitialLoadingSearch();
}

final class LoadingSearchUser extends SearchState {
  const LoadingSearchUser();
}

final class SuccessGetSearchUser extends SearchState {
  final List<UserEntity> users;

  const SuccessGetSearchUser(this.users);

  @override
  List<Object> get props => [users];
}
