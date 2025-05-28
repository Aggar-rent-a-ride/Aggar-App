import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/widgets/see_more_button.dart';
import 'package:aggar/features/main_screen/customer/presentation/views/all_vehicle_screen.dart';
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
              'Popular vehicles',
              style: AppStyles.bold24(context).copyWith(
                color: context.theme.blue100_5,
              ),
            ),
            const Spacer(),
            SeeMoreButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllVehicleScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        const Gap(5),
        const VehicleList()
      ],
    );
  }
}
