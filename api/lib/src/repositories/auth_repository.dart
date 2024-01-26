import 'dart:io';

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
      final response = await dbClient.auth.signUp(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw Exception("Invalid Credentials");
      }
      final user = UserEntity(
        id: response.user!.id,
        email: response.user!.email,
        password: password,
        createdAt: DateTime.now(),
        phoneNumber: response.user!.phone,
        userName: email.split("@")[0],
      );
      await dbClient
          .from("users")
          .update(user.toJson())
          .eq("id", response.user!.id);
      return {
        "message": null,
        "data": user.toJson(),
      };
    } catch (e, st) {
      print("ERROR SIGN UP $e $st");
      return {
        "message": e.toString(),
        "data": null,
      };
    }
  }

  Future<Map<String, dynamic>> singIn(
      {required String email, required String password}) async {
    try {
      final response = await dbClient.auth
          .signInWithPassword(password: password, email: email);
      if (response.session == null) {
        return {
          "data": null,
          "message": "Invalid Credentials",
          "status_code": HttpStatus.badRequest
        };
      }
      final userData = await dbClient
          .from("users")
          .select()
          .eq("id", response.session!.user.id);
      return {
        "data": userData[0],
        "message": "Successfully Sign In",
        "status_code": HttpStatus.ok,
      };
    } catch (e) {
      print("ERROR SIGN IN $e");
      return {
        "data": null,
        "message": "Sorry, Something Went Wrong",
        "status_code": HttpStatus.internalServerError,
      };
    }
  }
}
