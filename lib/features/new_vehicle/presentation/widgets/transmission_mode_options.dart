// transmission_mode_options.dart
import 'package:aggar/features/new_vehicle/presentation/widgets/radio_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_light_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import '../../data/cubits/add_vehicle_cubit/add_vehicle_state.dart';

class TransmissionModeOptions extends StatelessWidget {
  const TransmissionModeOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddVehicleCubit, AddVehicleState>(
      buildWhen: (previous, current) => current is TransmissionModeUpdated,
      builder: (context, state) {
        final cubit = context.read<AddVehicleCubit>();
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "transmission mode :",
                style: AppStyles.medium18(context).copyWith(
                  color: AppLightColors.myBlue100_1,
                ),
              ),
            ),
            RadioButtons(
              selectedValue: cubit.selectedTransmissionModeValue,
              onChanged: (value) => cubit.setTransmissionMode(value),
            ),
          ],
        );
      },
    );
  }
}
