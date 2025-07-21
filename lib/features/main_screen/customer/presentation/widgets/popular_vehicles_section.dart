import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/vehicle_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../core/utils/app_styles.dart';

class PopularVehiclesSection extends StatelessWidget {
  const PopularVehiclesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'All Vehicles',
              style: AppStyles.bold24(
                context,
              ).copyWith(color: context.theme.blue100_5),
            ),
            const Spacer(),
          ],
        ),
        const Gap(5),
        const VehicleList(),
      ],
    );
  }
}
