import 'package:synaptiq/core/utils/json_utils.dart';

import '../../domain/entities/message_entity.dart';

class MessageDto {
  final String id;
  final String threadId;
  final String role;
  final MessageContentDto content;
  final List<String> contextRefs;
  final String state;
  final int tokenEstimate;
  final List<MessageAttachmentDto> attachments;
  final DateTime createdAt;
  final DateTime? serverCreatedAt;
  final DateTime? editedAt;

  const MessageDto({
    required this.id,
    required this.threadId,
    required this.role,
    required this.content,
    this.contextRefs = const [],
    this.state = 'pending',
    this.tokenEstimate = 0,
    this.attachments = const [],
    required this.createdAt,
    this.serverCreatedAt,
    this.editedAt,
  });

  factory MessageDto.fromJson(
    Map<String, dynamic> json,
    String id,
    String threadId,
  ) {
    return MessageDto(
      id: id,
      threadId: threadId,
      role: json['role'] as String,
      content: MessageContentDto.fromJson(
        json['content'] as Map<String, dynamic>,
      ),
      contextRefs:
          (json['contextRefs'] as List<dynamic>?)?.cast<String>() ?? const [],
      state: json['state'] as String? ?? 'pending',
      tokenEstimate: json['tokenEstimate'] as int? ?? 0,
      attachments: (json['attachments'] as List<dynamic>? ?? const [])
          .map((e) => MessageAttachmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt:
          JsonUtils.parseDateTime(json['createdAt']) ?? DateTime.now().toUtc(),
      serverCreatedAt: JsonUtils.parseDateTime(json['serverCreatedAt']),
      editedAt: JsonUtils.parseDateTime(json['editedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content.toJson(),
      'contextRefs': contextRefs,
      'state': state,
      'tokenEstimate': tokenEstimate,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'createdAt': JsonUtils.toTimestamp(createdAt),
      if (serverCreatedAt != null)
        'serverCreatedAt': JsonUtils.toTimestamp(serverCreatedAt),
      if (editedAt != null) 'editedAt': JsonUtils.toTimestamp(editedAt),
    };
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      threadId: threadId,
      role: role,
      content: content.toEntity(),
      contextRefs: contextRefs,
      state: MessageState.values.firstWhere(
        (e) => e.name == state,
        orElse: () => MessageState.pending,
      ),
      tokenEstimate: tokenEstimate,
      attachments: attachments.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      serverCreatedAt: serverCreatedAt,
      editedAt: editedAt,
    );
  }

  factory MessageDto.fromEntity(MessageEntity entity) {
    return MessageDto(
      id: entity.id,
      threadId: entity.threadId,
      role: entity.role,
      content: MessageContentDto.fromEntity(entity.content),
      contextRefs: entity.contextRefs,
      state: entity.state.name,
      tokenEstimate: entity.tokenEstimate,
      attachments: entity.attachments
          .map(MessageAttachmentDto.fromEntity)
          .toList(),
      createdAt: entity.createdAt,
      serverCreatedAt: entity.serverCreatedAt,
      editedAt: entity.editedAt,
    );
  }
}

class MessageContentDto {
  final String type;
  final String? text;
  final List<MessagePartDto> parts;

  const MessageContentDto({
    required this.type,
    this.text,
    this.parts = const [],
  });

  factory MessageContentDto.fromJson(Map<String, dynamic> json) {
    return MessageContentDto(
      type: json['type'] as String,
      text: json['text'] as String?,
      parts: (json['parts'] as List<dynamic>? ?? const [])
          .map((e) => MessagePartDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (text != null) 'text': text,
      'parts': parts.map((e) => e.toJson()).toList(),
    };
  }

  MessageContent toEntity() {
    return MessageContent(
      type: MessageContentType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => MessageContentType.text,
      ),
      text: text,
      parts: parts.map((e) => e.toEntity()).toList(),
    );
  }

  factory MessageContentDto.fromEntity(MessageContent entity) {
    return MessageContentDto(
      type: entity.type.name,
      text: entity.text,
      parts: entity.parts.map(MessagePartDto.fromEntity).toList(),
    );
  }
}

class MessagePartDto {
  final String kind;
  final Map<String, dynamic> payload;

  const MessagePartDto({required this.kind, this.payload = const {}});

  factory MessagePartDto.fromJson(Map<String, dynamic> json) {
    return MessagePartDto(
      kind: json['kind'] as String,
      payload: (json['payload'] as Map<String, dynamic>?) ?? const {},
    );
  }

  Map<String, dynamic> toJson() => {'kind': kind, 'payload': payload};

  MessagePart toEntity() => MessagePart(kind: kind, payload: payload);

  factory MessagePartDto.fromEntity(MessagePart entity) =>
      MessagePartDto(kind: entity.kind, payload: entity.payload);
}

class MessageAttachmentDto {
  final String name;
  final String url;
  final int sizeBytes;
  final String mimeType;

  const MessageAttachmentDto({
    required this.name,
    required this.url,
    required this.sizeBytes,
    required this.mimeType,
  });

  factory MessageAttachmentDto.fromJson(Map<String, dynamic> json) {
    return MessageAttachmentDto(
      name: json['name'] as String,
      url: json['url'] as String,
      sizeBytes: json['size'] as int,
      mimeType: json['mimeType'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'url': url,
    'size': sizeBytes,
    'mimeType': mimeType,
  };

  MessageAttachment toEntity() => MessageAttachment(
    name: name,
    url: url,
    sizeBytes: sizeBytes,
    mimeType: mimeType,
  );

  factory MessageAttachmentDto.fromEntity(MessageAttachment entity) {
    return MessageAttachmentDto(
      name: entity.name,
      url: entity.url,
      sizeBytes: entity.sizeBytes,
      mimeType: entity.mimeType,
    );
  }
}
