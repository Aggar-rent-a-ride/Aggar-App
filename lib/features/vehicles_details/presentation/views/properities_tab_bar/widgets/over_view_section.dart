import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/color_and_seats_no_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/vehicle_health_with_status_container.dart';
import 'package:flutter/material.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "OverView",
              style: AppStyles.bold18(context).copyWith(
                color: AppLightColors.myGray100_3,
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
            color: AppLightColors.myBlack50,
          ),
        ),
        VehicleHealthWithStatusContainer(
          carHealth: carHealth,
          carHealthTextColor: carHealthTextColor,
          carHealthContainerColor: carHealthContainerColor,
          carStatus: carStatus,
          carStatusTextColor: carStatusTextColor,
          carStatusContainerColor: carStatusContainerColor,
        ),
      ],
    );
  }
}
