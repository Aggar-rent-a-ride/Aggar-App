import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_formatted_date.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/see_more_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/views/all_reports_screen.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_type_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AllReportSection extends StatelessWidget {
  const AllReportSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state is ReportsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    "All Reports",
                    style: AppStyles.bold20(context).copyWith(
                      color: context.theme.blue100_1,
                    ),
                  ),
                ],
              ),
              Column(
                children: List.generate(
                  state.reports.data.length,
                  (index) {
                    DateTime datetime =
                        DateTime.parse(state.reports.data[index].createdAt);
                    return ReportTypeCard(
                      date: getFormattedDate(datetime),
                      reportDescription: state.reports.data[index].description,
                      reportType: state.reports.data[index].targetType,
                      reportedBy: state.reports.data[index].reporter.name,
                      statusText: state.reports.data[index].status,
                      containerColor:
                          state.reports.data[index].status == "Pending"
                              ? AppConstants.myYellow10_1
                              : state.reports.data[index].status == "Reviewed"
                                  ? AppConstants.myGreen10_1
                                  : AppConstants.myRed10_1,
                      textColor: state.reports.data[index].status == "Pending"
                          ? AppConstants.myYellow100_1
                          : state.reports.data[index].status == "Reviewed"
                              ? AppConstants.myGreen100_1
                              : AppConstants.myRed100_1,
                    );
                  },
                ),
              ),
              SeeMoreButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllReportsScreen(),
                    ),
                  );
                },
              ),
              const Gap(25),
            ],
          );
        } else if (state is ReportError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
