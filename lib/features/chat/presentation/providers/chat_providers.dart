import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/message_entity.dart';
import '../../domain/entities/thread_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../data/remote/remote_chat_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final firestoreChatRepositoryProvider = Provider<ChatRepository>((ref) {
  return FirestoreChatRepository();
});

final threadsProvider = StreamProvider<List<ThreadEntity>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  final repo = ref.watch(firestoreChatRepositoryProvider);
  return repo.watchThreads(user.uid);
});

final currentThreadIdProvider = StateProvider<String?>((ref) => null);

final messagesProvider = StreamProvider.family<List<MessageEntity>, String>((
  ref,
  threadId,
) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  final repo = ref.watch(firestoreChatRepositoryProvider);
  return repo.watchMessages(user.uid, threadId);
});
