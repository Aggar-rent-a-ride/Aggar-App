import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarContent extends StatelessWidget {
  const BottomNavigationBarContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.myWhite100_1,
        boxShadow: [
          BoxShadow(
            color: AppColors.myBlack10,
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
              AppColors.myWhite50_1,
            ),
            backgroundColor: WidgetStatePropertyAll(
              AppColors.myBlue100_2,
            ),
          ),
          onPressed: () {},
          child: Text(
            'Add Vehicle',
            style: AppStyles.bold20(context).copyWith(
              color: AppColors.myWhite100_1,
            ),
          ),
        ),
      ),
    );
  }
}
