import 'package:equatable/equatable.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class SignUpEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const SignUpEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

final class SignInEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const SignInEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

final class SaveId extends AuthenticationEvent {
  final String? id;

  const SaveId(this.id);

  @override
  List<Object> get props => [];
}

final class GetUserFromPrefsEvent extends AuthenticationEvent {}
