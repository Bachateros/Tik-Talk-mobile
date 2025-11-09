import 'package:tik_talk/domain/entities/message_entitie.dart';

class MessageModel extends MessageEntitie{ 
// "ID" 
// "CreatedAt" 
// "UpdatedAt" 
// "DeletedAt" 
// "chatId" 
// "userId"
// "type"
// "content"
// "status"
// "clientId"
  MessageModel({
    String? idMessage,
    required String idChat,
    required String idUser,
    required String content, 
    required MessageType typeMessage,
    String? replyToId,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? mimeType,
    required DateTime createdAt,
    }) : super(
      idMessage: idMessage,
      idChat: idChat,
      idUser: idUser,
      content: content,
      typeMessage: typeMessage,
      replyToId: replyToId,
      fileUrl: fileUrl,
      fileName: fileName,
      fileSize: fileSize,
      mimeType: mimeType,
      createdAt: createdAt
      );
    
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      idMessage: json['ID']?.toString() ?? '',
      idChat: json['chatId']?.toString() ?? '',
      idUser: json['userId']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      typeMessage: MessageTypeExtension.fromString(json['type']),
      createdAt: DateTime.parse(json['CreatedAt'] ?? "0"),
      replyToId: json['reply_to_id']?.toString() ?? '',
      fileUrl: json['file_url']?.toString() ?? '',
      fileName: json['file_name']?.toString() ?? '',
      fileSize: json['file_size'] != null ? int.parse(json['file_size']) : null,
      mimeType: json['mime_type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': idMessage,
    'user_id': idChat,
    'idUser': idUser,
    'content': content,
    'type': typeMessage.name,
    'created_at': createdAt.toIso8601String(),
    'reply_to_id': replyToId,
    'file_url': fileUrl,
    'file_name': fileName,
    'file_size': fileSize,
    'mime_type': mimeType,
  };
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
}