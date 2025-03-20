import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarContent extends StatelessWidget {
  const BottomNavigationBarContent({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppLightColors.myWhite100_1,
        boxShadow: [
          BoxShadow(
            color: AppLightColors.myBlack10,
            offset: const Offset(0, -1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              AppLightColors.myWhite50_1,
            ),
            backgroundColor: WidgetStatePropertyAll(
              AppLightColors.myBlue100_2,
            ),
          ),
          onPressed: onPressed,
          child: Text(
            'Add Vehicle',
            style: AppStyles.bold20(context).copyWith(
              color: AppLightColors.myWhite100_1,
            ),
          ),
        ),
      ),
    );
  }
}
