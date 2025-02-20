import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart'
    show InputNameWithInputFieldSection;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart' show Gap;

class PickColorAndSeatsNumFields extends StatelessWidget {
  const PickColorAndSeatsNumFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        InputNameWithInputFieldSection(
          hintText: "ex: red or C8C8C8",
          label: "color of vehicle",
          width: 150,
        ),
        Gap(30),
        InputNameWithInputFieldSection(
          width: 155,
          hintText: "ex: 6",
          label: "seats number ",
          foundIcon: true,
          widget: SeatsNumberSuffixWidget(),
        ),
      ],
    );
  }
}

class SeatsNumberSuffixWidget extends StatelessWidget {
  const SeatsNumberSuffixWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1,
            color: AppColors.myBlack50,
          ),
        ),
      ),
      child: Text(
        "person",
        style: AppStyles.medium15(context).copyWith(
          color: AppColors.myBlack50,
        ),
      ),
    );
  }
}
