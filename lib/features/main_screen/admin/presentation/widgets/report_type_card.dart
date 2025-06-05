import 'package:aggar/core/cubit/reportId/report_bu_id_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/admin/presentation/views/report_details_screen.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/line_colored.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_type_card_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    required this.reportId,
    this.onTap,
  });

  final String reportType;
  final String reportDescription;
  final Color? containerColor;
  final Color? textColor;
  final String statusText;
  final String date;
  final String reportedBy;
  final int reportId; // Add this parameter
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigate with BlocProvider to ensure the cubit is available
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ReportBuIdCubit()
                ..fetchReportById(
                  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMSIsImp0aSI6IjNmOGQxZjJlLWE5ODEtNGIxNy1hMTc2LThiNjIwMjhlZTBlYyIsInVzZXJuYW1lIjoibmFydSIsInVpZCI6IjExIiwicm9sZXMiOlsiQWRtaW4iLCJVc2VyIl0sImV4cCI6MTc0OTE1NTkzNiwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.mYsoogvt9TtH009jHVRgMtNLxiXkwVrgdoHD1y7r7YE",
                  reportId, // Use the actual report ID
                ),
              child: const ReportDetailsScreen(),
            ),
          ),
        );
      },
      child: Container(
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
      ),
    );
  }
}
