import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PriceWithTransmissionWithDistanceRow extends StatelessWidget {
  const PriceWithTransmissionWithDistanceRow({
    super.key,
    required this.pricePerDay,
    required this.transmission,
    required this.distance,
  });

  final String pricePerDay;
  final String transmission;
  final num distance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Row(
          children: [
            Icon(
              Icons.monetization_on_outlined,
              size: 16,
              color: context.theme.black50,
            ),
            const Gap(4),
            Text(
              "$pricePerDay/day",
              style: AppStyles.semiBold16(context)
                  .copyWith(color: context.theme.black50),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.speed_outlined,
              size: 16,
              color: context.theme.black50,
            ),
            const Gap(4),
            Text(
              "$transmission Transmission",
              style: AppStyles.semiBold16(context).copyWith(
                color: context.theme.black50,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 16,
              color: context.theme.black50,
            ),
            const Gap(4),
            Text(
              "Distance: ${distance.toString()} km",
              style: AppStyles.semiBold16(context)
                  .copyWith(color: context.theme.black50),
            ),
          ],
        )
      ],
    );
  }
}
