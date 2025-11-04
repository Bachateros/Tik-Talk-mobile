class MessegeModel { 
  final String idMessage;
  final String idChat;
  final String idUser;
  final String content;
  final MessageType typeMessage;
  String? replyToId;
  String? fileUrl;
  String? fileName;
  int? fileSize;
  String? mimeType;
  final DateTime createdAt;

  MessegeModel({
    required this.idMessage,
    required this.idChat,
    required this.idUser,
    required this.content, 
    required  this.typeMessage, 
    this.replyToId,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.mimeType,
    required this.createdAt
    });
    
  factory MessegeModel.fromJson(Map<String, dynamic> json) {
    return MessegeModel(
      idMessage: json['id'] as String,
      idChat: json['chat_id'] as String,
      idUser: json['user_id'] as String,
      content: json['content'] as String,
      typeMessage: MessageTypeExtension.fromString(json['type']),
      createdAt: DateTime.parse(json['created_at']),
      replyToId: json['reply_to_id'],
      fileUrl: json['file_url'],
      fileName: json['file_name'],
      fileSize: json['file_size'],
      mimeType: json['mime_type'],
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
enum MessageType {
  text,
  image,
  file,
  system,
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