import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class VehicleHealthButton extends StatelessWidget {
  const VehicleHealthButton({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: AppColors.myBlack25,
            blurRadius: 4,
          )
        ],
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
          text,
          style: AppStyles.semiBold16(context).copyWith(
            color: AppColors.myWhite100_1,
          ),
        ),
      ),
    );
  }
}
