import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class PopularVehicleCarCardPrice extends StatelessWidget {
  const PopularVehicleCarCardPrice({
    super.key,
    required this.pricePerHour,
  });

  final String pricePerHour;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '\$$pricePerHour',
          style: AppStyles.semiBold24(context).copyWith(
            color: context.theme.blue100_2,
          ),
        ),
        Text(
          "/hr",
          style: AppStyles.regular15(context).copyWith(
            color: context.theme.blue50_2,
          ),
        ),
      ],
    );
  }
}
