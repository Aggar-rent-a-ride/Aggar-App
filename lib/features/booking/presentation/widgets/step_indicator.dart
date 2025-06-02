import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StepIndicator extends StatelessWidget {
  final String title;
  final bool isActive;
  final int stepNumber;

  const StepIndicator({
    super.key,
    required this.title,
    this.isActive = true,
    this.stepNumber = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive ? AppConstants.myBlue100_3 : AppConstants.myBlack100_1.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isActive
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppConstants.myWhite100_1,
                      shape: BoxShape.circle,
                    ),
                  )
                : Text(
                    stepNumber.toString(),
                    style: AppStyles.semiBold12(context).copyWith(
                      color: AppConstants.myWhite100_1,
                    ),
                  ),
          ),
        ),
        const Gap(12),
        Text(
          title,
          style: AppStyles.semiBold16(context).copyWith(
            color: isActive ? AppConstants.myBlack100_1 : AppConstants.myBlack100_1.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}