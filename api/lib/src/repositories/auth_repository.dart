import 'dart:io';

import 'package:api/src/entities/user_entity.dart';
import 'package:supabase/supabase.dart';

class AuthRepository {
  AuthRepository({required this.dbClient});
  final SupabaseClient dbClient;

  Future<User?> getCurrentUser() async {
    try {
      final user = await dbClient.auth.currentUser;
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
      final session = response.session;
      final user = response.user;

      final userEntity = UserEntity(
        id: user!.id,
        email: user.email,
        token: session!.accessToken,
        password: password,
        createdAt: DateTime.now(),
        phoneNumber: user.phone,
        expiresAt: session.expiresAt,
        expiresIn: session.expiresIn,
        refreshToken: session.refreshToken,
        userName: email.split("@")[0],
      );

      await dbClient
          .from("users")
          .update(userEntity.toJson())
          .eq("id", userEntity.id!);

      return {
        "message": null,
        "data": userEntity.toJson(),
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

  Future<Map<String, dynamic>> fetchUser({required String uid}) async {
    try {
      final response = await dbClient.from("users").select().eq("id", uid);
      if (response.isEmpty) {
        return {
          "data": null,
          "message": "Invalid Credentials",
          "status_code": HttpStatus.badRequest
        };
      }
      return {
        "data": response.first,
        "message": "Successfully Fetch User",
        "status_code": HttpStatus.ok,
      };
    } catch (e) {
      print("ERROR FETCH USER $e");
      return {
        "data": null,
        "message": "Sorry, Something Went Wrong",
        "status_code": HttpStatus.internalServerError,
      };
    }
  }
}
