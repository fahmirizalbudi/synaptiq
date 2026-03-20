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
      data: {'model': model ?? AppConstants.defaultModel, 'messages': messages},
    );

    final choices = response.data['choices'] as List;
    if (choices.isEmpty) throw Exception('No response from model');
    return choices[0]['message']['content'] as String;
  }

  Stream<String> sendChatCompletionStream({
    required List<Map<String, String>> messages,
    String? model,
  }) async* {
    if (!hasApiKey) throw Exception('API key not configured');

    final response = await _dio.post<ResponseBody>(
      '${AppConstants.openRouterBaseUrl}/chat/completions',
      options: Options(
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://synaptiq.app',
          'X-Title': AppConstants.appDisplayName,
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
  }
}
