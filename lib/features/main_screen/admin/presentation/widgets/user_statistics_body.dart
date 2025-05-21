import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/pie_chart_item.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_pie_chart.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_statistics_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class UserStatisticsBody extends StatefulWidget {
  const UserStatisticsBody({super.key});

  @override
  State<UserStatisticsBody> createState() => _UserStatisticsBodyState();
}

class _UserStatisticsBodyState extends State<UserStatisticsBody> {
  int? selectedIndex;

  void _onChartItemTap(int index) {
    setState(() {
      selectedIndex = selectedIndex == index ? null : index;
    });
  }

  void _onPieSectionTap(int index) {
    setState(() {
      selectedIndex = selectedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        print('UserStatisticsBody UserCubit state: $state');
        Map<String, int> totalUsersByRole = {
          "Admin": 0,
          "Renter": 0,
          "Customer": 0,
        };
        int totalUsers = 0;
        Map<String, double> percentages = {
          "Admin": 0.0,
          "Renter": 0.0,
          "Customer": 0.0,
        };

        if (state is UserTotalsLoaded) {
          totalUsersByRole = state.totalReportsByType;
          totalUsers =
              totalUsersByRole.values.fold(0, (sum, count) => sum + count);
          if (totalUsers > 0) {
            percentages = totalUsersByRole.map((role, count) => MapEntry(
                  role,
                  (count / totalUsers * 100).toDouble(),
                ));
          }
        } else if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                const Gap(10),
                ElevatedButton(
                  onPressed: () {
                    final mainState = context.read<AdminMainCubit>().state;
                    if (mainState is AdminMainConnected) {
                      context
                          .read<UserCubit>()
                          .fetchUserTotals(mainState.accessToken);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final roleItems = [
          {'role': 'Customer', 'color': const Color(0xFFC6C7F4), 'index': 0},
          {'role': 'Renter', 'color': const Color(0xFF8E90E8), 'index': 1},
          {'role': 'Admin', 'color': const Color(0xFF3A3F9B), 'index': 2},
        ];

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
                      children: roleItems.map((item) {
                        final role = item['role'] as String;
                        final color = item['color'] as Color;
                        final index = item['index'] as int;
                        final count = totalUsersByRole[role] ?? 0;
                        final percentage =
                            percentages[role]?.toStringAsFixed(1) ?? '0.0';
                        return ChartItem(
                          title: "$role ($count, $percentage%)",
                          color: color,
                          isSelected: selectedIndex == index,
                          onTap: () => _onChartItemTap(index),
                        );
                      }).toList(),
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
            Expanded(
              child: UserPieChart(
                selectedIndex: selectedIndex,
                onPieSectionTap: _onPieSectionTap,
              ),
            ),
          ],
        );
      },
    );
  }
}
