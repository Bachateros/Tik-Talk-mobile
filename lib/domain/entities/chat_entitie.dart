class ChatEntitie {
  final String idChat;
  final String nameChat;
  String? descriptionChat;
  final ChatType typeChat;
  String? avatarUrl;
  bool isPrivate;
  final DateTime createdAt;
  DateTime? updatedAt;
  String? createdBy;
  int? maxMembers;
  DateTime? lastActivityAt;

  ChatEntitie({
    required this.idChat,
    required this.nameChat,
    this.descriptionChat,
    required this.typeChat,
    this.avatarUrl,
    required this.isPrivate,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    required this.maxMembers,
    this.lastActivityAt,
    });

  ChatEntitie copyWith({
    String? idChat,
    String? nameChat,
    String? descriptionChat,
    ChatType? typeChat,
    String? avatarUrl,
    bool? isPrivate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    int? maxMembers,
    DateTime? lastActivityAt,
    }) { return ChatEntitie(
      idChat: idChat ?? this.idChat, 
      nameChat: nameChat ?? this.nameChat, 
      descriptionChat: descriptionChat ?? this.descriptionChat,
      typeChat: typeChat ?? this.typeChat,
      avatarUrl: avatarUrl ?? this.avatarUrl, 
      isPrivate: isPrivate ?? this.isPrivate, 
      createdAt: createdAt ?? this.createdAt, 
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      maxMembers: maxMembers ?? this.maxMembers,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      );
    }


}

enum ChatType{
  direct, group, channel
}