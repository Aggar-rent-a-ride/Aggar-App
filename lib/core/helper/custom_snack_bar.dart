import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

enum SnackBarType { success, warning, error }

SnackBar customSnackBar(
  BuildContext context,
  String title,
  String subtitle,
  SnackBarType type,
) {
  IconData icon;
  Color snackBarBackgroundColor;

  switch (type) {
    case SnackBarType.success:
      icon = Icons.check;
      snackBarBackgroundColor = AppConstants.myGreen100_2;
      break;
    case SnackBarType.warning:
      icon = Icons.warning;
      snackBarBackgroundColor = AppConstants.myYellow100_2;
      break;
    case SnackBarType.error:
      icon = Icons.close;
      snackBarBackgroundColor = AppConstants.myRed100_2;
      break;
  }

  return SnackBar(
    elevation: 1,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    content: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppConstants.myBlack100_1,
              ),
              top: BorderSide(
                color: AppConstants.myBlack100_1,
              ),
              right: BorderSide(
                color: AppConstants.myBlack100_1,
              ),
              left: BorderSide(
                color: AppConstants.myBlack100_1,
              ),
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppConstants.myBlack100_1,
            size: 16,
          ),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppStyles.medium18(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
              Text(
                subtitle,
                style: AppStyles.regular15(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          icon: Icon(
            Icons.close,
            color: context.theme.black100,
            size: 20,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    ),
    backgroundColor: snackBarBackgroundColor,
    duration: const Duration(seconds: 5),
  );
}
