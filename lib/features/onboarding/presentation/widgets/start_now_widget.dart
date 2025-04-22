import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StartNowWidget extends StatelessWidget {
  const StartNowWidget({
    super.key,
    required this.controller,
  });

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
        ),
        foregroundColor: WidgetStatePropertyAll(
          context.theme.white100_1,
        ),
        backgroundColor: WidgetStatePropertyAll(
          context.theme.blue100_1,
        ),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInView(),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Start Now",
            style: AppStyles.bold20(context).copyWith(
              color: AppConstants.myWhite100_1,
            ),
          ),
          const Gap(8),
          Icon(
            Icons.arrow_forward_rounded,
            color: AppConstants.myWhite100_1,
            size: 15,
          ),
        ],
      ),
    );
  }
}
