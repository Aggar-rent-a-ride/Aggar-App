import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/line_colored.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_type_card_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReportTypeCard extends StatelessWidget {
  const ReportTypeCard({
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: context.theme.white100_2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LineColored(
              color: textColor,
            ),
            const Gap(10),
            ReportTypeCardContent(
              date: date,
              reportDescription: reportDescription,
              reportType: reportType,
              reportedBy: reportedBy,
              statusText: statusText,
              containerColor: containerColor,
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
