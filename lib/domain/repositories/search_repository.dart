import 'package:chat_app/data/entities/user_entity.dart';

abstract class SearchRepository {
  Future<List<UserEntity>> searchUser(String query, String? token);
}
