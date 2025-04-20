import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/authorization/presentation/views/sign_up_view.dart';
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
            builder: (context) => const SignUpView(),
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
          color: context.theme.blue100_1,
        ),
      ),
    );
  }
}
