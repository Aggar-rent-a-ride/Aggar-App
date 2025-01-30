import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/authorization/presentation/views/page_view.dart';
import 'package:flutter/material.dart';

class SignInRegisterNowButton extends StatelessWidget {
  const SignInRegisterNowButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ScrollViewHome(),
          ),
        );
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        "Register now",
        style: AppStyles.medium18(context).copyWith(
          color: AppColors.myBlue100_1,
        ),
      ),
    );
  }
}
