import 'package:tik_talk/domain/entities/participant_entitie.dart';

class ParticipantModel extends ParticipantEntitie {
  ParticipantModel({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    required String chatId,
    required String userId,
    required RoleParticipant role,
    DateTime? joinedAt,
    required bool isMuted,
    required bool notificationsEnabled,
  }) : super(
          id: id ?? '',
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
          chatId: chatId,
          userId: userId,
          role: role,
          joinedAt: joinedAt,
          isMuted: isMuted,
          notificationsEnabled: notificationsEnabled,
        );

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json["ID"]?.toString() ?? '',
      createdAt: DateTime.tryParse(json["CreatedAt"]?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json["UpdatedAt"]?.toString() ?? ''),
      deletedAt: DateTime.tryParse(json["DeletedAt"]?.toString() ?? ''),
      chatId: json["chatId"]?.toString() ?? '',
      userId: json["userId"]?.toString() ?? '',
      role: ParticipantRoleExtension.fromString(json["role"]?.toString()),
      joinedAt: DateTime.tryParse(json["joinedAt"]?.toString() ?? ''),
      isMuted: json["isMuted"] == true || json["isMuted"] == "true",
      notificationsEnabled: json["notificationsEnabled"] != false && 
                           json["notificationsEnabled"] != "false",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "CreatedAt": createdAt?.toIso8601String(),
      "UpdatedAt": updatedAt?.toIso8601String(),
      "DeletedAt": deletedAt?.toIso8601String(),
      "chatId": chatId,
      "userId": userId,
      "role": ParticipantRoleExtension.toJsonString(role),
      "joinedAt": joinedAt?.toIso8601String(),
      "isMuted": isMuted,
      "notificationsEnabled": notificationsEnabled,
    };
  }
}
extension ParticipantRoleExtension on RoleParticipant {
  static RoleParticipant fromString(String? value) {
    switch (value) {
      case 'admin':
        return RoleParticipant.admin;
      case 'member':
        return RoleParticipant.member;
      case 'owner':
        return RoleParticipant.owner;
      default:
        throw ArgumentError('Unknown message type(role participiant): $value');
    }
  }

  static String toJsonString(RoleParticipant role) {  // ← исправлен возвращаемый тип
    switch (role) {
      case RoleParticipant.admin:
        return 'admin';
      case RoleParticipant.member:
        return 'member';
      case RoleParticipant.owner:
        return 'owner';
    }
  }
}