class ParticipantDto {
  final String? id;
  final String userId;
  final String chatId;
  final String role;
  final bool? isMuted;
  final bool? notificationsEnabled;
  final bool? isDeleted;
  final DateTime? joinedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  ParticipantDto({
    required this.id,
    required this.userId,
    required this.chatId,
    required this.role,
    this.isMuted,
    this.notificationsEnabled,
    this.isDeleted,
    required this.joinedAt,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  ParticipantDto copyWith(
    final String? id,
    final String? userId,
    final String? chatId,
    final String? role,
    final bool? isMuted,
    final bool? notificationsEnabled,
    final bool? isDeleted,
    final DateTime? joinedAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final DateTime? deletedAt,
  ){return ParticipantDto(
      id: id?? this.id,
      userId: userId ?? this.userId,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      isMuted: isMuted ?? this.isMuted,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isDeleted: isDeleted ?? this.isDeleted,
      joinedAt: joinedAt ?? this.joinedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
  );}
}