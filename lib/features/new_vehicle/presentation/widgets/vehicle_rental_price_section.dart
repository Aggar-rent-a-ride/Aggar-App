import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/rental_price_per_day_suffix_widget.dart';
import 'package:flutter/material.dart';

class VehicleRentalPriceSection extends StatelessWidget {
  const VehicleRentalPriceSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Vehicle Properties : ",
          style: AppStyles.bold22(context).copyWith(
            color: AppColors.myBlue100_2,
          ),
        ),
        const Row(
          children: [
            Expanded(
              child: InputNameWithInputFieldSection(
                label: "Rental Price per Day ",
                hintText: "ex: 2200",
                width: double.infinity,
                foundIcon: true,
                widget: RentalPricePerDaySuffixWidget(),
              ),
            ),
          ],
        )
      ],
    );
  }
}
