import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart'
    show InputNameWithInputFieldSection;
import 'package:aggar/features/new_vehicle/presentation/widgets/seats_number_suffix_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart' show Gap;

class PickColorAndSeatsNumFields extends StatelessWidget {
  const PickColorAndSeatsNumFields({
    super.key,
    required this.vehicleColorController,
    required this.vehicleSeatsNoController,
  });
  final TextEditingController vehicleColorController;
  final TextEditingController vehicleSeatsNoController;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InputNameWithInputFieldSection(
          controller: vehicleColorController,
          hintText: "ex: red or C8C8C8",
          label: "color of vehicle",
          width: 150,
        ),
        const Gap(30),
        InputNameWithInputFieldSection(
          controller: vehicleSeatsNoController,
          width: 155,
          hintText: "ex: 6",
          label: "seats number ",
          foundIcon: true,
          widget: const SeatsNumberSuffixWidget(),
        ),
      ],
    );
  }
}
