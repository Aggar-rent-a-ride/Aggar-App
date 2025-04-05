import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    this.onPressed,
    required this.action,
    required this.subtitle,
  });
  final String title;
  final String action;
  final String subtitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppLightColors.myWhite100_1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        title,
        style: AppStyles.semiBold24(context)
            .copyWith(color: AppLightColors.myBlack100),
      ),
      content: Text(
        subtitle,
        style: AppStyles.regular15(context).copyWith(
          color: AppLightColors.myBlack100,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: AppStyles.semiBold15(context).copyWith(
              color: AppLightColors.myBlue100_2,
            ),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            action,
            style: AppStyles.semiBold15(context).copyWith(
              color: AppLightColors.myRed100_1,
            ),
          ),
        ),
      ],
    );
  }
}
