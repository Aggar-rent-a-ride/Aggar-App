import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart' show AppStyles;
import 'package:flutter/material.dart';

class BottomNavigationBarBookButton extends StatelessWidget {
  const BottomNavigationBarBookButton({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          ),
          overlayColor: WidgetStatePropertyAll(
            AppColors.myWhite50_1,
          ),
          backgroundColor: WidgetStatePropertyAll(
            AppColors.myBlue100_2,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          'Book Vehicle',
          style: AppStyles.bold18(context).copyWith(
            color: AppColors.myWhite100_1,
          ),
        ),
      ),
    );
  }
}
