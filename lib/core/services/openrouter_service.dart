import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

class OpenRouterService {
  final Dio _dio;
  String? _apiKey;

  OpenRouterService({Dio? dio, String? apiKey})
    : _dio = dio ?? Dio(),
      _apiKey = apiKey;

  void setApiKey(String key) => _apiKey = key;
  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;

  Future<String> sendChatCompletion({
    required List<Map<String, String>> messages,
    String? model,
  }) async {
    if (!hasApiKey) throw Exception('API key not configured');

    try {
      final response = await _dio.post(
        '${AppConstants.openRouterBaseUrl}/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
            'HTTP-Referer': 'https://synaptiq.app',
            'X-Title': AppConstants.appDisplayName,
          },
        ),
        data: {
          'model': model ?? AppConstants.defaultModel,
          'messages': messages,
        },
      );

      final choices = response.data['choices'] as List?;
      if (choices == null || choices.isEmpty) {
        throw Exception('No response from model');
      }
      return choices[0]['message']['content'] as String;
    } on DioException catch (e) {
      throw Exception(_parseDioError(e));
    }
  }

  Stream<String> sendChatCompletionStream({
    required List<Map<String, String>> messages,
    String? model,
  }) async* {
    if (!hasApiKey) throw Exception('API key not configured');

    try {
      final response = await _dio.post<ResponseBody>(
        '${AppConstants.openRouterBaseUrl}/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.stream,
        ),
        data: {
          'model': model ?? AppConstants.defaultModel,
          'messages': messages,
          'stream': true,
        },
      );

      await for (final chunk in response.data!.stream) {
        final lines = utf8.decode(chunk).split('\n');
        for (final line in lines) {
          if (!line.startsWith('data: ')) continue;
          final data = line.substring(6).trim();
          if (data == '[DONE]') return;
          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            final delta = json['choices']?[0]?['delta']?['content'] as String?;
            if (delta != null && delta.isNotEmpty) yield delta;
          } catch (_) {}
        }
      }
    } on DioException catch (e) {
      throw Exception(_parseDioError(e));
    }
  }

  String _parseDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String detail = '';
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        detail = error['message'] as String? ?? '';
      } else if (error is String) {
        detail = error;
      }
    }

    switch (statusCode) {
      case 400:
        return 'Bad request: ${detail.isNotEmpty ? detail : 'check message format'}';
      case 401:
        return 'Invalid API key. Please check your OpenRouter key in Settings.';
      case 402:
        return 'Insufficient credits on your OpenRouter account.';
      case 404:
        return 'Model not found. The selected model may be unavailable.';
      case 429:
        return 'Rate limited. Please wait a moment and try again.';
      case 500:
      case 502:
      case 503:
        return 'OpenRouter server error. Please try again later.';
      default:
        return detail.isNotEmpty ? detail : 'Network error: ${e.message}';
    }
  }
}
