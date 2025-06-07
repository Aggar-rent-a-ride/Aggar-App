import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/vehicle_brands_section.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/vehicle_types_section.dart';
import 'package:flutter/material.dart';

class VehicleSettingsBody extends StatelessWidget {
  const VehicleSettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [VehicleTypesSection(), VehicleBrandsSection()],
      ),
    );
  }
}
