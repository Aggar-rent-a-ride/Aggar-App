import 'package:aggar/core/cubit/reportId/report_by_id_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/app_user_target_type_card.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_details_body.dart';
import 'package:flutter/material.dart';

class AppUserTargetType extends StatelessWidget {
  const AppUserTargetType({super.key, required this.state});
  final ReportByIdLoaded state;
  @override
  Widget build(BuildContext context) {
    return AppUserTargetTypeCard(
      id: state.report.targetAppUser!.id,
      imagePath: state.report.targetAppUser!.imagePath,
      name: state.report.targetAppUser!.name,
    );
  }
}
