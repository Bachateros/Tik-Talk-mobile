import 'package:tik_talk/data/DTO/participant_DTO.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'base_mapper.dart';

class ParticipantMapper
    implements BaseMapper<Map<String, dynamic>, ParticipantDto, ParticipantEntitie> {
  @override
  ParticipantDto fromResponse(Map<String, dynamic> json) => ParticipantDto(
//     "ID"
// "CreatedAt"
// "UpdatedAt"
// "DeletedAt"
// "chatId"
// "userId"
// "role" 
// "joinedAt"
// "isMuted" 
// "notificationsEnabled" 

        id: json['ID']?.toString() ?? '',
        chatId: json['chatId']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        role: json["role"].toString(),
        joinedAt: DateTime.tryParse(json['joinedAt'] ?? '') ?? DateTime.now(),
        isMuted: json['isMuted'] == true || json['isMuted'] == "true",
        notificationsEnabled: json['notifications_enabled'] != false &&
            json['notifications_enabled'] != "false",
        createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        isDeleted: json['deleted_at'] != null ? true : false,
        updatedAt:
            json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
        deletedAt:
            json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      );

  @override
  Map<String, dynamic> toResponse(ParticipantDto dto) => {
        // 'id': dto.id,
        // 'chat_id': dto.chatId,
        // 'user_id': dto.userId,
        // 'role': dto.role,
        // 'joined_at': dto.joinedAt.toIso8601String(),
        // 'is_muted': dto.isMuted,
        // 'notifications_enabled': dto.notificationsEnabled,
        // 'created_at': dto.createdAt.toIso8601String(),
        // 'updated_at': dto.updatedAt?.toIso8601String(),
        // 'deleted_at': dto.deletedAt?.toIso8601String(),
      };

  @override
  ParticipantEntitie toEntity(ParticipantDto dto) => ParticipantEntitie(
        id: dto.id,
        chatId: dto.chatId,
        userId: dto.userId,
        role: ParticipantRoleExtension.fromString(dto.role),
        joinedAt: dto.joinedAt,
        isMuted: dto.isMuted ?? false,
        notificationsEnabled: dto.notificationsEnabled ?? false,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
        deletedAt: dto.deletedAt,
      );

  @override
  ParticipantDto fromEntity(ParticipantEntitie e) => ParticipantDto(
        id: e.id,
        chatId: e.chatId,
        userId: e.userId,
        role: ParticipantRoleExtension.fromType(e.role),
        joinedAt: e.joinedAt,
        isMuted: e.isMuted,
        notificationsEnabled: e.notificationsEnabled,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
        deletedAt: e.deletedAt,
      );
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

  static String fromType(RoleParticipant role) {  // ← исправлен возвращаемый тип
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