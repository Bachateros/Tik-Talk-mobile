import 'package:tik_talk/data/DTO/chat_DTO.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import '../datasources/db/app_db.dart';
import 'base_mapper.dart';

class ChatMapper implements BaseMapper<Map<String, dynamic>, ChatDTO, ChatEntitie , Chat> {
  @override
  ChatDTO fromResponse(Map<String, dynamic> json) {
    DateTime safeParse(String? value) {
      if (value == null || value.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }
    return ChatDTO(
      id: json['ID']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
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
      isDeleted: json['DeleteAt'] == null ? false :true, 
      deletedAt: DateTime.tryParse(json['DeleteAt'].toString()) ,
    );}
//     "ID"
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
  @override
  Map<String, dynamic> toResponse(ChatDTO dto) => {
        // 'id': dto.id,
        // 'title': dto.title,
        // 'type': dto.type,
        // 'last_message_id': dto.lastMessageId,
        // 'created_at': dto.createdAt.toIso8601String(),
        // 'updated_at': dto.updatedAt?.toIso8601String(),
      };

  @override
  ChatEntitie toEntity(ChatDTO dto) => ChatEntitie(
        idChat: dto.id,
        nameChat: dto.name,
        avatarUrl: dto.avatarUrl,
        descriptionChat: dto.description,
        isPrivate: dto.isPrivate,
        maxMembers: dto.maxMembers,
        typeChat: ChatTypeExtension.fromString(dto.type),
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
        lastActivityAt: dto.lastActivityAt,

      );

  @override
  ChatDTO fromEntity(ChatEntitie e) => ChatDTO(
    id: e.idChat, // idChat
    name: e.nameChat,
    description: e.descriptionChat,
    type: ChatTypeExtension.fromType(e.typeChat), // 'direct': ,'group': ,'channel'
    createdBy: e.createdBy, // 'direct': ,'group': ,'channel'
    avatarUrl: e.avatarUrl,
    maxMembers: e.maxMembers,
    lastActivityAt: e.lastActivityAt,
    isPrivate: e.isPrivate,
    isDeleted: e.isPrivate,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
    deletedAt: null,
      );
      
  @override
  ChatDTO toDTO(Chat chat) {
    return ChatDTO(
        id: chat.id,
        name: chat.name,
        description: chat.description,
        type: chat.type,
        createdBy: chat.createdBy,
        avatarUrl: chat.avatarUrl,
        maxMembers: chat.maxMembers,
        lastActivityAt: chat.lastActivityAt,
        isPrivate: chat.isPrivate,
        isDeleted: chat.isDeleted,
        createdAt: chat.createdAt,
        updatedAt: chat.updatedAt,
        deletedAt: chat.deletedAt,
      );
    
  }
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
        throw ArgumentError('Invalide type chat $value');
    }
  }
  
  static String fromType(ChatType type) {
    switch (type) {
      case ChatType.direct:
        return 'direct';
      case ChatType.group:
        return 'group';
      case ChatType.channel:
        return 'channel';
      }
  }
}