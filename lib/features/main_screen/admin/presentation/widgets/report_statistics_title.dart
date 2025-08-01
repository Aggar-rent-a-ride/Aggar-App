import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/statistics_cubit/statistics_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/statistics_cubit/statistics_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportStatisticsTitle extends StatelessWidget {
  const ReportStatisticsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        int totalReports = 0;
        if (state is StatisticsLoaded) {
          totalReports = state.totalReportsByType.values.fold(
            0,
            (sum, count) => sum + (count as int),
          );
        }
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reports Statistics",
                  style: AppStyles.bold20(
                    context,
                  ).copyWith(color: context.theme.blue100_1),
                ),
                Text(
                  "total reports in your system",
                  style: AppStyles.medium12(
                    context,
                  ).copyWith(color: context.theme.black25),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "Total Reports : $totalReports",
              style: AppStyles.medium12(
                context,
              ).copyWith(color: context.theme.black100),
            ),
          ],
        );
      },
    );
  }
}
