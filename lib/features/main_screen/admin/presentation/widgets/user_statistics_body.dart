import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/pie_chart_item.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_pie_chart.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_statistics_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class UserStatisticsBody extends StatelessWidget {
  const UserStatisticsBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        // Default values in case state is not yet loaded
        Map<String, int> totalUsersByRole = {
          "Admin": 0,
          "Renter": 0,
          "Customer": 0,
        };
        int totalUsers = 0;

        // Update values based on state
        if (state is UserTotalsLoaded) {
          totalUsersByRole = state.totalReportsByType;
          totalUsers =
              totalUsersByRole.values.fold(0, (sum, count) => sum + count);
        }

        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const UserStatisticsTitle(),
                    Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChartItem(
                          title:
                              "Customer (${totalUsersByRole['Customer'] ?? 0})",
                          color: const Color(0xFFC6C7F4),
                          onTap: () => UserPieChart.updateIndex(2),
                        ),
                        ChartItem(
                          title: "Renter (${totalUsersByRole['Renter'] ?? 0})",
                          color: const Color(0xFF8E90E8),
                          onTap: () => UserPieChart.updateIndex(1),
                        ),
                        ChartItem(
                          title: "Admin (${totalUsersByRole['Admin'] ?? 0})",
                          color: const Color(0xFF3A3F9B),
                          onTap: () => UserPieChart.updateIndex(0),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Text(
                      "Total Users: $totalUsers",
                      style: AppStyles.medium12(context).copyWith(
                        color: context.theme.black100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: UserPieChart(
                accessToken:
                    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMSIsImp0aSI6ImE5MzdkNDQ5LWRmMDgtNDk0NC04ZTNlLTgwNzMxY2FiZDE2YSIsInVzZXJuYW1lIjoibmFydSIsInVpZCI6IjExIiwicm9sZXMiOlsiQWRtaW4iLCJVc2VyIiwiQ3VzdG9tZXIiXSwiZXhwIjoxNzQ3NTc1MzAzLCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.hYSirBOGIcp865bPjsyG9DnQjDShRupyNr8F8mFQLoA',
              ),
            ),
          ],
        );
      },
    );
  }
}
