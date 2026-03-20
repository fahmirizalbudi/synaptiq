import 'package:hive_flutter/hive_flutter.dart';

class ThreadHiveDto extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String userId;
  @HiveField(2)
  late String title;
  @HiveField(3)
  late String status;
  @HiveField(4)
  String? modelHint;
  @HiveField(5)
  late int createdAtMs;
  @HiveField(6)
  late int updatedAtMs;
  @HiveField(7)
  int? lastUserTurnAtMs;
  @HiveField(8)
  late int messageCount;
}

class MessageHiveDto extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String threadId;
  @HiveField(2)
  late String role;
  @HiveField(3)
  late String contentType;
  @HiveField(4)
  String? contentText;
  @HiveField(5)
  late String state;
  @HiveField(6)
  late int tokenEstimate;
  @HiveField(7)
  late int createdAtMs;
  @HiveField(8)
  int? serverCreatedAtMs;
}

class PendingActionHiveDto extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String userId;
  @HiveField(2)
  late String type;
  @HiveField(3)
  late String payloadJson;
  @HiveField(4)
  late String status;
  @HiveField(5)
  late int retries;
  @HiveField(6)
  String? errorCode;
  @HiveField(7)
  late int createdAtMs;
  @HiveField(8)
  int? lastTriedMs;
}

class ThreadHiveDtoAdapter extends TypeAdapter<ThreadHiveDto> {
  @override
  final int typeId = 0;

  @override
  ThreadHiveDto read(BinaryReader reader) {
    final dto = ThreadHiveDto()
      ..id = reader.readString()
      ..userId = reader.readString()
      ..title = reader.readString()
      ..status = reader.readString()
      ..modelHint = reader.read() as String?
      ..createdAtMs = reader.readInt()
      ..updatedAtMs = reader.readInt()
      ..lastUserTurnAtMs = reader.read() as int?
      ..messageCount = reader.readInt();
    return dto;
  }

  @override
  void write(BinaryWriter writer, ThreadHiveDto obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.userId);
    writer.writeString(obj.title);
    writer.writeString(obj.status);
    writer.write(obj.modelHint);
    writer.writeInt(obj.createdAtMs);
    writer.writeInt(obj.updatedAtMs);
    writer.write(obj.lastUserTurnAtMs);
    writer.writeInt(obj.messageCount);
  }
}

class MessageHiveDtoAdapter extends TypeAdapter<MessageHiveDto> {
  @override
  final int typeId = 1;

  @override
  MessageHiveDto read(BinaryReader reader) {
    final dto = MessageHiveDto()
      ..id = reader.readString()
      ..threadId = reader.readString()
      ..role = reader.readString()
      ..contentType = reader.readString()
      ..contentText = reader.read() as String?
      ..state = reader.readString()
      ..tokenEstimate = reader.readInt()
      ..createdAtMs = reader.readInt()
      ..serverCreatedAtMs = reader.read() as int?;
    return dto;
  }

  @override
  void write(BinaryWriter writer, MessageHiveDto obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.threadId);
    writer.writeString(obj.role);
    writer.writeString(obj.contentType);
    writer.write(obj.contentText);
    writer.writeString(obj.state);
    writer.writeInt(obj.tokenEstimate);
    writer.writeInt(obj.createdAtMs);
    writer.write(obj.serverCreatedAtMs);
  }
}

class PendingActionHiveDtoAdapter extends TypeAdapter<PendingActionHiveDto> {
  @override
  final int typeId = 2;

  @override
  PendingActionHiveDto read(BinaryReader reader) {
    final dto = PendingActionHiveDto()
      ..id = reader.readString()
      ..userId = reader.readString()
      ..type = reader.readString()
      ..payloadJson = reader.readString()
      ..status = reader.readString()
      ..retries = reader.readInt()
      ..errorCode = reader.read() as String?
      ..createdAtMs = reader.readInt()
      ..lastTriedMs = reader.read() as int?;
    return dto;
  }

  @override
  void write(BinaryWriter writer, PendingActionHiveDto obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.userId);
    writer.writeString(obj.type);
    writer.writeString(obj.payloadJson);
    writer.writeString(obj.status);
    writer.writeInt(obj.retries);
    writer.write(obj.errorCode);
    writer.writeInt(obj.createdAtMs);
    writer.write(obj.lastTriedMs);
  }
}
