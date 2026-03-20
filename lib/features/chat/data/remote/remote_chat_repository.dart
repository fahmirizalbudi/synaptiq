import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/context_slice_entity.dart';
import '../../domain/entities/context_summary_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/pending_action_entity.dart';
import '../../domain/entities/thread_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/context_slice_dto.dart';
import '../models/context_summary_dto.dart';
import '../models/message_dto.dart';
import '../models/pending_action_dto.dart';
import '../models/thread_dto.dart';

class FirestoreChatRepository implements ChatRepository {
  final FirebaseFirestore _firestore;

  FirestoreChatRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _threadsRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('threads');

  CollectionReference<Map<String, dynamic>> _messagesRef(
    String userId,
    String threadId,
  ) => _threadsRef(userId).doc(threadId).collection('messages');

  @override
  Future<ThreadEntity> createThread({
    required String userId,
    required String title,
    String? modelHint,
  }) async {
    final now = DateTime.now().toUtc();
    final doc = _threadsRef(userId).doc();
    final thread = ThreadEntity(
      id: doc.id,
      userId: userId,
      title: title,
      modelHint: modelHint,
      createdAt: now,
      updatedAt: now,
    );
    await doc.set(ThreadDto.fromEntity(thread).toJson());
    return thread;
  }

  @override
  Stream<List<ThreadEntity>> watchThreads(String userId) {
    return _threadsRef(userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ThreadDto.fromJson(d.data(), d.id, userId).toEntity())
              .toList(),
        );
  }

  @override
  Future<ThreadEntity?> getThread(String userId, String threadId) async {
    final doc = await _threadsRef(userId).doc(threadId).get();
    if (!doc.exists) return null;
    return ThreadDto.fromJson(doc.data()!, doc.id, userId).toEntity();
  }

  @override
  Future<void> updateThread(ThreadEntity thread) async {
    await _threadsRef(
      thread.userId,
    ).doc(thread.id).update(ThreadDto.fromEntity(thread).toJson());
  }

  @override
  Future<void> archiveThread(String userId, String threadId) async {
    await _threadsRef(userId).doc(threadId).update({'status': 'archived'});
  }

  @override
  Future<void> deleteThread(String userId, String threadId) async {
    await _threadsRef(userId).doc(threadId).delete();
  }

  @override
  Stream<List<MessageEntity>> watchMessages(String userId, String threadId) {
    return _messagesRef(userId, threadId)
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) => MessageDto.fromJson(d.data(), d.id, threadId).toEntity(),
              )
              .toList(),
        );
  }

  @override
  Future<MessageEntity> sendMessage({
    required String userId,
    required String threadId,
    required MessageEntity message,
  }) async {
    final doc = _messagesRef(userId, threadId).doc(message.id);
    final dto = MessageDto.fromEntity(message);
    await doc.set(dto.toJson());

    await _threadsRef(userId).doc(threadId).update({
      'updatedAt': DateTime.now().toUtc().millisecondsSinceEpoch,
      'messageCount': FieldValue.increment(1),
    });

    return message.copyWith(state: MessageState.sent);
  }

  @override
  Future<void> updateMessage(MessageEntity message) async {
    throw UnimplementedError(
      'updateMessage requires userId — use sendMessage for now',
    );
  }

  @override
  Future<void> deleteMessage(
    String userId,
    String threadId,
    String messageId,
  ) async {
    await _messagesRef(userId, threadId).doc(messageId).delete();
  }

  @override
  Future<List<ContextSummaryEntity>> getSummaries(
    String userId,
    String threadId,
  ) async {
    final snap = await _threadsRef(
      userId,
    ).doc(threadId).collection('summaries').get();
    return snap.docs
        .map(
          (d) =>
              ContextSummaryDto.fromJson(d.data(), d.id, threadId).toEntity(),
        )
        .toList();
  }

  @override
  Future<void> upsertSummary(ContextSummaryEntity summary) async {
    throw UnimplementedError('upsertSummary not yet implemented');
  }

  @override
  Future<void> deleteSummary(
    String userId,
    String threadId,
    String summaryId,
  ) async {
    throw UnimplementedError('deleteSummary not yet implemented');
  }

  @override
  Future<List<ContextSliceEntity>> getContextSlices(
    String userId,
    String threadId,
  ) async {
    final snap = await _threadsRef(
      userId,
    ).doc(threadId).collection('contextSlices').get();
    return snap.docs
        .map(
          (d) => ContextSliceDto.fromJson(d.data(), d.id, threadId).toEntity(),
        )
        .toList();
  }

  @override
  Future<void> upsertContextSlice(ContextSliceEntity slice) async {
    throw UnimplementedError('upsertContextSlice not yet implemented');
  }

  @override
  Future<void> deleteContextSlice(
    String userId,
    String threadId,
    String sliceId,
  ) async {
    throw UnimplementedError('deleteContextSlice not yet implemented');
  }

  @override
  Stream<List<PendingActionEntity>> watchPendingActions(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('pendingActions')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) => PendingActionDto.fromJson(
                  d.data(),
                  d.id,
                  userId,
                ).toEntity(),
              )
              .toList(),
        );
  }

  @override
  Future<void> upsertPendingAction(PendingActionEntity action) async {
    throw UnimplementedError('upsertPendingAction not yet implemented');
  }

  @override
  Future<void> deletePendingAction(String userId, String actionId) async {
    throw UnimplementedError('deletePendingAction not yet implemented');
  }
}
