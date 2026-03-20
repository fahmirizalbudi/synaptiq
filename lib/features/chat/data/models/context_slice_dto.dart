import 'package:synaptiq/core/utils/json_utils.dart';

import '../../domain/entities/context_slice_entity.dart';

class ContextSliceDto {
  final String id;
  final String threadId;
  final String type;
  final ContextSlicePayloadDto payload;
  final double weight;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const ContextSliceDto({
    required this.id,
    required this.threadId,
    required this.type,
    required this.payload,
    this.weight = 1,
    required this.createdAt,
    this.expiresAt,
  });

  factory ContextSliceDto.fromJson(
    Map<String, dynamic> json,
    String id,
    String threadId,
  ) {
    return ContextSliceDto(
      id: id,
      threadId: threadId,
      type: json['type'] as String,
      payload: ContextSlicePayloadDto.fromJson(
        json['payload'] as Map<String, dynamic>,
      ),
      weight: (json['weight'] as num?)?.toDouble() ?? 1,
      createdAt:
          JsonUtils.parseDateTime(json['createdAt']) ?? DateTime.now().toUtc(),
      expiresAt: JsonUtils.parseDateTime(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': payload.toJson(),
      'weight': weight,
      'createdAt': JsonUtils.toTimestamp(createdAt),
      if (expiresAt != null) 'expiresAt': JsonUtils.toTimestamp(expiresAt),
    };
  }

  ContextSliceEntity toEntity() {
    return ContextSliceEntity(
      id: id,
      threadId: threadId,
      type: ContextSliceType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => ContextSliceType.longTermMemory,
      ),
      payload: payload.toEntity(),
      weight: weight,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }

  factory ContextSliceDto.fromEntity(ContextSliceEntity entity) {
    return ContextSliceDto(
      id: entity.id,
      threadId: entity.threadId,
      type: entity.type.name,
      payload: ContextSlicePayloadDto.fromEntity(entity.payload),
      weight: entity.weight,
      createdAt: entity.createdAt,
      expiresAt: entity.expiresAt,
    );
  }
}

class ContextSlicePayloadDto {
  final String provider;
  final String? referenceId;
  final String? url;
  final String? inlineText;
  final Map<String, dynamic> metadata;

  const ContextSlicePayloadDto({
    required this.provider,
    this.referenceId,
    this.url,
    this.inlineText,
    this.metadata = const {},
  });

  factory ContextSlicePayloadDto.fromJson(Map<String, dynamic> json) {
    return ContextSlicePayloadDto(
      provider: json['provider'] as String,
      referenceId: json['referenceId'] as String?,
      url: json['url'] as String?,
      inlineText: json['inlineText'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? const {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      if (referenceId != null) 'referenceId': referenceId,
      if (url != null) 'url': url,
      if (inlineText != null) 'inlineText': inlineText,
      'metadata': metadata,
    };
  }

  ContextSlicePayload toEntity() {
    return ContextSlicePayload(
      provider: provider,
      referenceId: referenceId,
      url: url,
      inlineText: inlineText,
      metadata: metadata,
    );
  }

  factory ContextSlicePayloadDto.fromEntity(ContextSlicePayload entity) {
    return ContextSlicePayloadDto(
      provider: entity.provider,
      referenceId: entity.referenceId,
      url: entity.url,
      inlineText: entity.inlineText,
      metadata: entity.metadata,
    );
  }
}
