import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required String id, required String email, required String name})
    : super(id: id, email: email, name: name);

  /// Convert JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name};
  }
}
