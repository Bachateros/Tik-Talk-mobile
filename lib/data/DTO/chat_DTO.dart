class ChatDTO {
  final String? id; // idChat
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

  ChatDTO copyWith({
    final String? id, // idChat
    final String? name,
    final String? description,
    final String? type, // 'direct','group','channel'
    final String? createdBy, // 'direct','group','channel'
    final String? avatarUrl,
    final int? maxMembers,
    final DateTime? lastActivityAt,
    final bool? isPrivate,
    final bool? isDeleted,
    final DateTime? createdAt ,
    final DateTime? updatedAt,
    final DateTime? deletedAt,
  }){return ChatDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      createdBy: createdBy ?? this.createdBy,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      maxMembers: maxMembers ?? this.maxMembers,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      isPrivate: isPrivate ?? this.isPrivate,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );}
}