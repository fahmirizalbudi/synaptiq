import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/message_entity.dart';
import '../providers/chat_providers.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer.dart';
import '../widgets/thread_list.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSend(String text) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    var threadId = ref.read(currentThreadIdProvider);
    final repo = ref.read(firestoreChatRepositoryProvider);

    if (threadId == null) {
      final thread = await repo.createThread(
        userId: user.uid,
        title: text.length > 30 ? '${text.substring(0, 30)}...' : text,
        modelHint: AppConstants.defaultModel,
      );
      threadId = thread.id;
      ref.read(currentThreadIdProvider.notifier).state = threadId;
    }

    final message = MessageEntity(
      id: const Uuid().v4(),
      threadId: threadId,
      role: 'user',
      content: MessageContent(type: MessageContentType.text, text: text),
      createdAt: DateTime.now().toUtc(),
    );

    setState(() => _isSending = true);
    try {
      await repo.sendMessage(
        userId: user.uid,
        threadId: threadId,
        message: message,
      );
      _scrollToBottom();
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleNewChat() {
    ref.read(currentThreadIdProvider.notifier).state = null;
    Navigator.of(context).pop();
  }

  void _handleThreadSelected(String threadId) {
    ref.read(currentThreadIdProvider.notifier).state = threadId;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final threadId = ref.watch(currentThreadIdProvider);
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          threadId != null ? 'Nirmala' : 'New Chat',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          if (user != null)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.surfaceVariant,
                child: Text(
                  (user.displayName ?? user.email ?? '?')[0].toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.surface,
        child: SafeArea(
          child: ThreadList(
            selectedThreadId: threadId,
            onThreadSelected: _handleThreadSelected,
            onNewChat: _handleNewChat,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(threadId)),
          MessageComposer(
            enabled: !_isSending,
            isLoading: _isSending,
            onSend: _handleSend,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(String? threadId) {
    if (threadId == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 64.sp,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'How can I help you today?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start a conversation with Nirmala',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    final messagesAsync = ref.watch(messagesProvider(threadId));

    return messagesAsync.when(
      data: (messages) {
        if (messages.isEmpty) {
          return const Center(
            child: Text(
              'Send a message to get started',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: messages.length,
          itemBuilder: (context, index) =>
              MessageBubble(message: messages[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error: $e',
          style: const TextStyle(color: AppColors.error),
        ),
      ),
    );
  }
}
