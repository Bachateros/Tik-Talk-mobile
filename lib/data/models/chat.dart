class Chat {
  final String idChat;
  final String nameChat;
  String? descriptionChat;
  final ChatType typeChat ;
  String? avatarUrl;
  bool isPrivate;
  final DateTime createdAt;
  DateTime updatedAt;
  
  Chat({
    required this.idChat,
    required this.nameChat,
    this.descriptionChat,
    required this.typeChat,
    this.avatarUrl,
    required this.isPrivate,
    required this.createdAt,
    required this.updatedAt
    });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      idChat: json['id'],
      nameChat: json['name'],
      descriptionChat: json['description'],
      typeChat: ChatTypeExtension.fromString(json['type']),
      avatarUrl: json['avatarUrl'],
      isPrivate: json['is_private'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String,dynamic> toJson() => {
      'id': idChat,
      'name': nameChat,
      'description': descriptionChat,
      'type': typeChat.toString(),
      'avatarUrl': avatarUrl,
      'is_private': isPrivate,
      'created_at': createdAt,
      'updated_at': updatedAt,
  };

}
enum ChatType{
  direct, group, channel
}

extension ChatTypeExtension on ChatType {
  static ChatType fromString(String? value) {
    switch (value) {
      case 'text':
        return ChatType.direct;
      case 'image':
        return ChatType.group;
      case 'file':
        return ChatType.channel;
      default:
        throw ArgumentError('Unknown message type: $value');
    }
  }
}