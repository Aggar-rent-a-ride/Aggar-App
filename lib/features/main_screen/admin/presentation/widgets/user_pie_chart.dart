import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_state.dart';
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
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          print('UserPieChart UserCubit state: $state');
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else if (state is UserTotalsLoaded) {
            return PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (event is FlTapUpEvent &&
                        pieTouchResponse != null &&
                        pieTouchResponse.touchedSection != null) {
                      final index =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                      print('Pie section tapped: index=$index');
                      onPieSectionTap(index);
                    }
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: _showingSections(
                  state.totalReportsByType,
                  selectedIndex,
                  context,
                ),
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  List<PieChartSectionData> _showingSections(
    Map<String, int> totalUsersByRole,
    int? selectedIndex,
    BuildContext context,
  ) {
    final roleItems = [
      {'role': 'Customer', 'color': const Color(0xFFC6C7F4), 'index': 0},
      {'role': 'Renter', 'color': const Color(0xFF8E90E8), 'index': 1},
      {'role': 'Admin', 'color': const Color(0xFF3A3F9B), 'index': 2},
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
      final radius = isSelected ? 60.0 : 50.0;
      final fontSize = isSelected ? 18.0 : 16.0;

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: count > 0 ? '$role\n${percentage.toStringAsFixed(1)}%' : '',
        radius: radius,
        titleStyle: AppStyles.medium.copyWith(
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        showTitle: count > 0,
      );
    }).toList();
  }
}
