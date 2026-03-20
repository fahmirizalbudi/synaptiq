import 'package:equatable/equatable.dart';

class ThreadEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final ThreadStatus status;
  final String? modelHint;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastUserTurnAt;
  final int messageCount;
  final List<ThreadParticipant> participants;

  const ThreadEntity({
    required this.id,
    required this.userId,
    required this.title,
    this.status = ThreadStatus.active,
    this.modelHint,
    required this.createdAt,
    required this.updatedAt,
    this.lastUserTurnAt,
    this.messageCount = 0,
    this.participants = const [],
  });

  ThreadEntity copyWith({
    String? id,
    String? userId,
    String? title,
    ThreadStatus? status,
    String? modelHint,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastUserTurnAt,
    int? messageCount,
    List<ThreadParticipant>? participants,
  }) {
    return ThreadEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      status: status ?? this.status,
      modelHint: modelHint ?? this.modelHint,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastUserTurnAt: lastUserTurnAt ?? this.lastUserTurnAt,
      messageCount: messageCount ?? this.messageCount,
      participants: participants ?? this.participants,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    status,
    modelHint,
    createdAt,
    updatedAt,
    lastUserTurnAt,
    messageCount,
    participants,
  ];
}

class ThreadParticipant extends Equatable {
  final String userId;
  final ThreadParticipantRole role;
  final DateTime joinedAt;

  const ThreadParticipant({
    required this.userId,
    required this.role,
    required this.joinedAt,
  });

  @override
  List<Object?> get props => [userId, role, joinedAt];
}

enum ThreadStatus { active, archived, deleted }

enum ThreadParticipantRole { owner, viewer, editor }
