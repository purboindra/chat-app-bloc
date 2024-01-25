import 'package:api/src/repositories/auth_repository.dart';
import 'package:api/src/repositories/message_repository.dart';
import 'package:dart_frog/dart_frog.dart';

import '../main.dart';

Handler middleware(Handler handler) {
  return handler
      .use(provider<MessageRepository>((_) => messageRepository))
      .use(provider<AuthRepository>((_) => authRepository));
  //   .use(
  // basicAuthentication<User>(
  //   authenticator: (context, username, password) {
  //     final authRepository = context.read<AuthRepository>();
  //     print("MIDDLEWARE $username $password");
  //     return authRepository.getCurrentUser();
  //   },
  // ),
  // );
}
