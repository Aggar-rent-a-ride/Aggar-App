import 'package:aggar/core/themes/app_light_colors.dart';
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
            color: AppLightColors.myBlue100_1,
          ),
        ),
        const Gap(10),
        BlocBuilder<AddVehicleCubit, AddVehicleState>(
          builder: (context, state) {
            final cubit = context.read<AddVehicleCubit>();
            final selectedValue = cubit.selectedVehicleHealthValue;
            return FormField(
              validator: (value) {
                if (selectedValue == null || selectedValue.isEmpty) {
                  return 'required';
                }
                return null;
              },
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 25,
                    children: [
                      Column(
                        spacing: 25,
                        children: [
                          VehicleHealthButton(
                            text: 'Excellent',
                            isSelected: selectedValue == 'Excellent',
                            onPressed: (value) => cubit.setVehicleHealth(value),
                          ),
                          VehicleHealthButton(
                            text: 'Minor dents',
                            isSelected: selectedValue == 'Minor dents',
                            onPressed: (value) => cubit.setVehicleHealth(value),
                          ),
                        ],
                      ),
                      Column(
                        spacing: 25,
                        children: [
                          VehicleHealthButton(
                            text: 'Good',
                            isSelected: selectedValue == 'Good',
                            onPressed: (value) => cubit.setVehicleHealth(value),
                          ),
                          VehicleHealthButton(
                            text: 'Not bad',
                            isSelected: selectedValue == 'Not bad',
                            onPressed: (value) => cubit.setVehicleHealth(value),
                          ),
                        ],
                      )
                    ],
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        field.errorText!,
                        style: AppStyles.regular14(context).copyWith(
                          color: AppLightColors.myRed100_1,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
