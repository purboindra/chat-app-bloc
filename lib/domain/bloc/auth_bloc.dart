import 'package:chat_app/domain/bloc/base_bloc.dart';
import 'package:chat_app/domain/event/auth_event.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/state/auth_state.dart';
import 'package:chat_app/utils/app_print.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends BaseBloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this.authRepository) : super(InitialAuthState()) {
    on<SignUpEvent>(_handleSignUp);
    on<SignInEvent>(_handleSignIn);
    on<GetUserFromPrefsEvent>(_handleGetUserFromPrefs);
    on<FetchUserEvent>(_handleFetchUSer);
  }

  void _handleFetchUSer(
      FetchUserEvent event, Emitter<AuthenticationState> emit) async {
    try {
      final response = await authRepository.fetchUser(event.id);
      AppPrint.debugPrint("fetch user ${response?.toJson()}");
      emit(SuccessFetchUser(response!));
    } catch (e) {
      AppPrint.debugPrint("ERROR FETCH USER BLOC $e");
    }
  }

  void _handleGetUserFromPrefs(
      GetUserFromPrefsEvent event, Emitter<AuthenticationState> emit) async {
    emit(LoadingGetUserFromPrefsState());
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getString("user_id") ?? "";
    AppPrint.debugPrint("current user $result");
    emit(ResultGetUserFromPrefsState(result));
  }

  void _handleSignUp(
      SignUpEvent event, Emitter<AuthenticationState> emit) async {
    emit(LoadingAuthState());
    try {
      final response = await authRepository.signUp(event.email, event.password);
      if (response == null) {
        throw Exception("Maaf, terjadi kesalahan...");
      }

      await authRepository.saveIdToPrefs(response.id);
      await authRepository.saveTokenToPrefs(response.token);
      emit(SuccessAuthState());
    } catch (e, st) {
      AppPrint.debugPrint("ERROR FROM SIGN IN EVENT $e $st");
      emit(ErrorAuthState(e.toString()));
    }
  }

  void _handleSignIn(
      SignInEvent event, Emitter<AuthenticationState> emit) async {
    emit(LoadingAuthState());
    try {
      final response = await authRepository.signIn(event.email, event.password);
      if (response == null) {
        throw Exception("Maaf, terjadi kesalahan...");
      }
      await authRepository.saveIdToPrefs(response.id);
      await authRepository.saveTokenToPrefs(response.token ?? "");
      emit(SuccessAuthState());
    } catch (e, st) {
      AppPrint.debugPrint("ERROR FROM SIGN IN EVENT $e $st");
      emit(ErrorAuthState(e.toString()));
    }
  }

  final AuthRepository authRepository;
}
