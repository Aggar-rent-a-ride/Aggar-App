import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/bar_chart_group_column.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ReportBarChart extends StatelessWidget {
  const ReportBarChart({
    super.key,
    this.selectedIndex,
    required this.onBarTap,
  });

  final int? selectedIndex;
  final void Function(int index, double value) onBarTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(builder: (context, state) {
      Map<String, int> totalReportsByType = {};
      double maxY = 10;
      if (state is ReportTotalsLoaded) {
        totalReportsByType = state.totalReportsByType;
        if (totalReportsByType.isNotEmpty) {
          maxY = totalReportsByType.values
                  .reduce((a, b) => a > b ? a : b)
                  .toDouble() *
              1.2;
        }
      }
      final reportTypes = context.read<ReportCubit>().reportTypes;
      final filteredReportTypes =
          reportTypes.where((type) => type != 'None').toList();

      List<BarChartGroupData> barGroups =
          filteredReportTypes.asMap().entries.map((entry) {
        final index = entry.key;
        final type = entry.value;
        final value = (totalReportsByType[type] ?? 0).toDouble();
        return createBarGroup(
          index,
          value,
          selectedIndex == index
              ? AppConstants
                  .myBlue100Colors[index % AppConstants.myBlue100Colors.length]
                  .withOpacity(1)
              : AppConstants
                  .myBlue100Colors[index % AppConstants.myBlue100Colors.length]
                  .withOpacity(0.5),
          selectedIndex == index,
        );
      }).toList();
      return SizedBox(
        height: 170,
        width: double.infinity,
        child: BarChart(
          BarChartData(
              alignment: BarChartAlignment.center,
              groupsSpace: 15,
              minY: 0,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipRoundedRadius: 8,
                  tooltipMargin: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      rod.toY.toString(),
                      AppStyles.regular15(context).copyWith(
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  if (event is FlTapUpEvent &&
                      barTouchResponse != null &&
                      barTouchResponse.spot != null) {
                    final index = barTouchResponse.spot!.touchedBarGroupIndex;
                    final value = barTouchResponse.spot!.touchedRodData.toY;
                    onBarTap(index, value);
                  }
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: const AxisTitles(
                  axisNameWidget: null,
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 ||
                          value == maxY * 0.2 ||
                          value == maxY * 0.4 ||
                          value == maxY * 0.6 ||
                          value == maxY * 0.8 ||
                          value == maxY) {
                        return Row(
                          children: [
                            Text(
                              value.toInt().toString(),
                              style: AppStyles.regular10(context).copyWith(
                                color: context.theme.black100,
                              ),
                            ),
                            const Gap(5),
                            Container(
                              height: 1.5,
                              width: 4.5,
                              color: Colors.black,
                            ),
                          ],
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
                checkToShowHorizontalLine: (value) {
                  return value % (maxY / 5) == 0;
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1),
                ),
              ),
              barGroups: barGroups),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      );
    });
  }
}
