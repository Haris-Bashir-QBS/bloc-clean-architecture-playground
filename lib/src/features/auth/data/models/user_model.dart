import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required String id, required String email, required String name})
    : super(id: id, email: email, name: name);

  /// Convert JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userMetadata = json['user_metadata'] as Map<String, dynamic>?;
    return UserModel(
      id: json['id'] as String,
      email:
          userMetadata?['email'] as String? ?? json['email'] as String? ?? '',
      name: userMetadata?['name'] as String? ?? '',
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name};
  }

  UserModel copyWith({String? email, String? id, String? name}) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}
