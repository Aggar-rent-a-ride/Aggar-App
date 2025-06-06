import 'package:aggar/core/cubit/reportId/report_by_id_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/vehicle_target_type_card.dart';
import 'package:flutter/material.dart';

class VehicleTargetType extends StatelessWidget {
  const VehicleTargetType({
    super.key,
    required this.state,
  });
  final ReportByIdLoaded state;
  @override
  Widget build(BuildContext context) {
    return VehicleTargetTypeCard(
      distance: state.report.targetvehicle!.distance,
      id: state.report.targetvehicle!.id,
      imagePath: state.report.targetvehicle!.mainImagePath,
      model: state.report.targetvehicle!.model,
      pricePerDay: state.report.targetvehicle!.pricePerDay.toString(),
      transmission: state.report.targetvehicle!.transmission,
      year: state.report.targetvehicle!.year,
    );
  }
}
