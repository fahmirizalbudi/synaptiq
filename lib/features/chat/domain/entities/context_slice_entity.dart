import 'package:equatable/equatable.dart';

class ContextSliceEntity extends Equatable {
  final String id;
  final String threadId;
  final ContextSliceType type;
  final ContextSlicePayload payload;
  final double weight;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const ContextSliceEntity({
    required this.id,
    required this.threadId,
    required this.type,
    required this.payload,
    this.weight = 1,
    required this.createdAt,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [
    id,
    threadId,
    type,
    payload,
    weight,
    createdAt,
    expiresAt,
  ];
}

class ContextSlicePayload extends Equatable {
  final String provider;
  final String? referenceId;
  final String? url;
  final String? inlineText;
  final Map<String, dynamic> metadata;

  const ContextSlicePayload({
    required this.provider,
    this.referenceId,
    this.url,
    this.inlineText,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [provider, referenceId, url, inlineText, metadata];
}

enum ContextSliceType {
  longTermMemory,
  context7Snippet,
  searchResult,
  knowledge,
}
