import 'package:chat_app/data/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class InitialAuthState extends AuthenticationState {}

final class LoadingAuthState extends AuthenticationState {}

final class SuccessAuthState extends AuthenticationState {}

final class ErrorAuthState extends AuthenticationState {
  final String message;

  const ErrorAuthState(this.message);

  @override
  List<Object> get props => [message];
}

final class ResultGetUserFromPrefsState extends AuthenticationState {
  final String token;

  const ResultGetUserFromPrefsState(this.token);

  @override
  List<Object> get props => [token];
}

final class LoadingGetUserFromPrefsState extends AuthenticationState {}

final class SuccessFetchUser extends AuthenticationState {
  final UserEntity user;

  const SuccessFetchUser(this.user);

  @override
  List<Object> get props => [user];
}
