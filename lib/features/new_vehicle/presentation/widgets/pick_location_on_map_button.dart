import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class PickLocationOnMapButton extends StatelessWidget {
  const PickLocationOnMapButton({
    super.key,
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColors.myBlack25,
            offset: const Offset(0, 0),
            blurRadius: 2,
          )
        ],
      ),
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.18,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          overlayColor: WidgetStateProperty.all(AppColors.myBlue50_2),
          backgroundColor: WidgetStateProperty.all(
            AppColors.myBlue100_8,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 25,
            ),
          ),
        ),
        child: Text(
          "Pick on Map",
          style: AppStyles.regular16(context).copyWith(
            color: AppColors.myBlue100_1,
          ),
        ),
      ),
    );
  }
}
