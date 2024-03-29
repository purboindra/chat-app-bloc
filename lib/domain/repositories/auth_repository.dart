import 'package:chat_app/data/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signUp(String email, String password);
  Future<UserEntity?> signIn(String email, String password);
  Future<void> signOut();
  Future<void> saveIdToPrefs(String? id);
  Future<void> saveTokenToPrefs(String? token);
  Future<UserEntity?> fetchUser(String id);
  Future<String?> getIdFromPrefs(String? id);
}
