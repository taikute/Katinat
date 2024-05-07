import 'package:flutter/material.dart';

class CenterLoading extends StatelessWidget {
  final String? text;
  const CenterLoading({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(child: CircularProgressIndicator()),
        if (text != null) Text(text!)
      ],
    );
  }
}
