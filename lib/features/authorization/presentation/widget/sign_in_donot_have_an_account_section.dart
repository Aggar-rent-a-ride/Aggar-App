import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_register_now_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SignInDonotHaveAnAccountSection extends StatelessWidget {
  const SignInDonotHaveAnAccountSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Gap(5),
        Text(
          "Don't have an account?",
          style: AppStyles.medium18(context).copyWith(
            color: AppColors.myBlack50,
          ),
        ),
        const SignInRegisterNowButton(),
      ],
    );
  }
}
