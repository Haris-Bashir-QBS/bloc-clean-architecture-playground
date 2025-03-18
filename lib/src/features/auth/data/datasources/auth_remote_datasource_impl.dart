import 'dart:developer';

import 'package:bloc_api_integration/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bloc_api_integration/src/features/auth/data/models/user_model.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        //  [{...},{...}]

        final List<Map<String, dynamic>> userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(
          userData.first,
        ).copyWith(email: currentUserSession!.user.email);
      } else {
        return null;
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      log("Response is ${response.user?.toJson()}");
      if (response.user == null) {
        throw ServerException(message: "User is null ");
      }
      return UserModel.fromJson(
        response.user!.toJson(),
      ).copyWith(email: currentUserSession?.user.email);
    } on AuthException catch (e) {
      log("Error is ${e.message}");
      throw ServerException(message: e.message);
    } catch (e) {
      log("Error is ${e.toString()}");
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await supabaseClient.auth
          .signInWithPassword(email: email, password: password);
      log("Response is ${response.user?.toJson()}");
      if (response.user == null) {
        throw ServerException(message: "User is null ");
      }
      return UserModel.fromJson(
        response.user!.toJson(),
      ).copyWith(email: currentUserSession?.user.email);
    } on AuthException catch (e) {
      log("Error is ${e.message}");
      throw ServerException(message: e.message);
    } catch (e) {
      log("Error is ${e.toString()}");
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await supabaseClient.auth.signOut();
      return true;
    } on AuthException catch (e) {
      log("Error is ${e.message}");
      throw ServerException(message: e.message);
    } catch (e) {
      log("Error is ${e.toString()}");
      throw ServerException(message: e.toString());
    }
  }
}
