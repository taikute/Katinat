import 'package:email_otp/email_otp.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../services/color_manager.dart';
import '../../services/snack_bar_helper.dart';

class EmailVerifyPage extends StatefulWidget {
  final String email;
  final String phoneNumber;
  const EmailVerifyPage({
    super.key,
    required this.email,
    required this.phoneNumber,
  });

  @override
  State<EmailVerifyPage> createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  final otpController = TextEditingController();
  final emailAuth = EmailOTP();

  @override
  void initState() {
    super.initState();
    emailAuth.setConfig(
      appName: 'KATINAT',
      appEmail: 'katinat@otp.vn',
      userEmail: widget.email,
    );
    emailAuth.sendOTP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 3),
            const Text(
              'Email OTP',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 20),
            OtpTextField(
              showFieldAsBox: true,
              numberOfFields: 6,
              onSubmit: (inputOtp) async {
                if (await emailAuth.verifyOTP(otp: inputOtp)) {
                  await FirebaseDatabase.instance
                      .ref('users/${widget.phoneNumber}')
                      .update({'email': widget.email});
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/account');
                  SnackBarHelper.hideAndShowSimpleSnackBar(
                      context, 'Email verified!');
                } else {
                  if (!context.mounted) return;
                  SnackBarHelper.hideAndShowSimpleSnackBar(
                      context, 'Wrong otp!');
                }
              },
            ),
            TextButton(
              onPressed: () async {
                await emailAuth.sendOTP();
              },
              child: const Text(
                'Did not get the code?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: ColorManager.secondaryColor,
                  decorationColor: ColorManager.secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
