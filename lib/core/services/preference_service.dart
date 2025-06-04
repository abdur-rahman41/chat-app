

import 'package:get_storage/get_storage.dart';

class PreferenceManager {
  static final box = GetStorage();

  static void writeData({required String key, required dynamic value}) =>
      box.write(key, value);

  static dynamic readData({required String key}) => box.read(key);

  static void removeData({required String key}) => box.remove(key);
}

class PrefKey {
  static const userID = "";
  static const token = "";
  static var LOGIN_VALUE = 'login-value';
  static var PASS = 'login-pass';
  static var SESSION = 'login-session';
  static var IS_REMEMBER = 'is-remember';
  static var DEVICE_UNIQUE = 'device-unique';
}