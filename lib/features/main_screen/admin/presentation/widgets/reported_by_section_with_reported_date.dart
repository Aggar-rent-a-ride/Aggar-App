import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/reported_by_section.dart';
import 'package:flutter/material.dart';

class ReportedBySectionWithReportedDate extends StatelessWidget {
  const ReportedBySectionWithReportedDate({
    super.key,
    required this.date,
    required this.reportedBy,
  });
  final String date;
  final String reportedBy;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ReportedBySection(reportedBy: reportedBy),
        const Spacer(),
        Text(
          date,
          style: AppStyles.bold12(context).copyWith(
            color: context.theme.black100,
          ),
        )
      ],
    );
  }
}
