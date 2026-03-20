import 'package:synaptiq/core/utils/json_utils.dart';

import '../../domain/entities/pending_action_entity.dart';

class PendingActionDto {
  final String id;
  final String userId;
  final String type;
  final Map<String, dynamic> payload;
  final String status;
  final int retries;
  final String? errorCode;
  final DateTime createdAt;
  final DateTime? lastTried;

  const PendingActionDto({
    required this.id,
    required this.userId,
    required this.type,
    this.payload = const {},
    this.status = 'queued',
    this.retries = 0,
    this.errorCode,
    required this.createdAt,
    this.lastTried,
  });

  factory PendingActionDto.fromJson(
    Map<String, dynamic> json,
    String id,
    String userId,
  ) {
    return PendingActionDto(
      id: id,
      userId: userId,
      type: json['type'] as String,
      payload: (json['payload'] as Map<String, dynamic>?) ?? const {},
      status: json['status'] as String? ?? 'queued',
      retries: json['retries'] as int? ?? 0,
      errorCode: json['errorCode'] as String?,
      createdAt:
          JsonUtils.parseDateTime(json['createdAt']) ?? DateTime.now().toUtc(),
      lastTried: JsonUtils.parseDateTime(json['lastTried']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': payload,
      'status': status,
      'retries': retries,
      if (errorCode != null) 'errorCode': errorCode,
      'createdAt': JsonUtils.toTimestamp(createdAt),
      if (lastTried != null) 'lastTried': JsonUtils.toTimestamp(lastTried),
    };
  }

  PendingActionEntity toEntity() {
    return PendingActionEntity(
      id: id,
      userId: userId,
      type: PendingActionType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => PendingActionType.sendMessage,
      ),
      payload: payload,
      status: PendingActionStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => PendingActionStatus.queued,
      ),
      retries: retries,
      errorCode: errorCode,
      createdAt: createdAt,
      lastTried: lastTried,
    );
  }

  factory PendingActionDto.fromEntity(PendingActionEntity entity) {
    return PendingActionDto(
      id: entity.id,
      userId: entity.userId,
      type: entity.type.name,
      payload: entity.payload,
      status: entity.status.name,
      retries: entity.retries,
      errorCode: entity.errorCode,
      createdAt: entity.createdAt,
      lastTried: entity.lastTried,
    );
  }
}
