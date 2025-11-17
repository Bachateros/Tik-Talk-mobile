class ParticipantEntitie{
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String chatId;
  final String userId;
  final RoleParticipant role;
  final DateTime? joinedAt;
  final bool isMuted;
  final bool notificationsEnabled;
  
  ParticipantEntitie({
    required this.id ,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.chatId,
    required this.userId,
    required this.role,
    this.joinedAt,
    required this.isMuted,
    required this.notificationsEnabled,
  });

  ParticipantEntitie copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? chatId,
    String? userId,
    RoleParticipant? role,
    DateTime? joinedAt,
    bool? isMuted,
    bool? notificationsEnabled,
  }) { return ParticipantEntitie(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
    chatId: chatId ?? this.chatId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    joinedAt: joinedAt ?? this.joinedAt,
    isMuted: isMuted ?? this.isMuted,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );

  }
}

enum RoleParticipant{
  member,
  admin,
  owner
}