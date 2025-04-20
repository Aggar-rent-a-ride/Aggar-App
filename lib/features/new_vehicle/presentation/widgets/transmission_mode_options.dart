import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_cubit.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_state.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_state.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/radio_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    if (isEditing) {
      return _buildEditingMode(context);
    } else {
      return _buildAddingMode(context);
    }
  }

  Widget _buildAddingMode(BuildContext context) {
    return BlocBuilder<AddVehicleCubit, AddVehicleState>(
      buildWhen: (previous, current) =>
          current is TransmissionModeUpdated || current is AddVehicleInitial,
      builder: (context, state) {
        final cubit = context.read<AddVehicleCubit>();
        final selectedValue = cubit.selectedTransmissionModeValue;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Transmission Mode:",
                style: AppStyles.medium18(context).copyWith(
                  color: context.theme.blue100_1,
                ),
              ),
            ),
            RadioButtons(
              selectedValue: selectedValue,
              onChanged: (value) {
                cubit.setTransmissionMode(value);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditingMode(BuildContext context) {
    return BlocBuilder<EditVehicleCubit, EditVehicleState>(
      buildWhen: (previous, current) =>
          current is TransmissionModeEdited ||
          current is EditVehicleInitial ||
          current is EditVehicleDataLoaded,
      builder: (context, state) {
        final cubit = context.read<EditVehicleCubit>();

        if (initialVehicleTransmissionMode != null &&
            cubit.selectedTransmissionModeValue == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (cubit.selectedTransmissionModeValue == null) {
              cubit.setTransmissionMode(cubit
                  .getTransmissionModeValue(initialVehicleTransmissionMode!));
            }
          });
        }

        final selectedValue = cubit.selectedTransmissionModeValue;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Transmission Mode:",
                style: AppStyles.medium18(context).copyWith(
                  color: context.theme.blue100_1,
                ),
              ),
            ),
            RadioButtons(
              selectedValue: selectedValue,
              onChanged: (value) {
                if (isEditing == true) {
                  context.read<EditVehicleCubit>().setTransmissionMode(value);
                } else {
                  context.read<AddVehicleCubit>().setTransmissionMode(value);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
