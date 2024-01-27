import 'package:chat_app/data/repositories/auth_repository_impl.dart';
import 'package:chat_app/data/repositories/home_repository.dart';
import 'package:chat_app/data/repositories/message_repository.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/repositories/message_repository.dart';
import 'package:chat_app/services/api_client.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static void setup() {
    getIt.registerLazySingleton<ApiClient>(
        () => ApiClient(tokenProvider: () async => ""));

    getIt.registerLazySingleton<MessageRepository>(
      () => MessageRepositoryImpl(
        getIt.get(),
        // webSocketClient: webSocketClient,
      ),
    );

    getIt.registerLazySingleton<HomeRepository>(
      () => HomeRepository(
        getIt.get(),
      ),
    );

    getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt.get()));
  }
}
