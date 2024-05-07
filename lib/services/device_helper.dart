import '../data/read_data.dart';

class DeviceHelper {
  static String? _deviceId;
  static Future<String> get deviceId async {
    return _deviceId ??= await ReadData.getDeviceId();
  }
}
