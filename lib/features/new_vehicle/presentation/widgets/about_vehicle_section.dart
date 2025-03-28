import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/data/cubits/vehicle_type/vehicle_type_cubit.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_drop_down_list.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/cubits/vehicle_brand/vehicle_brand_cubit.dart';

class AboutVehicleSection extends StatefulWidget {
  const AboutVehicleSection({
    super.key,
    required this.modelController,
    required this.yearOfManufactureController,
    required this.vehicleBrandController,
    required this.vehicleTypeController,
    this.onSavedBrand,
    this.onSavedType,
  });
  final TextEditingController modelController;
  final TextEditingController yearOfManufactureController;
  final TextEditingController vehicleBrandController;
  final TextEditingController vehicleTypeController;
  final void Function(String?)? onSavedBrand;
  final void Function(String?)? onSavedType;

  @override
  State<AboutVehicleSection> createState() => _AboutVehicleSectionState();
}

class _AboutVehicleSectionState extends State<AboutVehicleSection> {
  @override
  void initState() {
    context.read<VehicleBrandCubit>().fetchVehicleBrands(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYwIiwianRpIjoiMWQ5NjNiMGItZTczYy00NGVmLWJmNDUtNWQxYjgxMTYxZWI4IiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMSIsInVpZCI6IjEwNjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0MzE3OTMyMywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.C0vOhjp1oNy3hukChswkszoJAJ0sFGdPObZ49p0iwk0");
    context.read<VehicleTypeCubit>().fetchVehicleTypes(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYwIiwianRpIjoiMWQ5NjNiMGItZTczYy00NGVmLWJmNDUtNWQxYjgxMTYxZWI4IiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMSIsInVpZCI6IjEwNjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0MzE3OTMyMywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.C0vOhjp1oNy3hukChswkszoJAJ0sFGdPObZ49p0iwk0");
    super.initState();
  }

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
              ids: context.watch<VehicleBrandCubit>().vehicleBrandIds,
              controller: widget.vehicleBrandController,
              onSaved: widget.onSavedBrand,
              validator: (value) {
                if (value == null) {
                  return "required";
                }
                return null;
              },
              items: context.watch<VehicleBrandCubit>().vehicleBrands,
              flag: true,
              hintTextSearch: "Search for vehicle brand ...",
              lableText: "brand",
              hintText: "ex: Tesla",
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            InputNameWithInputFieldSection(
              width: MediaQuery.of(context).size.width * 0.4,
              controller: widget.modelController,
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
              controller: widget.vehicleTypeController,
              onSaved: widget.onSavedType,
              validator: (value) {
                if (value == null) {
                  return "required";
                }
                return null;
              },
              flag: true,
              items: context.watch<VehicleTypeCubit>().vehicleTypes,
              hintTextSearch: "Search for vehicle type ...",
              lableText: "vehicle",
              hintText: "ex: car",
              width: MediaQuery.of(context).size.width * 0.4,
              ids: context.watch<VehicleTypeCubit>().vehicleTypeIds,
            ),
            InputNameWithInputFieldSection(
              validator: (value) {
                if (value!.isEmpty) {
                  return "required";
                }
                return null;
              },
              controller: widget.yearOfManufactureController,
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
