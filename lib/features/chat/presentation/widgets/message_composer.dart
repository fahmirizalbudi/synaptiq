import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class MessageComposer extends StatefulWidget {
  final bool enabled;
  final bool isLoading;
  final ValueChanged<String> onSend;

  const MessageComposer({
    super.key,
    this.enabled = true,
    this.isLoading = false,
    required this.onSend,
  });

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    setState(() => _hasText = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 8.w, 16.h),
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: widget.enabled,
                  maxLines: 5,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  onChanged: (v) =>
                      setState(() => _hasText = v.trim().isNotEmpty),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Message Nirmala...',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    filled: false,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              _buildSendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    if (widget.isLoading) {
      return Padding(
        padding: EdgeInsets.all(12.w),
        child: SizedBox(
          width: 20.w,
          height: 20.h,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      );
    }

    return IconButton(
      onPressed: (_hasText && widget.enabled) ? _handleSend : null,
      icon: Icon(
        FluentIcons.send_20_filled,
        size: 20.sp,
        color: (_hasText && widget.enabled)
            ? AppColors.background
            : AppColors.textSecondary,
      ),
      style: IconButton.styleFrom(
        backgroundColor: (_hasText && widget.enabled)
            ? AppColors.primary
            : AppColors.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        minimumSize: Size(40.w, 40.h),
      ),
    );
  }
}
