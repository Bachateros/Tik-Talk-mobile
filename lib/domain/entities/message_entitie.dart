class MessageEntitie {
  final String? idMessage;
  final String idChat;
  final String idUser;
  final String content;
  final MessageType? typeMessage;
  final DateTime createdAt;
  final String? replyToId;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? mimeType;
  final String? status;
  final bool isDeleted;

  MessageEntitie({
    this.idMessage,
    required this.idChat,
    required this.idUser,
    required this.content,
    this.typeMessage,
    required this.createdAt,
    this.replyToId,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.mimeType, 
    this.status,
    required this.isDeleted
  });

  MessageEntitie copyWith({
    String? idMessage,
    String? replyToId,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? mimeType,
    String? status,
    bool? isDeleted,
  }) {
    return MessageEntitie(
      idMessage: idMessage,
      idChat: idChat,
      idUser: idUser,
      content: content,
      typeMessage: typeMessage,
      createdAt: createdAt,
      replyToId: replyToId ?? this.replyToId,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      status:  status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}


enum MessageType {
  text,
  image,
  file,
  system,
}