import '../../features/chat/domain/entities/message_entity.dart';
import '../utils/token_estimator.dart';

class ContextBuilderService {
  static const int defaultMaxTokens = 4096;
  static const int defaultRecentTurns = 20;

  List<Map<String, String>> buildPrompt({
    required List<MessageEntity> messages,
    String? systemPrompt,
    int maxTokens = defaultMaxTokens,
    int recentTurns = defaultRecentTurns,
  }) {
    final prompt = <Map<String, String>>[];

    if (systemPrompt != null) {
      prompt.add({'role': 'system', 'content': systemPrompt});
    } else {
      prompt.add({
        'role': 'system',
        'content':
            'You are Synaptiq, a helpful and context-aware AI assistant. '
            'You remember the conversation history and provide thoughtful, relevant responses. '
            'Be concise but thorough.',
      });
    }

    final recentMessages = messages.length > recentTurns
        ? messages.sublist(messages.length - recentTurns)
        : messages;

    for (final msg in recentMessages) {
      prompt.add({'role': msg.role, 'content': msg.content.text ?? ''});
    }

    return TokenEstimator.truncateToFit(messages: prompt, maxTokens: maxTokens);
  }
}
