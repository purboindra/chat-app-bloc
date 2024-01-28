import 'package:chat_app/data/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/services/api_client.dart';
import 'package:chat_app/utils/app_print.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  const AuthRepositoryImpl(this.apiClient);

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    final response = await apiClient.signIn(email, password);
    return response;
  }

  @override
  Future<UserEntity?> signUp(String email, String password) async {
    final response = await apiClient.signUp(email, password);
    return response;
  }

  @override
  Future<void> saveIdToPrefs(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = await prefs.setString("user_id", id ?? "");
    AppPrint.debugPrint("USER ID $userId $id");
  }

  @override
  Future<String?> getIdFromPrefs(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString("user_id");
    if (user != null) return user;
    return null;
  }

  @override
  Future<void> saveTokenToPrefs(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token ?? "");
    AppPrint.debugPrint("TOKEN $token");
  }
}
