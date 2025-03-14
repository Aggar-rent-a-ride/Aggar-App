import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_health_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import '../../data/cubits/add_vehicle_cubit/add_vehicle_state.dart';

class VehicleHealthOptions extends StatelessWidget {
  const VehicleHealthOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Health",
          style: AppStyles.medium18(context).copyWith(
            color: AppColors.myBlue100_1,
          ),
        ),
        const Gap(10),
        BlocBuilder<AddVehicleCubit, AddVehicleState>(
          // Use a builder function that doesn't depend on specific state types
          builder: (context, state) {
            // Get the latest value from the cubit directly
            final cubit = context.read<AddVehicleCubit>();
            final selectedValue = cubit.selectedVehicleHealthValue;

            return Row(
              children: [
                Column(
                  children: [
                    VehicleHealthButton(
                      text: 'Excellent',
                      isSelected: selectedValue == 'Excellent',
                      onPressed: (value) => cubit.setVehicleHealth(value),
                    ),
                    const Gap(25),
                    VehicleHealthButton(
                      text: 'Minor dents',
                      isSelected: selectedValue == 'Minor dents',
                      onPressed: (value) => cubit.setVehicleHealth(value),
                    ),
                  ],
                ),
                const SizedBox(width: 25),
                Column(
                  children: [
                    VehicleHealthButton(
                      text: 'Good',
                      isSelected: selectedValue == 'Good',
                      onPressed: (value) => cubit.setVehicleHealth(value),
                    ),
                    const Gap(25),
                    VehicleHealthButton(
                      text: 'Not bad',
                      isSelected: selectedValue == 'Not bad',
                      onPressed: (value) => cubit.setVehicleHealth(value),
                    ),
                  ],
                )
              ],
            );
          },
        )
      ],
    );
  }
}
