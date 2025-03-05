import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/data/model/dropbown_button.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_drop_down_list.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart';
import 'package:flutter/material.dart';

class AboutVehicleSection extends StatelessWidget {
  const AboutVehicleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Vehicle :",
          style: AppStyles.bold22(context).copyWith(
            color: AppColors.myBlue100_2,
          ),
        ),
        Row(
          spacing: 20,
          children: [
            InputNameWithDropDownList(
              items: vehicleBrands,
              flag: true,
              hintTextSearch: "Search for vehicle brand ...",
              lableText: "brand",
              hintText: "ex: Tesla",
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            const InputNameWithInputFieldSection(
              hintText: "ex: model x",
              label: "model",
            ),
          ],
        ),
        Row(
          spacing: 20,
          children: [
            InputNameWithDropDownList(
              flag: true,
              items: vehicleTypes,
              hintTextSearch: "Search for vehicle type ...",
              lableText: "vehicle",
              hintText: "ex: car",
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            InputNameWithInputFieldSection(
              hintText: "ex: 1980",
              label: "year of manufacture",
              width: MediaQuery.of(context).size.width * 0.3,
            ),
          ],
        ),
      ],
    );
  }
}
