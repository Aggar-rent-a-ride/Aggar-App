import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_up_all_fields.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_up_have_an_account_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Let's sign you up",
              style: AppStyles.bold28(context),
            ),
            const SignUpAllFields(),
            const Gap(25),
            CustomElevatedButton(onPressed: () {}, text: "Next"),
            const Gap(5),
            const SignUpHaveAnAccountSection(),
          ],
        ),
      ),
    );
  }
}
