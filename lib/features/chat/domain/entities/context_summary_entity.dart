import 'package:equatable/equatable.dart';

class ContextSummaryEntity extends Equatable {
  final String id;
  final String threadId;
  final ContextSummaryScope scope;
  final String content;
  final List<String> sourceMessageIds;
  final int tokenCount;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const ContextSummaryEntity({
    required this.id,
    required this.threadId,
    required this.scope,
    required this.content,
    this.sourceMessageIds = const [],
    this.tokenCount = 0,
    required this.createdAt,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [
    id,
    threadId,
    scope,
    content,
    sourceMessageIds,
    tokenCount,
    createdAt,
    expiresAt,
  ];
}

enum ContextSummaryScope { thread, segment, userProfile }
