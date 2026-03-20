import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String threadId;
  final String role;
  final MessageContent content;
  final List<String> contextRefs;
  final MessageState state;
  final int tokenEstimate;
  final List<MessageAttachment> attachments;
  final DateTime createdAt;
  final DateTime? serverCreatedAt;
  final DateTime? editedAt;

  const MessageEntity({
    required this.id,
    required this.threadId,
    required this.role,
    required this.content,
    this.contextRefs = const [],
    this.state = MessageState.pending,
    this.tokenEstimate = 0,
    this.attachments = const [],
    required this.createdAt,
    this.serverCreatedAt,
    this.editedAt,
  });

  MessageEntity copyWith({
    String? id,
    String? threadId,
    String? role,
    MessageContent? content,
    List<String>? contextRefs,
    MessageState? state,
    int? tokenEstimate,
    List<MessageAttachment>? attachments,
    DateTime? createdAt,
    DateTime? serverCreatedAt,
    DateTime? editedAt,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      role: role ?? this.role,
      content: content ?? this.content,
      contextRefs: contextRefs ?? this.contextRefs,
      state: state ?? this.state,
      tokenEstimate: tokenEstimate ?? this.tokenEstimate,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      serverCreatedAt: serverCreatedAt ?? this.serverCreatedAt,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    threadId,
    role,
    content,
    contextRefs,
    state,
    tokenEstimate,
    attachments,
    createdAt,
    serverCreatedAt,
    editedAt,
  ];
}

class MessageContent extends Equatable {
  final MessageContentType type;
  final String? text;
  final List<MessagePart> parts;

  const MessageContent({required this.type, this.text, this.parts = const []});

  @override
  List<Object?> get props => [type, text, parts];
}

class MessagePart extends Equatable {
  final String kind;
  final Map<String, dynamic> payload;

  const MessagePart({required this.kind, this.payload = const {}});

  @override
  List<Object?> get props => [kind, payload];
}

class MessageAttachment extends Equatable {
  final String name;
  final String url;
  final int sizeBytes;
  final String mimeType;

  const MessageAttachment({
    required this.name,
    required this.url,
    required this.sizeBytes,
    required this.mimeType,
  });

  @override
  List<Object?> get props => [name, url, sizeBytes, mimeType];
}

enum MessageContentType { text, rich }

enum MessageState { pending, sent, synced, failed, edited, deleted }
