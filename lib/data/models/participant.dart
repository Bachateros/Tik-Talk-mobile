class Participant{
  String idPartic;
  String userId;
  String chatId;
  String role;
  String joinedAt;

  Participant({
    required this.idPartic,
    required this.userId,
    required this.chatId,
    required this.role,
    required this.joinedAt,
  });

  factory Participant.fromJson(Map<String, dynamic> json){
    return Participant(
      idPartic: json['id'], 
      userId: json['user_id'], 
      chatId: json['chat_id'], 
      role: json['role'], 
      joinedAt: json['joined_at']);
  }
}