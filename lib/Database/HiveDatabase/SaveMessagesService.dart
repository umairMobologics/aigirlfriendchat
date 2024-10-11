import 'package:agora_new_updated/Database/HiveDatabase/HiveBox.dart';
import 'package:agora_new_updated/models/MessageModel.dart';
import 'package:hive/hive.dart';

class SaveMessageService {
  static SaveMessageService? _instance;

  SaveMessageService._internal();

  factory SaveMessageService() {
    _instance ??= SaveMessageService._internal();
    return _instance!;
  }

  /// for getting all data
  static Box<SaveMessagesModel> getAllmessages() =>
      Hive.box<SaveMessagesModel>(HiveBox.message);

  /// Function that will add items in shopping cart
  static addMessage({
    required String sender,
    required String message,
    required bool isSender,
    required String time,
  }) {
    SaveMessagesModel data = SaveMessagesModel(
      sender: sender,
      message: message,
      isSender: isSender,
      time: time,
    );
    final box = getAllmessages();
    box.add(data);
    data.save();
  }
}
