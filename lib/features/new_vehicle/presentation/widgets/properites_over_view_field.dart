import 'package:aggar/features/new_vehicle/presentation/widgets/input_name_with_input_field_section.dart';
import 'package:flutter/material.dart';

class ProperitesOverViewField extends StatelessWidget {
  const ProperitesOverViewField({
    super.key,
    required this.vehicleOverviewController,
  });
  final TextEditingController vehicleOverviewController;
  @override
  Widget build(BuildContext context) {
    return InputNameWithInputFieldSection(
      label: "properties overview",
      hintText: "write in summary there properties",
      maxLines: 6,
      width: double.infinity,
      controller: vehicleOverviewController,
    );
  }
}
