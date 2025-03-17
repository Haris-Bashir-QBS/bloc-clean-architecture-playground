// No dependencies on external frameworks (Hint: No From and To json methods ) Raw Model

class UserProfileEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;

  const UserProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatar,
  });
}
