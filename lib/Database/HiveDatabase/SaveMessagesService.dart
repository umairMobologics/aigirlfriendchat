import 'package:agora_new_updated/models/MessageModel.dart';
import 'package:hive/hive.dart';

class SaveMessageService {
  static SaveMessageService? _instance;

  SaveMessageService._internal();

  factory SaveMessageService() {
    _instance ??= SaveMessageService._internal();
    return _instance!;
  }
  static SaveMessagesModel saveMessageObject(
      String sender, String message, bool isSender, String time) {
    return SaveMessagesModel(
        sender: sender, message: message, isSender: isSender, time: time);
  }

  static saveConversation(SaveMessagesModel message, String converdationID) {
    final box = Hive.box<Conversation>('conversations');
    Conversation? conversation = box.get(converdationID);

    if (conversation != null) {
      // Add the new message to the existing list of messages
      final updatedMessages =
          List<SaveMessagesModel>.from(conversation.messages);
      updatedMessages.add(message);
      // Make a copy of currentMessages before adding to avoid concurrent modification
      // conversation.save();
      box.put(
          converdationID,
          Conversation(
              conversationID: converdationID, messages: updatedMessages));
    } else {
      // Create a new conversation and save it
      box.put(
        converdationID,
        Conversation(
          conversationID: converdationID,
          messages: [message], // Create a new list to avoid future issues
        ),
      );
    }
  }

  //clear specific conversation
  static clearConversation(String converdationID) {
    final box = Hive.box<Conversation>('conversations');
    Conversation? conversation = box.get(converdationID);

    if (conversation != null) {
      // Clear the messages in the existing conversation
      box.put(
        converdationID,
        Conversation(
          conversationID: conversation.conversationID,
          messages: [], // Set messages to an empty list
        ),
      );
    }
  }
}
