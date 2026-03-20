import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_key_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../chat/presentation/providers/chat_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _obscureKey = true;

  @override
  void initState() {
    super.initState();
    final current = ref.read(apiKeyProvider);
    if (current != null) _apiKeyController.text = current;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final apiKey = ref.watch(apiKeyProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_regular),
          onPressed: () => context.go('/chat'),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        children: [
          if (user != null) ...[
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28.r,
                    backgroundColor: AppColors.surfaceVariant,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: user.photoURL == null
                        ? Text(
                            _getInitials(user.displayName, user.email),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName ?? 'User',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          user.email ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
          ],
          Text(
            'API Configuration',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _apiKeyController,
            obscureText: _obscureKey,
            decoration: InputDecoration(
              hintText: 'OpenRouter API Key',
              prefixIcon: Icon(FluentIcons.key_24_regular),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      _obscureKey
                          ? FluentIcons.eye_off_24_regular
                          : FluentIcons.eye_24_regular,
                    ),
                    onPressed: () => setState(() => _obscureKey = !_obscureKey),
                  ),
                  IconButton(
                    icon: Icon(FluentIcons.checkmark_24_regular),
                    onPressed: () {
                      ref
                          .read(apiKeyProvider.notifier)
                          .setKey(_apiKeyController.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('API key saved')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            apiKey != null ? '✓ Key configured' : '⚠ No key set',
            style: TextStyle(
              color: apiKey != null ? AppColors.success : AppColors.warning,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 32.h),
          OutlinedButton.icon(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete All Chat History'),
                  content: const Text(
                    'Are you sure you want to delete all past conversations? This cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(ctx).pop();
                        final repo = ref.read(firestoreChatRepositoryProvider);
                        await repo.deleteAllThreads(user!.uid);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All chat history deleted.'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Delete All',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(FluentIcons.delete_24_regular, color: AppColors.error),
            label: const Text(
              'Delete All Chat History',
              style: TextStyle(color: AppColors.error),
            ),
          ),
          SizedBox(height: 16.h),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
            icon: Icon(FluentIcons.sign_out_24_regular, color: AppColors.error),
            label: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String? displayName, String? email) {
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim()[0].toUpperCase();
    }
    if (email != null && email.trim().isNotEmpty) {
      return email.trim()[0].toUpperCase();
    }
    return '?';
  }
}
