class ChatDTO {
  final String id; // idChat
  final String name;
  final String? description;
  final String type; // 'direct','group','channel'
  final String? createdBy; // 'direct','group','channel'
  final String? avatarUrl;
  final int? maxMembers;
  final DateTime? lastActivityAt;
  final bool isPrivate;
  final bool isDeleted;
  final DateTime createdAt ;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  ChatDTO({
    required this.id, // idChat
    required this.name,
    this.description,
    required this.type, // 'direct','group','channel'
    this.createdBy, // 'direct','group','channel'
    this.avatarUrl,
    this.maxMembers,
    this.lastActivityAt,
    required this.isPrivate,
    required this.isDeleted,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
}