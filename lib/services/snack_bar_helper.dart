import 'package:flutter/material.dart';

class SnackBarHelper {
  static void hideAndShowSimpleSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }
}
