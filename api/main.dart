import 'dart:io';

import 'package:api/src/env/env.dart';
import 'package:api/src/repositories/auth_repository.dart';
import 'package:api/src/repositories/message_repository.dart';
import 'package:api/src/repositories/search_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart';

late MessageRepository messageRepository;
late AuthRepository authRepository;
late SearchRepository searchRepository;

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  final dbClient = SupabaseClient(
      Env.SUPABASE_URL, Env.SUPABASE_SERVICE_ROLE_KEY,
      authOptions: AuthClientOptions(authFlowType: AuthFlowType.implicit));
  messageRepository = MessageRepository(dbClient: dbClient);
  authRepository = AuthRepository(dbClient: dbClient);
  searchRepository = SearchRepository(dbClient);

  return serve(handler, ip, port);
}
