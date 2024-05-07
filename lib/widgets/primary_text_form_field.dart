import 'package:flutter/material.dart';

import '../services/color_manager.dart';

class PrimaryTextFormField extends StatelessWidget {
  const PrimaryTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            focusColor: ColorManager.primaryColor,
          ),
        ),
      ],
    );
  }
}
