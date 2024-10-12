import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part "MessageModel.g.dart";

@HiveType(typeId: 0)
class SaveMessagesModel extends HiveObject {
  @HiveField(0)
  String? sender;

  @HiveField(1)
  String? message;

  @HiveField(2)
  bool? isSender;

  @HiveField(3)
  String? time;

  SaveMessagesModel({
    this.sender,
    this.message,
    this.isSender,
    this.time,
  });
}

@HiveType(typeId: 1)
class Conversation extends HiveObject {
  @HiveField(0)
  String conversationID;

  @HiveField(1)
  List<SaveMessagesModel> messages;

  Conversation({
    required this.conversationID,
    required this.messages,
  });
}
