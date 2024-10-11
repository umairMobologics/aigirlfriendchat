import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  // List to store the messages
  final List<Map<String, dynamic>> _messages = [];

  // Getter to access the messages
  List<Map<String, dynamic>> get messages => _messages;

  // Method to add a message
  void addMessage(String sender, String message, bool isSender, String time) {
    _messages.add({
      'sender': sender,
      'message': message,
      'isSender': isSender,
      'time': time,
    });
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
