import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NoVehilceFoundBody extends StatelessWidget {
  const NoVehilceFoundBody({
    super.key,
    required this.cubit,
  });

  final VehicleCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 80,
            color: context.theme.grey100_1,
          ),
          const Gap(28),
          Text(
            "No vehicles available",
            style: AppStyles.bold20(context).copyWith(
              color: context.theme.black100,
            ),
          ),
          const Gap(8),
          Text(
            "We couldn't find any vehicles at the moment.\nPlease try again later.",
            style: AppStyles.regular16(context).copyWith(
              color: context.theme.grey100_1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
