import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart'
    show InputNameWithInputFieldSection;
import 'package:aggar/features/new_vehicle/presentation/widgets/seats_number_suffix_widget.dart';
import 'package:flutter/material.dart';

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
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputNameWithInputFieldSection(
          validator: (value) {
            if (value!.isEmpty) {
              return "required";
            }
            return null;
          },
          controller: vehicleColorController,
          hintText: "ex: red or C8C8C8",
          label: "color of vehicle",
          width: MediaQuery.of(context).size.width * 0.4,
        ),
        InputNameWithInputFieldSection(
          validator: (value) {
            if (value!.isEmpty) {
              return "required";
            }
            return null;
          },
          controller: vehicleSeatsNoController,
          width: MediaQuery.of(context).size.width * 0.4,
          hintText: "ex: 6",
          label: "seats number ",
          foundIcon: true,
          widget: const SeatsNumberSuffixWidget(),
        ),
      ],
    );
  }
}
