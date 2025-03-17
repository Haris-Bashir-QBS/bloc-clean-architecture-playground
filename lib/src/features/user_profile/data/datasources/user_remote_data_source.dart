// import 'dart:developer';
//
// import 'package:bloc_api_integration/src/features/user_profile/data/models/user_listing_model.dart';
// import 'package:bloc_api_integration/src/network/dio_client.dart';
// import 'package:bloc_api_integration/src/network/response_validator.dart';
// import '../models/user_model.dart';
//
// abstract class UserRemoteDataSource {
//   Future<UserProfileModel> fetchUser(String id);
//   Future<UserListingModel> fetchUsers(int page);
// }
//
// class UserRemoteDataSourceImpl implements UserRemoteDataSource {
//   UserRemoteDataSourceImpl();
//   @override
//   Future<UserProfileModel> fetchUser(String id) async {
//     final response = await DioClient().get(endpoint: 'users/$id');
//     final validatedResponse = ResponseValidator.validateResponse(response);
//     return UserProfileModel.fromJson(validatedResponse["data"]);
//   }
//
//   @override
//   Future<UserListingModel> fetchUsers(int page) async {
//     final response = await DioClient().get(
//       endpoint: 'users',
//       queryParams: {"page": page},
//     );
//     final validatedResponse = ResponseValidator.validateResponse(response);
//     return UserListingModel.fromJson(validatedResponse);
//   }
// }
