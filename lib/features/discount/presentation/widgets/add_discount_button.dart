import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:flutter/material.dart';

class AddDiscountButton extends StatelessWidget {
  const AddDiscountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add Discount'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppLightColors.myBlue100_2,
          foregroundColor: AppLightColors.myWhite100_1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
