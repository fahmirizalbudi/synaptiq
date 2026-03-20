import 'package:synaptiq/core/utils/json_utils.dart';

import '../../domain/entities/thread_entity.dart';

class ThreadDto {
  final String id;
  final String userId;
  final String title;
  final String status;
  final String? modelHint;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastUserTurnAt;
  final int messageCount;
  final List<ThreadParticipantDto> participants;

  const ThreadDto({
    required this.id,
    required this.userId,
    required this.title,
    required this.status,
    this.modelHint,
    required this.createdAt,
    required this.updatedAt,
    this.lastUserTurnAt,
    this.messageCount = 0,
    this.participants = const [],
  });

  factory ThreadDto.fromJson(
    Map<String, dynamic> json,
    String id,
    String userId,
  ) {
    return ThreadDto(
      id: id,
      userId: userId,
      title: json['title'] as String,
      status: json['status'] as String? ?? 'active',
      modelHint: json['modelHint'] as String?,
      createdAt:
          JsonUtils.parseDateTime(json['createdAt']) ?? DateTime.now().toUtc(),
      updatedAt:
          JsonUtils.parseDateTime(json['updatedAt']) ?? DateTime.now().toUtc(),
      lastUserTurnAt: JsonUtils.parseDateTime(json['lastUserTurnAt']),
      messageCount: json['messageCount'] as int? ?? 0,
      participants: (json['participants'] as List<dynamic>? ?? const [])
          .map((e) => ThreadParticipantDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
      'modelHint': modelHint,
      'createdAt': JsonUtils.toTimestamp(createdAt),
      'updatedAt': JsonUtils.toTimestamp(updatedAt),
      if (lastUserTurnAt != null)
        'lastUserTurnAt': JsonUtils.toTimestamp(lastUserTurnAt),
      'messageCount': messageCount,
      'participants': participants.map((e) => e.toJson()).toList(),
    };
  }

  ThreadEntity toEntity() {
    return ThreadEntity(
      id: id,
      userId: userId,
      title: title,
      status: ThreadStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => ThreadStatus.active,
      ),
      modelHint: modelHint,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastUserTurnAt: lastUserTurnAt,
      messageCount: messageCount,
      participants: participants.map((e) => e.toEntity()).toList(),
    );
  }

  factory ThreadDto.fromEntity(ThreadEntity entity) {
    return ThreadDto(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      status: entity.status.name,
      modelHint: entity.modelHint,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastUserTurnAt: entity.lastUserTurnAt,
      messageCount: entity.messageCount,
      participants: entity.participants
          .map(ThreadParticipantDto.fromEntity)
          .toList(),
    );
  }
}

class ThreadParticipantDto {
  final String userId;
  final String role;
  final DateTime joinedAt;

  const ThreadParticipantDto({
    required this.userId,
    required this.role,
    required this.joinedAt,
  });

  factory ThreadParticipantDto.fromJson(Map<String, dynamic> json) {
    return ThreadParticipantDto(
      userId: json['userId'] as String,
      role: json['role'] as String,
      joinedAt:
          JsonUtils.parseDateTime(json['joinedAt']) ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'role': role,
    'joinedAt': JsonUtils.toTimestamp(joinedAt),
  };

  ThreadParticipant toEntity() {
    return ThreadParticipant(
      userId: userId,
      role: ThreadParticipantRole.values.firstWhere(
        (e) => e.name == role,
        orElse: () => ThreadParticipantRole.owner,
      ),
      joinedAt: joinedAt,
    );
  }

  factory ThreadParticipantDto.fromEntity(ThreadParticipant entity) {
    return ThreadParticipantDto(
      userId: entity.userId,
      role: entity.role.name,
      joinedAt: entity.joinedAt,
    );
  }
}
