class MessageDTO {
  final String? id;
  final String chatId;
  final String userId;
  final String content;
  final String? clientId;
  final String? status;
  final String? type;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? mimeType;
  final String? replyToId;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  MessageDTO({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.content,
    this.clientId,
    this.status,
    this.type,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.mimeType,
    this.replyToId,
    required this.isDeleted,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
}
