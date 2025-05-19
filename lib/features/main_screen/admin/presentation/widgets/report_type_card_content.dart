import 'package:aggar/features/main_screen/admin/presentation/widgets/report_status_container.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_type_with_descreption.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/reported_by_section_with_reported_date.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReportTypeCardContent extends StatelessWidget {
  const ReportTypeCardContent({
    super.key,
    required this.reportType,
    required this.reportDescription,
    this.containerColor,
    this.textColor,
    required this.statusText,
    required this.date,
    required this.reportedBy,
  });
  final String reportType;
  final String reportDescription;
  final Color? containerColor;
  final Color? textColor;
  final String statusText;
  final String date;
  final String reportedBy;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ReportTypeWithDescreption(
                    reportDescerption: reportDescription,
                    reportType: reportType,
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                ReportStatusContainer(
                  statusText: statusText,
                  containerColor: containerColor,
                  textColor: textColor,
                ),
              ],
            ),
          ),
          const Gap(12),
          ReportedBySectionWithReportedDate(
            date: date,
            reportedBy: reportedBy,
          )
        ],
      ),
    );
  }
}
