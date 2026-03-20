import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;

  const MessageBubble({super.key, required this.message});

  bool get _isUser => message.role == 'user';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 300.w),
        margin: EdgeInsets.only(
          left: _isUser ? 48.w : 0,
          right: _isUser ? 0 : 48.w,
          bottom: 8.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: _isUser ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(_isUser ? 16.r : 4.r),
            bottomRight: Radius.circular(_isUser ? 4.r : 16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content.text ?? '',
              style: TextStyle(
                color: _isUser ? AppColors.background : AppColors.textPrimary,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style: TextStyle(
                    color: _isUser
                        ? AppColors.background.withValues(alpha: 0.6)
                        : AppColors.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
                if (_isUser) ...[SizedBox(width: 4.w), _buildStateIcon()],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateIcon() {
    switch (message.state) {
      case MessageState.pending:
        return Icon(
          FluentIcons.clock_24_regular,
          size: 12.sp,
          color: AppColors.background.withValues(alpha: 0.6),
        );
      case MessageState.sent:
        return Icon(
          FluentIcons.checkmark_24_regular,
          size: 12.sp,
          color: AppColors.background.withValues(alpha: 0.6),
        );
      case MessageState.synced:
        return Icon(
          FluentIcons.checkmark_circle_24_regular,
          size: 12.sp,
          color: AppColors.background.withValues(alpha: 0.6),
        );
      case MessageState.failed:
        return Icon(
          FluentIcons.error_circle_24_regular,
          size: 12.sp,
          color: AppColors.error,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
