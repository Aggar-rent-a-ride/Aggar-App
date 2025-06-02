import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final Widget? trailing;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppConstants.myBlack100_1,
            size: 20,
          ),
          onPressed: onBackPressed ?? () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyles.semiBold18(context).copyWith(
              color: AppConstants.myBlack100_1,
            ),
          ),
        ),
        trailing ?? const Gap(24),
      ],
    );
  }
}