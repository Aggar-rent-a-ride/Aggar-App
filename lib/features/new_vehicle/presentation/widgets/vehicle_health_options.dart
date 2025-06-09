import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_cubit.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_state.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_state.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/vehicle_health_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class VehicleHealthOptions extends StatefulWidget {
  final bool isEditing;
  final String? initialVehicleHealth;

  const VehicleHealthOptions({
    super.key,
    this.isEditing = false,
    this.initialVehicleHealth,
  });

  @override
  State<VehicleHealthOptions> createState() => _VehicleHealthOptionsState();
}

class _VehicleHealthOptionsState extends State<VehicleHealthOptions> {
  @override
  void initState() {
    super.initState();
    if (widget.isEditing &&
        widget.initialVehicleHealth != null &&
        context.read<EditVehicleCubit>().selectedVehicleHealthValue == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final healthValue = _mapHealthValueToUI(widget.initialVehicleHealth!);
        context.read<EditVehicleCubit>().setVehicleHealth(healthValue);
      });
    }
  }

  String _mapHealthValueToUI(String apiValue) {
    switch (apiValue) {
      case "Excellent":
        return "Excellent";
      case "Scratched":
        return "Minor dents";
      case "Good":
        return "Good";
      case "NotBad":
        return "Not bad";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Health",
          style: AppStyles.medium18(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        const Gap(10),
        if (widget.isEditing)
          _buildEditingMode(context)
        else
          _buildAddingMode(context),
      ],
    );
  }

  Widget _buildEditingMode(BuildContext context) {
    return BlocBuilder<EditVehicleCubit, EditVehicleState>(
      builder: (context, state) {
        final cubit = context.read<EditVehicleCubit>();
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
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        VehicleHealthButton(
                          text: 'Excellent',
                          isSelected: selectedValue == 'Excellent',
                          onPressed: (value) {
                            if (widget.isEditing) {
                              cubit.setVehicleHealth(value);
                            } else {
                              context
                                  .read<AddVehicleCubit>()
                                  .setVehicleHealth(value);
                            }
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 25),
                        VehicleHealthButton(
                          text: 'Minor dents',
                          isSelected: selectedValue == 'Minor dents',
                          onPressed: (value) {
                            if (widget.isEditing) {
                              cubit.setVehicleHealth(value);
                            } else {
                              context
                                  .read<AddVehicleCubit>()
                                  .setVehicleHealth(value);
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      children: [
                        VehicleHealthButton(
                          text: 'Good',
                          isSelected: selectedValue == 'Good',
                          onPressed: (value) {
                            if (widget.isEditing) {
                              cubit.setVehicleHealth(value);
                            } else {
                              context
                                  .read<AddVehicleCubit>()
                                  .setVehicleHealth(value);
                            }
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 25),
                        VehicleHealthButton(
                          text: 'Not bad',
                          isSelected: selectedValue == 'Not bad',
                          onPressed: (value) {
                            if (widget.isEditing) {
                              cubit.setVehicleHealth(value);
                            } else {
                              context
                                  .read<AddVehicleCubit>()
                                  .setVehicleHealth(value);
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    field.errorText!,
                    style: AppStyles.regular14(context).copyWith(
                      color: context.theme.red100_1,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddingMode(BuildContext context) {
    return BlocBuilder<AddVehicleCubit, AddVehicleState>(
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
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        VehicleHealthButton(
                          text: 'Excellent',
                          isSelected: selectedValue == 'Excellent',
                          onPressed: (value) {
                            cubit.setVehicleHealth(value);
                            field.didChange(value);
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 25),
                        VehicleHealthButton(
                          text: 'Minor dents',
                          isSelected: selectedValue == 'Minor dents',
                          onPressed: (value) {
                            cubit.setVehicleHealth(value);
                            field.didChange(value);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      children: [
                        VehicleHealthButton(
                          text: 'Good',
                          isSelected: selectedValue == 'Good',
                          onPressed: (value) {
                            cubit.setVehicleHealth(value);
                            field.didChange(value);
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 25),
                        VehicleHealthButton(
                          text: 'Not bad',
                          isSelected: selectedValue == 'Not bad',
                          onPressed: (value) {
                            cubit.setVehicleHealth(value);
                            field.didChange(value);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    field.errorText!,
                    style: AppStyles.regular14(context).copyWith(
                      color: context.theme.red100_1,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
