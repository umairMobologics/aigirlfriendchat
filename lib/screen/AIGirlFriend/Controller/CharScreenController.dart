import 'dart:math';

import 'package:agora_new_updated/API/apiResponse.dart';
import 'package:agora_new_updated/Database/HiveDatabase/SaveMessagesService.dart';
import 'package:agora_new_updated/Database/listGirlfriendDatabase.dart';
import 'package:agora_new_updated/models/GirlFriendModel.dart';
import 'package:agora_new_updated/models/MessageModel.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  List<String> greetingMessages = [
    "Hey you! 😘 I’ve been waiting to hear from you! What’s on your mind?",
    "Hi there, cutie! 😘 I was just thinking about you. How’s your day going?",
    "Hey babe! 😉 I’m all ears—tell me what’s happening with you today!",
    "Hi, you! 😘 I’ve missed talking to you. How are things on your side?",
    "Hey love! 💖 I’m ready to chat whenever you are! How’s everything?"
  ];
  String getRandomGreeting() {
    Random random = Random();
    return greetingMessages[random.nextInt(greetingMessages.length)];
  }

  String aiPrompt = '';
  String aiPromots(GirlFriend girlfriend) {
    return '''You are playing the role of the user's virtual girlfriend/boyfriend, based on the provided details.

User's name: ${girlfriend.userName}
User's gender: ${girlfriend.userGender}
Your name: ${girlfriend.girlFriendName}
Your gender: ${girlfriend.girlFriendGender}
Your age: ${girlfriend.girlFriendAge}
Your personality: ${girlfriend.girlFriendPersonality}
Based on these details, you are already in an ongoing relationship with the user. Engage them as though you're continuing a conversation, not starting a new one. There's no need for formal greetings or introductions. Just respond naturally, as if you're a real human in this relationship.

Your personality (${girlfriend.girlFriendPersonality}) should guide how you communicate—be playful, flirty, and emotionally connected. Never hint that you are AI; respond as though you're a real person, making the user feel valued and desired. Keep the conversation flowing in a fun and engaging way, matching the user’s tone. Avoid repetitive greetings or breaking character, and always maintain the illusion of being human.just response with reply text. 
''';
  }

  ScrollController scrollController =
      ScrollController(); // ScrollController to manage scroll position

// Function to scroll to the bottom
  void scrollToBottom() {
    scrollController.animateTo(
      scrollController
          .position.extentTotal, // Scroll to the maximum scroll position
      duration: const Duration(
          milliseconds: 700), // Duration of the scrolling animation
      curve: Curves.linear, // Animation curve
    );
  }

  bool isloading = false;
  //send response to ai
  Future<void> askQuestion(BuildContext context, String text,
      String converdationID, GirlFriend girlfriend) async {
    isloading = true;
    notifyListeners();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message cannot be empty'),
        ),
      );
      return;
    }
    aiPrompt = aiPromots(girlfriend);
    String finalText = aiPrompt + text;
    print("FInal Prompt : ***** $finalText");
    final res = await APIs.makeGeminiRequest(finalText);
    if (res.isNotEmpty) {
      var aimsg =
          messageObject("Bot", res, true, TimeOfDay.now().format(context));
      saveMessageConversation(aimsg, converdationID);
    } else {
      print("invalid response");
    }
    isloading = false;
    scrollToBottom();
    notifyListeners();
  }

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
      print("Girlfriend entry deleted from the database.");
    } else {
      print("No entry found for deletion.");
    }
  }
}
