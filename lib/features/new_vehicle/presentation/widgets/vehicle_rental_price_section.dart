import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_drop_down_list.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/rental_price_per_day_suffix_widget.dart';
import 'package:flutter/material.dart';

import '../../data/model/dropbown_button.dart' show vehicleStatus;

class VehicleRentalPriceSection extends StatelessWidget {
  const VehicleRentalPriceSection({
    super.key,
    required this.vehicleRentalPrice,
    required this.vehicleStatusController,
    this.onSavedStatus,
  });
  final TextEditingController vehicleRentalPrice;
  final TextEditingController vehicleStatusController;
  final void Function(String?)? onSavedStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Vehicle Rental Price :",
          style: AppStyles.bold22(context).copyWith(
            color: AppLightColors.myBlue100_2,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 25,
          children: [
            InputNameWithInputFieldSection(
              validator: (value) {
                if (value!.isEmpty) {
                  return "required";
                }
                return null;
              },
              controller: vehicleRentalPrice,
              label: "Rental Price per Day ",
              hintText: "ex: 2200",
              width: MediaQuery.sizeOf(context).width * 0.45,
              foundIcon: true,
              widget: const RentalPricePerDaySuffixWidget(),
            ),
            InputNameWithDropDownList(
              controller: vehicleStatusController,
              onSaved: onSavedStatus,
              items: vehicleStatus,
              hintTextSearch: "Search for Vehicle status",
              lableText: "status",
              hintText: "ex: active",
            ),
          ],
        )
      ],
    );
  }
}
