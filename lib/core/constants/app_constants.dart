/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Synaptiq';
  static const String appDisplayName = 'Synaptiq AI';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String conversationsCollection = 'conversations';
  static const String messagesCollection = 'messages';

  // OpenRouter API (placeholder)
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  static const String defaultModel = 'deepseek/deepseek-v3.2';

  // UI Constants
  static const double designWidth = 393;
  static const double designHeight = 852;
  static const double minTouchTarget = 48; // Following Android guidelines

  // Validation
  static const int minPasswordLength = 8;
  static const int maxMessageLength = 4000;
  static const int maxConversationTitleLength = 50;

  // Pagination
  static const int messagesPerPage = 50;
  static const int conversationsPerPage = 20;
}
