import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';

class ChatModel extends ChatEntitie {
// "ID"
// "CreatedAt" 
// "UpdatedAt"
// "DeletedAt"
// "name"
// "description"
// "type"
// "createdBy"
// "isPrivate"
// "maxMembers"
// "lastActivityAt"
  ChatModel({
    required String idChat,
    required String nameChat,
    String? descriptionChat,
    required ChatType typeChat,
    String? avatarUrl,
    required bool isPrivate,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    int? maxMembers,
    DateTime? lastActivityAt,
  }) : super(
          idChat: idChat,
          nameChat: nameChat,
          descriptionChat: descriptionChat,
          typeChat: typeChat,
          avatarUrl: avatarUrl,
          isPrivate: isPrivate,
          createdAt: createdAt,
          updatedAt: updatedAt,
          createdBy: createdBy,
          maxMembers: maxMembers,
          lastActivityAt: lastActivityAt,
        );

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    DateTime safeParse(String? value) {
      if (value == null || value.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }

    return ChatModel(
      idChat: json['ID']?.toString() ?? '',
      nameChat: json['name']?.toString() ?? '',
      descriptionChat: json['description']?.toString(),
      typeChat: ChatTypeExtension.fromString(json['type']),
      avatarUrl: json['avatarUrl']?.toString(),
      isPrivate: json['isPrivate'] ?? false,
      createdAt: safeParse(json['CreatedAt']),
      updatedAt: safeParse(json['UpdatedAt']),
      createdBy: json['createdBy']?.toString(),
      maxMembers: json['maxMembers'] is int
          ? json['maxMembers']
          : int.tryParse(json['maxMembers']?.toString() ?? '0'),
       lastActivityAt: (json['lastActivityAt'] != null)
          ? safeParse(json['lastActivityAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': idChat,
        'name': nameChat,
        'description': descriptionChat,
        'type': typeChat.name,
        'avatarUrl': avatarUrl,
        'is_private': isPrivate,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'created_by': createdBy,
        'max_members': maxMembers,
        'last_activity_at': lastActivityAt?.toIso8601String(),
      };
}

extension ChatTypeExtension on ChatType {
  static ChatType fromString(String? value) {
    switch (value) {
      case 'direct':
        return ChatType.direct;
      case 'group':
        return ChatType.group;
      case 'channel':
        return ChatType.channel;
      default:
        return ChatType.direct;
    }
  }
}