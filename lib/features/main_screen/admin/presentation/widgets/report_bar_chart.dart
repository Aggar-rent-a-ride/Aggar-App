import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/bar_chart_group_column.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
    return SizedBox(
      height: 170,
      width: double.infinity,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          groupsSpace: 15,
          minY: 0,
          maxY: 10,
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
                      value == 2 ||
                      value == 4 ||
                      value == 6 ||
                      value == 8 ||
                      value == 10) {
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
              return value % 2 == 0;
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.black, width: 1),
              bottom: BorderSide(color: Colors.black, width: 1),
            ),
          ),
          barGroups: [
            createBarGroup(
                0,
                7.5,
                selectedIndex == 0
                    ? AppConstants.myBlue100_1.withOpacity(1)
                    : AppConstants.myBlue100_1.withOpacity(0.5),
                selectedIndex == 0),
            createBarGroup(
                1,
                5.2,
                selectedIndex == 1
                    ? AppConstants.myBlue100_2.withOpacity(1)
                    : AppConstants.myBlue100_2.withOpacity(0.5),
                selectedIndex == 1),
            createBarGroup(
                2,
                8.3,
                selectedIndex == 2
                    ? AppConstants.myBlue100_3.withOpacity(1)
                    : AppConstants.myBlue100_3.withOpacity(0.5),
                selectedIndex == 2),
            createBarGroup(
                3,
                3.8,
                selectedIndex == 3
                    ? AppConstants.myBlue100_4.withOpacity(1)
                    : AppConstants.myBlue100_4.withOpacity(0.5),
                selectedIndex == 3),
            createBarGroup(
                4,
                6.1,
                selectedIndex == 4
                    ? AppConstants.myBlue100_5.withOpacity(1)
                    : AppConstants.myBlue100_5.withOpacity(0.5),
                selectedIndex == 4),
            createBarGroup(
                5,
                9.2,
                selectedIndex == 5
                    ? AppConstants.myBlue100_6.withOpacity(1)
                    : AppConstants.myBlue100_6.withOpacity(0.5),
                selectedIndex == 5),
            createBarGroup(
                6,
                4.4,
                selectedIndex == 6
                    ? AppConstants.myBlue100_7.withOpacity(1)
                    : AppConstants.myBlue100_7.withOpacity(0.5),
                selectedIndex == 6),
          ],
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }
}
