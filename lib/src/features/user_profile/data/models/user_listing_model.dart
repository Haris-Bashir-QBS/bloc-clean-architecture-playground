import 'package:bloc_api_integration/src/features/user_profile/data/models/user_model.dart';
import 'package:bloc_api_integration/src/features/user_profile/domain/entities/user_listing.dart';

class UserListingModel extends UserListingEntity {
  UserListingModel({
    required super.page,
    required super.perPage,
    required super.total,
    required super.totalPages,
    required List<UserModel>? super.users,
  });

  factory UserListingModel.fromJson(Map<String, dynamic> json) {
    return UserListingModel(
      page: json['page'] as int? ?? 0,
      perPage: json['per_page'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 0,
      users: (json['data'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'per_page': perPage,
      'total': total,
      'total_pages': totalPages,
      'data': users?.map((e) => (e as UserModel).toJson()).toList(),
    };
  }
  UserListingModel copyWith({
    int? page,
    int? perPage,
    int? total,
    int? totalPages,
    List<UserModel>? users,
  }) {
    return UserListingModel(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      users: users ?? this.users?.map((user) => user as UserModel).toList(),
    );
  }
}

class Support {
  final String url;
  final String text;

  Support({
    required this.url,
    required this.text,
  });

  factory Support.fromJson(Map<String, dynamic> json) {
    return Support(
      url: json['url'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'text': text,
    };
  }
}
