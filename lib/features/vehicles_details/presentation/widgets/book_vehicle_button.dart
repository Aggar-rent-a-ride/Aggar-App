import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BookVehicleButton extends StatelessWidget {
  const BookVehicleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 8, left: 8, top: 2),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
          backgroundColor: WidgetStatePropertyAll(AppColors.myBlue100_2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          // TODO : style here want to change
          child: Text(
            'Book vehicle',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.myWhite100_1,
            ),
          ),
        ),
      ),
    );
  }
}
