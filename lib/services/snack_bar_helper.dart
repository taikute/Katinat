import 'package:flutter/material.dart';
import 'color_manager.dart';

class SnackBarHelper {
  static void hideAndShowSimpleSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: ColorManager.secondaryColor,
      duration: const Duration(seconds: 1),
    ));
  }
}
