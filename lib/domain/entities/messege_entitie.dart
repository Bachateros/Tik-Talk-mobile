class MessegeEntitie {
  final String idMessege;
  final String idChat;
  final String idUser;
  final String content;
  final MessegeType typeMessage;
  final DateTime createdAt;

  final String? replyToId;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? mimeType;

  const MessegeEntitie({
    required this.idMessege,
    required this.idChat,
    required this.idUser,
    required this.content,
    required this.typeMessage,
    required this.createdAt,
    this.replyToId,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.mimeType, 
  });

  MessegeEntitie copyWith({
    String? replyToId,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? mimeType,
  }) {
    return MessegeEntitie(
      idMessege: idMessege,
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
    );
  }
}


enum MessegeType {
  text,
  image,
  file,
  system,
}