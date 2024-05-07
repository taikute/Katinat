import 'package:email_otp/email_otp.dart';

class MailHelper {
  static void sendTest() async {
    final emailAuth = EmailOTP();
    emailAuth.setConfig(
      appName: 'KATINAT',
      appEmail: 'katinat@info.vn',
      userEmail: 'anhtai05102002@gmail.com',
    );
    emailAuth.sendOTP();
  }
}
