import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/color_and_seats_no_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart' show Gap;

class OverViewSection extends StatelessWidget {
  const OverViewSection({
    super.key,
    required this.color,
    required this.seatsno,
    required this.overviewText,
    required this.carHealth,
    required this.carStatus,
    required this.carHealthTextColor,
    required this.carHealthContainerColor,
    required this.carStatusTextColor,
    required this.carStatusContainerColor,
  });
  final String color;
  final String seatsno;
  final String overviewText;
  final String carHealth;
  final Color carHealthTextColor;
  final Color carHealthContainerColor;
  final String carStatus;
  final Color carStatusTextColor;
  final Color carStatusContainerColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "OverView",
              style: AppStyles.bold18(context).copyWith(
                color: AppColors.myGray100_3,
              ),
            ),
            const Spacer(),
            ColorAndSeatsNoSection(
              seatsNo: seatsno,
              color: color,
            )
          ],
        ),
        Text(
          overviewText,
          style: AppStyles.medium15(context).copyWith(
            color: AppColors.myBlack50,
          ),
        ),
        Row(
          children: [
            CustomContainer(
              text: carHealth,
              textColor: carHealthTextColor,
              containerColor: carHealthContainerColor,
            ),
            const Gap(10),
            CustomContainer(
              text: carStatus,
              textColor: carStatusTextColor,
              containerColor: carStatusContainerColor,
            ),
          ],
        ),
      ],
    );
  }
}
