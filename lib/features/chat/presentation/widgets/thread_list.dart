import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/thread_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/chat_providers.dart';

class ThreadList extends ConsumerWidget {
  final String? selectedThreadId;
  final ValueChanged<String> onThreadSelected;
  final VoidCallback onNewChat;

  const ThreadList({
    super.key,
    this.selectedThreadId,
    required this.onThreadSelected,
    required this.onNewChat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadsAsync = ref.watch(threadsProvider);
    final user = ref.watch(authStateProvider).valueOrNull;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onNewChat,
              icon: Icon(FluentIcons.add_24_regular, size: 20),
              label: const Text('New Chat'),
            ),
          ),
        ),
        Expanded(
          child: threadsAsync.when(
            data: (threads) {
              if (threads.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FluentIcons.chat_24_regular,
                        size: 48.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'No conversations yet',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                itemCount: threads.length,
                itemBuilder: (context, index) =>
                    _buildThreadTile(context, ref, threads[index]),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text(
                'Error: $e',
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              if (user != null) ...[
                ListTile(
                  leading: Icon(
                    FluentIcons.settings_24_regular,
                    color: AppColors.textSecondary,
                  ),
                  title: Text('Settings', style: TextStyle(fontSize: 14.sp)),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/settings');
                  },
                ),
                ListTile(
                  leading: Icon(
                    FluentIcons.sign_out_24_regular,
                    color: AppColors.error,
                  ),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(color: AppColors.error, fontSize: 14.sp),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await ref.read(authNotifierProvider.notifier).signOut();
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ThreadEntity thread,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Delete Chat Session',
                style: Theme.of(ctx).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'Are you sure you want to delete "${thread.title}"?\nThis cannot be undone.',
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final user = ref.read(authStateProvider).valueOrNull;
                  if (user == null) return;
                  final repo = ref.read(firestoreChatRepositoryProvider);
                  await repo.deleteThread(user.uid, thread.id);
                  final currentId = ref.read(currentThreadIdProvider);
                  if (currentId == thread.id) {
                    ref.read(currentThreadIdProvider.notifier).state = null;
                  }
                },
                child: const Text('Delete'),
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThreadTile(
    BuildContext context,
    WidgetRef ref,
    ThreadEntity thread,
  ) {
    final isSelected = thread.id == selectedThreadId;
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Dismissible(
        key: Key(thread.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          _confirmDelete(context, ref, thread);
          return false;
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 16.w),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(FluentIcons.delete_24_regular, color: AppColors.error),
        ),
        child: ListTile(
          selected: isSelected,
          selectedTileColor: AppColors.surfaceVariant,
          title: Text(
            thread.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            '${thread.messageCount} messages • ${_formatDate(thread.updatedAt)}',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
          trailing: IconButton(
            icon: Icon(
              FluentIcons.delete_20_regular,
              color: isSelected ? AppColors.error : AppColors.textSecondary,
              size: 18.sp,
            ),
            onPressed: () => _confirmDelete(context, ref, thread),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          onTap: () => onThreadSelected(thread.id),
          onLongPress: () => _confirmDelete(context, ref, thread),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${dt.day}/${dt.month}';
  }
}
