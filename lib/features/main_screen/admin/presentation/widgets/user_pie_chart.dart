import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_statistics/user_statistics_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_statistics/user_statistics_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPieChart extends StatelessWidget {
  const UserPieChart({
    super.key,
    this.selectedIndex,
    required this.onPieSectionTap,
  });

  final int? selectedIndex;
  final void Function(int index) onPieSectionTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<UserStatisticsCubit, UserStatisticsState>(
          builder: (context, state) {
            if (state is UserStatisticsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserStatisticsError) {
              return Center(child: Text(state.message));
            } else if (state is UserStatisticsUserTotalsLoaded) {
              final totalUsers = state.totalUsersByRole.values
                  .fold(0, (sum, count) => sum + count);
              if (totalUsers == 0) {
                return const Center(child: Text('No users found'));
              }
              return PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (event is FlTapUpEvent &&
                          pieTouchResponse != null &&
                          pieTouchResponse.touchedSection != null) {
                        final index = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                        onPieSectionTap(index);
                      }
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 30,
                  sections: _showingSections(
                    state.totalUsersByRole,
                    selectedIndex,
                    context,
                  ),
                ),
              );
            }
            return const Center(child: Text('Initializing data...'));
          },
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections(
    Map<String, int> totalUsersByRole,
    int? selectedIndex,
    BuildContext context,
  ) {
    final roleItems = [
      {'role': 'Customer', 'color': AppConstants.myBlue100_1, 'index': 0},
      {'role': 'Renter', 'color': AppConstants.myBlue100_2, 'index': 1},
      {'role': 'Admin', 'color': AppConstants.myBlue100_3, 'index': 2},
    ];

    final totalUsers =
        totalUsersByRole.values.fold(0, (sum, count) => sum + count);
    final percentages = totalUsers > 0
        ? totalUsersByRole.map((role, count) => MapEntry(
              role,
              (count / totalUsers * 100).toDouble(),
            ))
        : <String, double>{};

    return roleItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final role = item['role'] as String;
      final color = item['color'] as Color;
      final isSelected = selectedIndex == index;
      final count = totalUsersByRole[role] ?? 0;
      final percentage = percentages[role] ?? 0.0;
      final radius = isSelected
          ? MediaQuery.sizeOf(context).width * 0.135
          : MediaQuery.sizeOf(context).width * 0.12;
      final fontSize = isSelected
          ? MediaQuery.sizeOf(context).width * 0.035
          : MediaQuery.sizeOf(context).width * 0.03;

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: count > 0 ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: radius,
        titleStyle: AppStyles.medium.copyWith(
          fontSize: fontSize,
          color: context.theme.white100_1,
          fontWeight: FontWeight.bold,
        ),
        showTitle: count > 0,
      );
    }).toList();
  }
}
