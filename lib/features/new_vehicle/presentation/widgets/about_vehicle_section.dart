import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_drop_down_list.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutVehicleSection extends StatelessWidget {
  const AboutVehicleSection({
    super.key,
    required this.modelController,
    required this.yearOfManufactureController,
    required this.vehicleBrandController,
    required this.vehicleTypeController,
    this.onSavedBrand,
    this.onSavedType,
    this.initialVehicleBrand,
    this.initialVehicleType,
    this.isEditing = false,
  });
  final TextEditingController modelController;
  final TextEditingController yearOfManufactureController;
  final TextEditingController vehicleBrandController;
  final TextEditingController vehicleTypeController;
  final void Function(String?)? onSavedBrand;
  final void Function(String?)? onSavedType;
  final String? initialVehicleBrand;
  final String? initialVehicleType;
  final bool? isEditing;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Vehicle :",
          style: AppStyles.bold22(context).copyWith(
            color: context.theme.blue100_2,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            InputNameWithDropDownList(
              onValueChanged: (value, id) {
                if (isEditing == true) {
                  context.read<EditVehicleCubit>().setVehicleBrand(value, id);
                } else {
                  context.read<AddVehicleCubit>().setVehicleBrnd(value, id);
                }
              },
              ids: context.watch<VehicleBrandCubit>().vehicleBrandIds,
              controller: vehicleBrandController,
              validator: (value) {
                if (value == null && isEditing == false) {
                  return "required";
                }
                return null;
              },
              items: context.watch<VehicleBrandCubit>().vehicleBrands,
              flag: true,
              hintTextSearch: "Search for vehicle brand ...",
              lableText: "brand",
              hintText: "ex: Tesla",
              initialValue: initialVehicleBrand,
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            InputNameWithInputFieldSection(
              width: MediaQuery.of(context).size.width * 0.4,
              controller: modelController,
              hintText: "ex: model x",
              label: "model",
            ),
          ],
        ),
        Row(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputNameWithDropDownList(
              onValueChanged: (value, id) {
                if (isEditing == true) {
                  context.read<EditVehicleCubit>().setVehicleType(value, id);
                } else {
                  context.read<AddVehicleCubit>().setVehicleType(value, id);
                }
              },
              controller: vehicleTypeController,
              validator: (value) {
                if (value == null && isEditing == false) {
                  return "required";
                }
                return null;
              },
              flag: true,
              items: context.watch<VehicleTypeCubit>().vehicleTypes,
              hintTextSearch: "Search for vehicle type ...",
              lableText: "vehicle",
              initialValue: initialVehicleType,
              hintText: "ex: car",
              width: MediaQuery.of(context).size.width * 0.4,
              ids: context.watch<VehicleTypeCubit>().vehicleTypeIds,
            ),
            InputNameWithInputFieldSection(
              validator: (value) {
                if (value!.isEmpty) {
                  return "required";
                }
                final year = int.tryParse(value);
                final currentYear = DateTime.now().year;
                if (year == null || year < 1900 || year > currentYear) {
                  return "from 1900 to $currentYear";
                }
                return null;
              },
              controller: yearOfManufactureController,
              hintText: "ex: 1980",
              label: "year of manufacture",
              width: MediaQuery.of(context).size.width * 0.4,
            ),
          ],
        ),
      ],
    );
  }
}
