import 'package:aggar/core/extensions/context_colors_extension.dart';
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
        Text(
          "Have an account?",
          style: AppStyles.medium18(context).copyWith(
            color: context.theme.black50,
          ),
        ),
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
              color: context.theme.blue100_1,
            ),
          ),
        ),
      ],
    );
  }
}
