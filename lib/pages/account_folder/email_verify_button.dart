import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../services/color_manager.dart';
import '../../services/snack_bar_helper.dart';
import 'email_verify_page.dart';

class EmailVerifyButton extends StatelessWidget {
  final String email;
  final String phoneNumber;

  const EmailVerifyButton({
    super.key,
    required this.email,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (email.isEmpty) {
          SnackBarHelper.hideAndShowSimpleSnackBar(context, 'Enter email!');
          return;
        }
        if (!EmailValidator.validate(email)) {
          SnackBarHelper.hideAndShowSimpleSnackBar(context, 'Email invalid!');
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerifyPage(
              email: email,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      },
      child: const Text(
        'Verify',
        style: TextStyle(
          color: ColorManager.secondaryColor,
          decoration: TextDecoration.underline,
          decorationColor: ColorManager.secondaryColor,
        ),
      ),
    );
  }
}
