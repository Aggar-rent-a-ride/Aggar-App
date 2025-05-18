import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/pie_chart_item.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_bar_chart.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_statistics_title.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReportStatisticsBody extends StatefulWidget {
  const ReportStatisticsBody({super.key});

  @override
  State<ReportStatisticsBody> createState() => _ReportStatisticsBodyState();
}

class _ReportStatisticsBodyState extends State<ReportStatisticsBody> {
  int? selectedIndex;

  void _onChartItemTap(int index) {
    setState(() {
      selectedIndex = selectedIndex == index ? null : index;
    });
  }

  void _onBarTap(int index, double value) {
    setState(() {
      selectedIndex = selectedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ReportStatisticsTitle(),
          const Gap(20),
          ReportBarChart(
            selectedIndex: selectedIndex,
            onBarTap: _onBarTap,
          ),
          const Gap(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChartItem(
                    title: "App User Report",
                    color: AppConstants.myBlue100_7,
                    onTap: () => _onChartItemTap(6),
                    isSelected: selectedIndex == 6,
                  ),
                  ChartItem(
                    title: "Vehicle Report",
                    color: AppConstants.myBlue100_2,
                    onTap: () => _onChartItemTap(1),
                    isSelected: selectedIndex == 1,
                  ),
                  ChartItem(
                    title: "Booking Report",
                    color: AppConstants.myBlue100_6,
                    onTap: () => _onChartItemTap(5),
                    isSelected: selectedIndex == 5,
                  ),
                  ChartItem(
                    title: "Rental Report",
                    color: AppConstants.myBlue100_4,
                    onTap: () => _onChartItemTap(3),
                    isSelected: selectedIndex == 3,
                  ),
                ],
              ),
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChartItem(
                    title: "Message Report",
                    color: AppConstants.myBlue100_5,
                    onTap: () => _onChartItemTap(4),
                    isSelected: selectedIndex == 4,
                  ),
                  ChartItem(
                    title: "Renter Review Report",
                    color: AppConstants.myBlue100_3,
                    onTap: () => _onChartItemTap(2),
                    isSelected: selectedIndex == 2,
                  ),
                  ChartItem(
                    title: "Customer Review Report",
                    color: AppConstants.myBlue100_1,
                    onTap: () => _onChartItemTap(0),
                    isSelected: selectedIndex == 0,
                  ),
                ],
              ),
            ],
          ),
          const Gap(10)
        ],
      ),
    );
  }
}
