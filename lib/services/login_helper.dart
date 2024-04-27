import 'package:shared_preferences/shared_preferences.dart';

class LoginHelper {
  Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('isLogin') ?? false;
    if (isLogin) {}
    return isLogin;
  }
}
