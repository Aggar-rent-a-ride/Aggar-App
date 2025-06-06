import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_status_container.dart';
import 'package:flutter/material.dart';

class ReportTypewithStatus extends StatelessWidget {
  const ReportTypewithStatus({
    super.key,
    required this.targetType,
    required this.status,
  });
  final String targetType;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$targetType Report",
          style: AppStyles.bold24(context).copyWith(
            color: context.theme.black100,
          ),
          semanticsLabel: "$targetType Report",
        ),
        const Spacer(),
        ReportStatusContainer(
          statusText: status,
          containerColor: status == "Pending"
              ? AppConstants.myYellow10_1
              : status == "Rejected"
                  ? AppConstants.myRed10_1
                  : AppConstants.myGreen10_1,
          textColor: status == "Pending"
              ? AppConstants.myYellow100_1
              : status == "Rejected"
                  ? AppConstants.myRed100_1
                  : AppConstants.myGreen100_1,
        ),
      ],
    );
  }
}
