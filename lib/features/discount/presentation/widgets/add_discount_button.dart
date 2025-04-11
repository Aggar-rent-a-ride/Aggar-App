import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:flutter/material.dart';

class AddDiscountButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const AddDiscountButton({
    super.key,
    required this.onPressed,
    this.text = 'Add Discount',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppLightColors.myBlue100_5,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
      ),
      child: Text(text),
    );
  }
}
