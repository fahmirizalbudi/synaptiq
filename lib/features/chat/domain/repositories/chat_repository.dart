import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/context_slice_entity.dart';
import '../entities/context_summary_entity.dart';
import '../entities/message_entity.dart';
import '../entities/pending_action_entity.dart';
import '../entities/thread_entity.dart';

abstract class ChatRepository {
  Future<ThreadEntity> createThread({
    required String userId,
    required String title,
    String? modelHint,
  });

  Stream<List<ThreadEntity>> watchThreads(String userId);

  Future<ThreadEntity?> getThread(String userId, String threadId);

  Future<void> updateThread(ThreadEntity thread);

  Future<void> archiveThread(String userId, String threadId);

  Future<void> deleteThread(String userId, String threadId);

  Stream<List<MessageEntity>> watchMessages(String userId, String threadId);

  Future<MessageEntity> sendMessage({
    required String userId,
    required String threadId,
    required MessageEntity message,
  });

  Future<void> updateMessage(MessageEntity message);

  Future<void> deleteMessage(String userId, String threadId, String messageId);

  Future<List<ContextSummaryEntity>> getSummaries(
    String userId,
    String threadId,
  );

  Future<void> upsertSummary(ContextSummaryEntity summary);

  Future<void> deleteSummary(String userId, String threadId, String summaryId);

  Future<List<ContextSliceEntity>> getContextSlices(
    String userId,
    String threadId,
  );

  Future<void> upsertContextSlice(ContextSliceEntity slice);

  Future<void> deleteContextSlice(
    String userId,
    String threadId,
    String sliceId,
  );

  Stream<List<PendingActionEntity>> watchPendingActions(String userId);

  Future<void> upsertPendingAction(PendingActionEntity action);

  Future<void> deletePendingAction(String userId, String actionId);
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  throw UnimplementedError('chatRepositoryProvider must be overridden');
});
