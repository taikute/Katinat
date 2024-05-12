import 'package:flutter/material.dart';
import '../services/color_manager.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double? width;
  final double height;
  const SecondaryButton({
    super.key,
    required this.text,
    this.onTap,
    this.width,
    this.height = 35,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: ColorManager.secondaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: FittedBox(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 30,
                height: 1,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
