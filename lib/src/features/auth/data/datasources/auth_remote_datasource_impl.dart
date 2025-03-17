import 'package:bloc_api_integration/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bloc_api_integration/src/features/auth/data/models/user_model.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

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
      if (response.user == null) {
        throw ServerException(message: "User is null ");
      }
      return UserModel(
        id: response.user?.id ?? "",
        email: response.user?.email ?? "",
        name: response.user?.appMetadata["name"] ?? "",
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement signInWithEmailPassword
    throw UnimplementedError();
  }
}
