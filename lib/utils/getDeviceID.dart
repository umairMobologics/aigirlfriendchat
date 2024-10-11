import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';

class PlatformDeviceId {
  static Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("device ID is ****   :  ${androidInfo.id}");
    return androidInfo.id;
  }
}
