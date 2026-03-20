import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/thread_entity.dart';
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

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onNewChat,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('New Chat'),
            ),
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
        Expanded(
          child: threadsAsync.when(
            data: (threads) {
              if (threads.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
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
                itemCount: threads.length,
                itemBuilder: (context, index) =>
                    _buildThreadTile(context, threads[index]),
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
      ],
    );
  }

  Widget _buildThreadTile(BuildContext context, ThreadEntity thread) {
    final isSelected = thread.id == selectedThreadId;
    return ListTile(
      selected: isSelected,
      selectedTileColor: AppColors.surfaceVariant,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
        '${thread.messageCount} messages',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
      ),
      trailing: Text(
        _formatDate(thread.updatedAt),
        style: TextStyle(color: AppColors.textSecondary, fontSize: 11.sp),
      ),
      onTap: () => onThreadSelected(thread.id),
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
