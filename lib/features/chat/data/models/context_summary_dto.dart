import 'package:synaptiq/core/utils/json_utils.dart';

import '../../domain/entities/context_summary_entity.dart';

class ContextSummaryDto {
  final String id;
  final String threadId;
  final String scope;
  final String content;
  final List<String> sourceMessageIds;
  final int tokenCount;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const ContextSummaryDto({
    required this.id,
    required this.threadId,
    required this.scope,
    required this.content,
    this.sourceMessageIds = const [],
    this.tokenCount = 0,
    required this.createdAt,
    this.expiresAt,
  });

  factory ContextSummaryDto.fromJson(
    Map<String, dynamic> json,
    String id,
    String threadId,
  ) {
    return ContextSummaryDto(
      id: id,
      threadId: threadId,
      scope: json['scope'] as String,
      content: json['content'] as String,
      sourceMessageIds:
          (json['sourceMessageIds'] as List<dynamic>?)?.cast<String>() ??
          const [],
      tokenCount: json['tokenCount'] as int? ?? 0,
      createdAt:
          JsonUtils.parseDateTime(json['createdAt']) ?? DateTime.now().toUtc(),
      expiresAt: JsonUtils.parseDateTime(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scope': scope,
      'content': content,
      'sourceMessageIds': sourceMessageIds,
      'tokenCount': tokenCount,
      'createdAt': JsonUtils.toTimestamp(createdAt),
      if (expiresAt != null) 'expiresAt': JsonUtils.toTimestamp(expiresAt),
    };
  }

  ContextSummaryEntity toEntity() {
    return ContextSummaryEntity(
      id: id,
      threadId: threadId,
      scope: ContextSummaryScope.values.firstWhere(
        (e) => e.name == scope,
        orElse: () => ContextSummaryScope.thread,
      ),
      content: content,
      sourceMessageIds: sourceMessageIds,
      tokenCount: tokenCount,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }

  factory ContextSummaryDto.fromEntity(ContextSummaryEntity entity) {
    return ContextSummaryDto(
      id: entity.id,
      threadId: entity.threadId,
      scope: entity.scope.name,
      content: entity.content,
      sourceMessageIds: entity.sourceMessageIds,
      tokenCount: entity.tokenCount,
      createdAt: entity.createdAt,
      expiresAt: entity.expiresAt,
    );
  }
}
