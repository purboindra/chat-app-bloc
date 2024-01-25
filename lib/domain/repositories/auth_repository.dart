import 'package:chat_app/data/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signUp(String email, String password);
  Future<UserEntity?> signIn(String email, String password);
  Future<void> saveId(String? id);
}
