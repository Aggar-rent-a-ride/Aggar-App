import 'package:aggar/core/cubit/reportId/report_by_id_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReporterWithCreatedAtSection extends StatelessWidget {
  const ReporterWithCreatedAtSection({
    super.key,
    required this.formattedDate,
    required this.state,
  });

  final String formattedDate;
  final ReportByIdLoaded state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reporter",
                style: AppStyles.regular14(context).copyWith(
                  color: context.theme.black50,
                ),
              ),
              const Gap(4),
              Text(
                state.report.reporter.name,
                style: AppStyles.bold16(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: context.theme.black50,
                  ),
                  const Gap(4),
                  Text(
                    "Created At",
                    style: AppStyles.regular14(context).copyWith(
                      color: context.theme.black50,
                    ),
                  ),
                ],
              ),
              const Gap(4),
              Text(
                formattedDate,
                style: AppStyles.bold16(context).copyWith(
                  color: context.theme.black100,
                ),
                semanticsLabel: "Created at: $formattedDate",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
