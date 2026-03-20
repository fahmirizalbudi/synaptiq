import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_key_repository.dart';
import '../../core/services/context_builder_service.dart';
import '../../core/services/openrouter_service.dart';

final openRouterServiceProvider = Provider<OpenRouterService>((ref) {
  final apiKey = ref.watch(apiKeyProvider);
  final service = OpenRouterService(apiKey: apiKey);
  return service;
});

final contextBuilderProvider = Provider<ContextBuilderService>((ref) {
  return ContextBuilderService();
});
