import 'package:equatable/equatable.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchUserEvent extends SearchEvent {
  final String query;

  const SearchUserEvent(this.query);

  @override
  List<Object> get props => [query];
}
