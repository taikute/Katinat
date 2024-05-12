import 'package:email_otp/email_otp.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../../widgets/primary_button.dart';

import '../../services/color_manager.dart';
import '../../services/snack_bar_helper.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool passwordVisible = false;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final emailAuth = EmailOTP();
  bool showOtpTextField = false;
  bool isVerify = false;
  late String phoneNumber;
  late String email;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isVerify,
      replacement: Scaffold(
        appBar: AppBar(
          title: const Text('Enter new password'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !passwordVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              text: 'Update password',
              onTap: () async {
                final password = passwordController.text;
                if (password.isEmpty) {
                  SnackBarHelper.hideAndShowSimpleSnackBar(
                      context, 'Enter password!');
                  return;
                }
                final userRef = FirebaseDatabase.instance.ref('users');
                await userRef.update({'password': password});
                if (!context.mounted) return;
                SnackBarHelper.hideAndShowSimpleSnackBar(
                    context, 'Update successful!');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Enter email'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: showOtpTextField,
              replacement: PrimaryButton(
                text: 'Send OTP',
                onTap: () async {
                  email = emailController.text;
                  if (email.isEmpty) {
                    SnackBarHelper.hideAndShowSimpleSnackBar(
                        context, 'Enter email!');
                    return;
                  }
                  if (!EmailValidator.validate(email)) {
                    SnackBarHelper.hideAndShowSimpleSnackBar(
                        context, 'Email invalid!');
                    return;
                  }
                  final userRef =
                      FirebaseDatabase.instance.ref('users/$phoneNumber');
                  final userSnapshot = await userRef.get();
                  bool isContain = false;
                  for (final userChildSnapshot in userSnapshot.children) {
                    final emailSnapshot = userChildSnapshot.child('email');
                    if (emailSnapshot.exists) {
                      phoneNumber = userChildSnapshot.key!;
                      final emailValue = emailSnapshot.value! as String;
                      if (emailValue != email) {
                        continue;
                      }
                      emailAuth.setConfig(
                        appName: 'KATINAT',
                        appEmail: 'katinat@otp.vn',
                        userEmail: emailValue,
                      );
                      emailAuth.sendOTP();
                      isContain = true;
                      setState(() {
                        showOtpTextField = true;
                      });
                      break;
                    }
                  }
                  if (!isContain) {
                    if (!context.mounted) return;
                    SnackBarHelper.hideAndShowSimpleSnackBar(
                        context, 'Email not exists!');
                    return;
                  }
                },
              ),
              child: Column(
                children: [
                  FittedBox(
                    child: Center(
                      child: OtpTextField(
                        showFieldAsBox: true,
                        numberOfFields: 6,
                        onSubmit: (inputOtp) async {
                          if (await emailAuth.verifyOTP(otp: inputOtp)) {
                            setState(() {
                              isVerify = true;
                            });
                            return;
                          } else {
                            if (!context.mounted) return;
                            SnackBarHelper.hideAndShowSimpleSnackBar(
                                context, 'Wrong otp!');
                          }
                        },
                      ),
                    ),
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
          ],
        ),
      ),
    );
  }
}
