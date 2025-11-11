

  // factory ParticipantModel.fromJson(Map<String, dynamic> json) {
  //   return ParticipantModel(
  //     id: json["ID"]?.toString() ?? '',
  //     createdAt: DateTime.tryParse(json["CreatedAt"]?.toString() ?? ''),
  //     updatedAt: DateTime.tryParse(json["UpdatedAt"]?.toString() ?? ''),
  //     deletedAt: DateTime.tryParse(json["DeletedAt"]?.toString() ?? ''),
  //     chatId: json["chatId"]?.toString() ?? '',
  //     userId: json["userId"]?.toString() ?? '',
  //     role: ParticipantRoleExtension.fromString(json["role"]?.toString()),
  //     joinedAt: DateTime.tryParse(json["joinedAt"]?.toString() ?? ''),
  //     isMuted: json["isMuted"] == true || json["isMuted"] == "true",
  //     notificationsEnabled: json["notificationsEnabled"] != false && 
  //                          json["notificationsEnabled"] != "false",
  //   );