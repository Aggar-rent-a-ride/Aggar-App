import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/pie_chart_item.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_pie_chart.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_statistics_title.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainScreenBody extends StatelessWidget {
  const MainScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                    PieChartItem(
                      title: "Admin",
                      color: const Color(0xFFC6C7F4),
                      onTap: () => UserPieChart.updateIndex(2),
                    ),
                    PieChartItem(
                      title: "Renter",
                      color: const Color(0xFF8E90E8),
                      onTap: () => UserPieChart.updateIndex(1),
                    ),
                    PieChartItem(
                      title: "Customer",
                      color: const Color(0xFF3A3F9B),
                      onTap: () => UserPieChart.updateIndex(0),
                    ),
                  ],
                ),
                const Gap(10),
                Text(
                  "total users: 1000",
                  style: AppStyles.medium12(context).copyWith(
                    color: context.theme.black25,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Expanded(
          child: UserPieChart(),
        ),
      ],
    );
  }
}
