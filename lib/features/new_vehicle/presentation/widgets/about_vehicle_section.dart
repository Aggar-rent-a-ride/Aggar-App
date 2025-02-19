import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AboutVehicleSection extends StatelessWidget {
  const AboutVehicleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Vehicle :",
          style: AppStyles.bold22(context).copyWith(
            color: AppColors.myBlue100_2,
          ),
        ),
        const Row(
          children: [
            InputNameWithInputFieldSection(
              hintText: "ex: Toyota",
              label: "brand",
            ),
            Gap(10),
            InputNameWithInputFieldSection(
              hintText: "ex: model x",
              label: "model",
            ),
          ],
        ),
        const Gap(10),
        Row(
          children: [
            const InputNameWithInputFieldSection(
              hintText: "ex: car",
              label: "vehicle",
            ),
            const Gap(10),
            InputNameWithInputFieldSection(
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
