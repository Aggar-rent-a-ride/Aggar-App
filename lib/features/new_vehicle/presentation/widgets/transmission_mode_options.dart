import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/edit_vehicle/edit_vehicle_state.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/radio_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show StatelessWidget;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../edit_vehicle/edit_vehicle_cubit.dart';

class TransmissionModeOptions extends StatelessWidget {
  const TransmissionModeOptions({
    super.key,
    this.isEditing = false,
    this.initialVehicleTransmissionMode,
  });
  final bool isEditing;
  final String? initialVehicleTransmissionMode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditVehicleCubit, EditVehicleState>(
      buildWhen: (previous, current) =>
          current is TransmissionModeEdited ||
          current is EditVehicleInitial ||
          current is EditVehicleDataLoaded,
      builder: (context, state) {
        if (isEditing &&
            initialVehicleTransmissionMode != null &&
            context.read<EditVehicleCubit>().selectedTransmissionModeValue ==
                null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final cubit = context.read<EditVehicleCubit>();
            if (cubit.selectedTransmissionModeValue == null) {
              cubit.setTransmissionMode(cubit
                  .getTransmissionModeValue(initialVehicleTransmissionMode!));
            }
          });
        }
        final selectedValue =
            context.read<EditVehicleCubit>().selectedTransmissionModeValue;
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
              selectedValue: selectedValue,
              onChanged: (value) {
                print("Transmission changed to: $value");
                context.read<EditVehicleCubit>().setTransmissionMode(value);
              },
            ),
          ],
        );
      },
    );
  }
}
