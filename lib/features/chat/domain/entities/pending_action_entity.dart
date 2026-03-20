import 'package:equatable/equatable.dart';

class PendingActionEntity extends Equatable {
  final String id;
  final String userId;
  final PendingActionType type;
  final Map<String, dynamic> payload;
  final PendingActionStatus status;
  final int retries;
  final String? errorCode;
  final DateTime createdAt;
  final DateTime? lastTried;

  const PendingActionEntity({
    required this.id,
    required this.userId,
    required this.type,
    this.payload = const {},
    this.status = PendingActionStatus.queued,
    this.retries = 0,
    this.errorCode,
    required this.createdAt,
    this.lastTried,
  });

  PendingActionEntity copyWith({
    String? id,
    String? userId,
    PendingActionType? type,
    Map<String, dynamic>? payload,
    PendingActionStatus? status,
    int? retries,
    String? errorCode,
    DateTime? createdAt,
    DateTime? lastTried,
  }) {
    return PendingActionEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      retries: retries ?? this.retries,
      errorCode: errorCode ?? this.errorCode,
      createdAt: createdAt ?? this.createdAt,
      lastTried: lastTried ?? this.lastTried,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    payload,
    status,
    retries,
    errorCode,
    createdAt,
    lastTried,
  ];
}

enum PendingActionType { sendMessage, syncFailover, contextRefresh }

enum PendingActionStatus { queued, inProgress, completed, failed }
