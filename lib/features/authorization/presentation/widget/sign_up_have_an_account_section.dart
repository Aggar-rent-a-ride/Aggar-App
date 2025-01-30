import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SignUpHaveAnAccountSection extends StatelessWidget {
  const SignUpHaveAnAccountSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Login now",
            style: AppStyles.medium18(context).copyWith(
              color: AppColors.myBlue100_1,
            ),
          ),
        ),
      ],
    );
  }
}
