import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
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
    this.carHealthTextColor,
    this.carHealthContainerColor,
    this.carStatusTextColor,
    this.carStatusContainerColor,
    required this.vehicleType,
    this.style,
  });
  final String color;
  final String seatsno;
  final String overviewText;
  final String carHealth;
  final Color? carHealthTextColor;
  final Color? carHealthContainerColor;
  final String carStatus;
  final Color? carStatusTextColor;
  final Color? carStatusContainerColor;
  final String vehicleType;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "OverView",
              style: style ??
                  AppStyles.bold18(context).copyWith(
                    color: context.theme.gray100_3,
                  ),
            ),
          ],
        ),
        Text(
          "Experience our $vehicleType with $color color and its modern design. seating for $seatsno persons. With $carHealth physical status and currently it is $carStatus .\n$overviewText",
          style: AppStyles.medium15(context).copyWith(
            color: context.theme.black50,
          ),
        ),
        VehicleHealthWithStatusContainer(
          carHealth: carHealth,
          carHealthTextColor: carHealth == "excellent"
              ? AppConstants.myGreen100_1
              : carHealth == "good"
                  ? AppConstants.myBlue100_1
                  : carHealth == "not bad"
                      ? AppConstants.myYellow100_1
                      : AppConstants.myRed100_1,
          carHealthContainerColor: carHealth == "excellent"
              ? AppConstants.myGreen10_1
              : carHealth == "good"
                  ? AppConstants.myBlue100_1
                  : carHealth == "not bad"
                      ? AppConstants.myYellow10_1
                      : AppConstants.myRed10_1,
          carStatus: carStatus,
          carStatusTextColor: carStatus == "active"
              ? AppConstants.myGreen100_1
              : AppConstants.myRed100_1,
          carStatusContainerColor: carStatus == "active"
              ? AppConstants.myGreen10_1
              : AppConstants.myRed10_1,
        ),
      ],
    );
  }
}
