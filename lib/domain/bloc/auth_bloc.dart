import 'package:chat_app/domain/bloc/base_bloc.dart';
import 'package:chat_app/domain/event/auth_event.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/state/auth_state.dart';
import 'package:chat_app/utils/app_print.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc
    extends BaseBloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this.authRepository) : super(InitialAuthState()) {
    on<SignUpEvent>(_handleSignIn);
  }

  void _handleSignIn(
      SignUpEvent event, Emitter<AuthenticationState> emit) async {
    emit(LoadingAuthState());
    try {
      final response = await authRepository.signUp(event.email, event.password);
      if (response == null) {
        throw Exception("Maaf, terjadi kesalahan...");
      }
      await authRepository.saveId(response.id ?? "");
      emit(SuccessAuthState());
    } catch (e, st) {
      AppPrint.debugPrint("ERROR FROM SIGN IN EVENT $e $st");
      emit(ErrorAuthState(e.toString()));
    }
  }

  final AuthRepository authRepository;
}
