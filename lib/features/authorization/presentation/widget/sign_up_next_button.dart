import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class SignUpNextButton extends StatelessWidget {
  const SignUpNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      borderRadius: BorderRadius.circular(15),
      color: AppColors.myBlue100_1,
      width: MediaQuery.sizeOf(context).width * 0.8,
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          "Next",
          style: AppStyles.bold18(context).copyWith(
            color: AppColors.myWhite100_1,
          ),
        ),
      ),
    );
  }
}
