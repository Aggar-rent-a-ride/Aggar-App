import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/data/model/dropbown_button.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_drop_down_list.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/rental_price_per_day_suffix_widget.dart';
import 'package:flutter/widgets.dart';

class VehicleRentalPriceSection extends StatelessWidget {
  const VehicleRentalPriceSection({
    super.key,
    required this.vehicleRentalPrice,
    required this.vehicleStatusController,
    this.onSavedStatus,
    this.initialVehicleStatus,
    this.onStatusChanged,
    this.isEditing, // Add this callback
  });

  final TextEditingController vehicleRentalPrice;
  final TextEditingController vehicleStatusController;
  final void Function(String?)? onSavedStatus;
  final String? initialVehicleStatus;
  final bool? isEditing;
  final void Function(String value, int id)?
      onStatusChanged; // Add this callback

  @override
  Widget build(BuildContext context) {
    // Debug print to verify values
    print('Building VehicleRentalPriceSection with:');
    print('  vehicleStatusController.text: ${vehicleStatusController.text}');
    print('  initialVehicleStatus: $initialVehicleStatus');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10), // Replace spacing: 10 with SizedBox
        Text(
          "Vehicle Rental Price :",
          style: AppStyles.bold22(context).copyWith(
            color: AppLightColors.myBlue100_2,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              width: MediaQuery.of(context).size.width * 0.45,
              foundIcon: true,
              widget: const RentalPricePerDaySuffixWidget(),
            ),
            const SizedBox(width: 25), // Replace spacing: 25 with SizedBox
            InputNameWithDropDownList(
              controller: vehicleStatusController,
              onSaved: onSavedStatus,
              items: vehicleStatus,
              hintTextSearch: "Search for Vehicle status",
              lableText: "status",
              hintText: "ex: active",
              ids: const [1, 2], // IDs for active and out of stock
              initialValue: vehicleStatusController.text.isNotEmpty
                  ? vehicleStatusController.text
                  : initialVehicleStatus,
              onValueChanged: onStatusChanged,
              validator: (value) {
                if (value == null && isEditing == false) {
                  return "Status is required";
                }
                return null;
              },
            ),
          ],
        )
      ],
    );
  }
}
