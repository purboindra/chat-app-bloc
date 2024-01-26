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
  final String id;

  const ResultGetUserFromPrefsState(this.id);

  @override
  List<Object> get props => [id];
}

final class LoadingGetUserFromPrefsState extends AuthenticationState {}
