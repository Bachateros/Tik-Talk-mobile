import 'package:tik_talk/domain/entities/message_entitie.dart';
import 'package:tik_talk/data/DTO/messege_DTO.dart';
import 'base_mapper.dart';

class MessageMapper
    implements BaseMapper<Map<String, dynamic>, MessageDTO, MessageEntitie> {
  @override
  MessageDTO fromResponse(Map<String, dynamic> json) => MessageDTO(
//     "CreatedAt" 
// "UpdatedAt" 
// "DeletedAt"
// "chatId"
// "userId"
// "type"
// "content"
// "status" 
// "clientId"
      id: json['ID']?.toString() ?? '',
      chatId: json['chatId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      fileUrl: json['file_url']?.toString() ?? '',
      fileName: json['file_name']?.toString() ?? '',
      fileSize: json['file_size'] != null ? int.parse(json['file_size']) : null,
      mimeType: json['mime_type']?.toString() ?? '',
      replyToId: json['reply_to_id']?.toString() ?? '',
      status: json['status'] ?? '',
      isDeleted: json['DeletedAt'] != null ? true : false,
      clientId: json['clientId'] ?? '',
      createdAt: DateTime.tryParse(json['CreatedAt'] ?? '') ?? DateTime.now(),
      updatedAt:
          json['UpdatedAt'] != null ? DateTime.tryParse(json['UpdatedAt']) : null,
      deletedAt:
          json['DeletedAt'] != null ? DateTime.tryParse(json['DeletedAt']) : null,
    );

  @override
  Map<String, dynamic> toResponse(MessageDTO dto) => {
        'id': dto.id,
        'chat_id': dto.chatId,
        'user_id': dto.userId,
        'content': dto.content,
        'type': dto.type,
        'file_url': dto.fileUrl,
        'file_name': dto.fileName,
        'file_size': dto.fileSize,
        'mime_type': dto.mimeType,
        'reply_to_id': dto.replyToId,
        'is_deleted': dto.isDeleted,
        'created_at': dto.createdAt.toIso8601String(),
        'updated_at': dto.updatedAt?.toIso8601String(),
        'deleted_at': dto.deletedAt?.toIso8601String(),
      };

  @override
  MessageEntitie toEntity(MessageDTO dto) => MessageEntitie(
        idMessage: dto.id,
        idChat: dto.chatId,
        idUser: dto.userId,
        content: dto.content,
        typeMessage: MessageTypeExtension.fromString(dto.type),
        fileUrl: dto.fileUrl,
        fileName: dto.fileName,
        fileSize: dto.fileSize,
        mimeType: dto.mimeType,
        replyToId: dto.replyToId,
        createdAt: dto.createdAt,
        isDeleted: dto.isDeleted,
      );

  @override
  MessageDTO fromEntity(MessageEntitie e) => MessageDTO(
        id: e.idMessage ?? '',
        chatId: e.idChat,
        userId: e.idUser,
        content: e.content,
        type: MessageTypeExtension.fromType(e.typeMessage),
        fileUrl: e.fileUrl,
        fileName: e.fileName,
        fileSize: e.fileSize,
        mimeType: e.mimeType,
        replyToId: e.replyToId,
        createdAt: e.createdAt, 
        isDeleted: e.isDeleted,
      );

}

extension MessageTypeExtension on MessageType {
  static MessageType fromString(String? value) {
    switch (value) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'file':
        return MessageType.file;
      case 'system':
        return MessageType.system;
      default:
        throw ArgumentError('Unknown message type: $value');
    }
  }

  static String fromType (MessageType? type){
    switch (type) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.file:
        return'file';
      case MessageType.system:
        return 'system';
      default:
        throw ArgumentError('Unknown message type: $type');
    }
  }
}

