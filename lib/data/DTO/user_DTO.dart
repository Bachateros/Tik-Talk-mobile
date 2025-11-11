class UserDTO {
  final String id;
  final String name;
  final String surname;
  final String tgname;
  final DateTime? dateOfBirth;
  final String? bio;
  final String? avatarUrl;
  final bool isDeleted;
  final DateTime? createdAt;//DateTime.now())();
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  UserDTO({
    required this.id,
    required this.name,
    required this.surname,
    required this.tgname,
    this.dateOfBirth,
    this.bio,
    this.avatarUrl,
    this.isDeleted = false,
    required this.createdAt,
    required this.deletedAt,
    required this.updatedAt,
  });
}
