import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart' show Gap;

class VehicleHealthWithStatusContainer extends StatelessWidget {
  const VehicleHealthWithStatusContainer({
    super.key,
    required this.carHealth,
    required this.carHealthTextColor,
    required this.carHealthContainerColor,
    required this.carStatus,
    required this.carStatusTextColor,
    required this.carStatusContainerColor,
  });

  final String carHealth;
  final Color carHealthTextColor;
  final Color carHealthContainerColor;
  final String carStatus;
  final Color carStatusTextColor;
  final Color carStatusContainerColor;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
