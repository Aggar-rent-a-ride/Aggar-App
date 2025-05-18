import 'package:aggar/features/main_screen/admin/presentation/widgets/report_status_container.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_type_with_descreption.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/reported_by_section_with_reported_date.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReportTypeCardContent extends StatelessWidget {
  const ReportTypeCardContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ReportTypeWithDescreption(),
                ),
                Spacer(
                  flex: 1,
                ),
                ReportStatusContainer(),
              ],
            ),
          ),
          Gap(12),
          ReportedBySectionWithReportedDate()
        ],
      ),
    );
  }
}
