// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../services/color_manager.dart';

class SubmitWidget extends StatelessWidget {
  final String label;
  const SubmitWidget({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: ColorManager.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: FittedBox(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 30,
              height: 1,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
