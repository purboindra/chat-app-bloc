import 'package:api/src/entities/user_entity.dart';
import 'package:supabase/supabase.dart';

class AuthRepository {
  AuthRepository({required this.dbClient});
  final SupabaseClient dbClient;

  Future<User?> getCurrentUser() async {
    print("CALLEDD");
    try {
      final user = await dbClient.auth.currentUser;
      print("CURRENT USER $user");
      if (user != null) {
        return user;
      }
      return null;
    } catch (e) {
      print('ERROR GET CURRENT USER $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> signUp(
      {required String email, required String password}) async {
    try {
      final response =
          await dbClient.auth.signUp(password: password, email: email);
      print("EMAIL: $email PASSWORD: $password");
      if (response.user == null) {
        throw Exception("Invalid Credentials");
      }
      final user = UserEntity(
        avatarUrl: "",
        id: response.user!.id,
        email: response.user!.email,
        password: password,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        phoneNumber: response.user!.phone,
        userName: "",
      );
      print("USER ${user.toJson()}");
      await dbClient.from("users").insert({
        "id": response.user!.id,
        "email": email,
        "password": password,
        "created_at": DateTime.now().toUtc().toIso8601String(),
        "updated_at": DateTime.now().toUtc().toIso8601String(),
      });
      return {
        "message": null,
        "data": user.toJson(),
      };
    } catch (e) {
      print("ERROR SIGN UP $e");
      return {
        "message": e.toString(),
        "data": null,
      };
    }
  }

  Future<void> singIn({required String email, required String password}) async {
    try {
      await dbClient.auth.signInWithPassword(password: password, email: email);
    } catch (e) {
      print("ERROR SIGN IN $e");
      return null;
    }
  }
}
