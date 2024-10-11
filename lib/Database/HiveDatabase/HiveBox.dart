import 'package:agora_new_updated/models/MessageModel.dart';
import 'package:hive/hive.dart';

class HiveBox {
  static String message = 'messages';

  static Future<void> initHive() async {
    await Hive.openBox<SaveMessagesModel>(message);
  }
}
