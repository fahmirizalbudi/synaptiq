import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final apiKeyProvider = StateNotifierProvider<ApiKeyNotifier, String?>((ref) {
  return ApiKeyNotifier();
});

class ApiKeyNotifier extends StateNotifier<String?> {
  static const _boxName = 'settings';
  static const _keyField = 'openrouter_api_key';

  ApiKeyNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final box = Hive.isBoxOpen(_boxName)
        ? Hive.box(_boxName)
        : await Hive.openBox(_boxName);
    state = box.get(_keyField) as String?;
  }

  Future<void> setKey(String key) async {
    final box = Hive.isBoxOpen(_boxName)
        ? Hive.box(_boxName)
        : await Hive.openBox(_boxName);
    await box.put(_keyField, key);
    state = key;
  }

  Future<void> clearKey() async {
    final box = Hive.isBoxOpen(_boxName)
        ? Hive.box(_boxName)
        : await Hive.openBox(_boxName);
    await box.delete(_keyField);
    state = null;
  }
}
