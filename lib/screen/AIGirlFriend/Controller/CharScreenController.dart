import 'dart:developer';

import 'package:agora_new_updated/Database/HiveDatabase/SaveMessagesService.dart';
import 'package:agora_new_updated/Database/listGirlfriendDatabase.dart';
import 'package:agora_new_updated/models/MessageModel.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  //save message object
  SaveMessagesModel messageObject(
      String sender, String message, bool isSender, String time) {
    return SaveMessageService.saveMessageObject(
        sender, message, isSender, time);
  }

  ///save conversation to hive
  void saveMessageConversation(
      SaveMessagesModel message, String converdationID) {
    SaveMessageService.saveConversation(message, converdationID);
  }

  //clear specific conversation
  void clearConversation(String converdationID) {
    SaveMessageService.clearConversation(converdationID);
  }

  //clear specific conversation
  void deleteConversation(String converdationID) {
    SaveMessageService.deleteConversation(converdationID);
  }

  //delete girlfriend character from DB

  void deleteGirlfriend(String conversationID) async {
    int deletedCount =
        await GirlfriendDatabaseHelper().deleteGirlfriendByName(conversationID);

    if (deletedCount > 0) {
      log("Girlfriend entry deleted from the database.");
    } else {
      log("No entry found for deletion.");
    }
  }
}
