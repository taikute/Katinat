import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'device_helper.dart';
import 'phone_number_validate.dart';
import 'prefs_helper.dart';

class LoginHelper {
  static Future<String?> signUpCheck(
    String phoneNumber,
    String password,
    String passwordConfirm,
  ) async {
    if (password != passwordConfirm) {
      return 'Incorrect password confirm!';
    }
    final isValid = await PhoneNumberValidate.isValid(phoneNumber);
    if (!isValid) {
      return 'Phone number is not valid!';
    }
    final userRef = FirebaseDatabase.instance.ref('users/$phoneNumber');
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      return 'Phone number is exists!';
    }
    return null;
  }

  static Future<String?> loginCheck(
    String phoneNumber,
    String password,
  ) async {
    final userRef = FirebaseDatabase.instance.ref('users/$phoneNumber');
    final userSnapshot = await userRef.get();
    if (!userSnapshot.exists) {
      return 'Phone number has not been registered!';
    }
    final jsonUser = userSnapshot.value! as Map;
    if (password != jsonUser['password']) {
      return 'Password incorrect!';
    }
    // Check if user login on a new device ...
    return null;
  }

  static Future<UserModel?> get curUser async {
    final prefs = await SharedPreferences.getInstance();
    final loginToken = prefs.getString(PrefsHelper.loginToken);
    if (loginToken == null) {
      return null;
    }
    final phoneNumber = JWT.decode(loginToken).payload as String;
    final userRef = FirebaseDatabase.instance.ref('users/$phoneNumber');
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      final deviceId = await DeviceHelper.deviceId;
      final userMap = userSnapshot.value as Map;
      if (userMap['device_id'] == deviceId) {
        return UserModel.fromSnapshot(userSnapshot);
      }
    }
    prefs.remove(PrefsHelper.loginToken);
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(PrefsHelper.loginToken);
  }
}
