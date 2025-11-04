class ParticipantEntitie{
  final String idPartic;
  final String userId;
  final String chatId;
  String role;
  String joinedAt;

  ParticipantEntitie({
    required this.idPartic,
    required this.userId,
    required this.chatId,
    required this.role,
    required this.joinedAt,
  });

  ParticipantEntitie copyWith({
    String? idPartic,
    String? userId,
    String? chatId,
    String? role,
    String? joinedAt,
  }) { return ParticipantEntitie(
    idPartic: idPartic ?? this.idPartic, 
    userId: userId ?? this.userId, 
    chatId: chatId ?? this.chatId, 
    role: role ?? this.role, 
    joinedAt: joinedAt ?? this.joinedAt
    );

  }
}