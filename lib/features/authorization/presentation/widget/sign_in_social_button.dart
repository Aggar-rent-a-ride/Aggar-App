import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SignInSocialButton extends StatelessWidget {
  final Widget? icon;
  final String? imageIcon;
  final Color? color;
  final Color? textColor;
  final String text;

  const SignInSocialButton({
    this.icon,
    this.color,
    required this.text,
    super.key,
    this.imageIcon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: icon,
      label: Text(
        text,
        style: AppStyles.regular18(context).copyWith(
          color: textColor ?? AppConstants.myWhite100_1,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 23,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
