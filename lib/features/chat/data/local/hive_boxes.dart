import 'package:hive_flutter/hive_flutter.dart';

import 'hive_adapters.dart';

class HiveBoxes {
  HiveBoxes._();

  static const threads = 'threads';
  static const messages = 'messages';
  static const pendingActions = 'pending_actions';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ThreadHiveDtoAdapter());
    Hive.registerAdapter(MessageHiveDtoAdapter());
    Hive.registerAdapter(PendingActionHiveDtoAdapter());

    await Future.wait([
      Hive.openBox<ThreadHiveDto>(threads),
      Hive.openBox<MessageHiveDto>(messages),
      Hive.openBox<PendingActionHiveDto>(pendingActions),
    ]);
  }

  static Box<ThreadHiveDto> get threadBox => Hive.box<ThreadHiveDto>(threads);
  static Box<MessageHiveDto> get messageBox =>
      Hive.box<MessageHiveDto>(messages);
  static Box<PendingActionHiveDto> get pendingActionBox =>
      Hive.box<PendingActionHiveDto>(pendingActions);
}
