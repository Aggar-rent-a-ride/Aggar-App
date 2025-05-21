import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/statistics_cubit/statistics_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/statistics_cubit/statistics_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/pie_chart_item.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_bar_chart.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_statistics_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, statisticsState) {
        if (statisticsState is StatisticsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (statisticsState is StatisticsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${statisticsState.message}'),
                const Gap(10),
                ElevatedButton(
                  onPressed: () {
                    final mainState = context.read<AdminMainCubit>().state;
                    if (mainState is AdminMainConnected) {
                      context
                          .read<StatisticsCubit>()
                          .fetchTotalReports(mainState.accessToken);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (statisticsState is StatisticsLoaded) {
          final totalReportsByType = statisticsState.totalReportsByType;
          final reportTypes = [
            {'type': 'Message', 'title': 'Messages Report', 'index': 0},
            {
              'type': 'CustomerReview',
              'title': 'Customer Review Report',
              'index': 1
            },
            {
              'type': 'RenterReview',
              'title': 'Renter Review Report',
              'index': 2
            },
            {'type': 'AppUser', 'title': 'AppUser Report', 'index': 3},
            {'type': 'Vehicle', 'title': 'Vehicle Report', 'index': 4},
            {'type': 'Booking', 'title': 'Booking Report', 'index': 5},
            {'type': 'Rental', 'title': 'Rental Report', 'index': 6},
          ];

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
                          title:
                              "${reportTypes[6]['title']} (${totalReportsByType[reportTypes[6]['type']] ?? 0})",
                          color: AppConstants.myBlue100_7,
                          onTap: () => _onChartItemTap(6),
                          isSelected: selectedIndex == 6,
                        ),
                        ChartItem(
                          title:
                              "${reportTypes[1]['title']} (${totalReportsByType[reportTypes[1]['type']] ?? 0})",
                          color: AppConstants.myBlue100_2,
                          onTap: () => _onChartItemTap(1),
                          isSelected: selectedIndex == 1,
                        ),
                        ChartItem(
                          title:
                              "${reportTypes[5]['title']} (${totalReportsByType[reportTypes[5]['type']] ?? 0})",
                          color: AppConstants.myBlue100_6,
                          onTap: () => _onChartItemTap(5),
                          isSelected: selectedIndex == 5,
                        ),
                        ChartItem(
                          title:
                              "${reportTypes[3]['title']} (${totalReportsByType[reportTypes[3]['type']] ?? 0})",
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
                          title:
                              "${reportTypes[4]['title']} (${totalReportsByType[reportTypes[4]['type']] ?? 0})",
                          color: AppConstants.myBlue100_5,
                          onTap: () => _onChartItemTap(4),
                          isSelected: selectedIndex == 4,
                        ),
                        ChartItem(
                          title:
                              "${reportTypes[2]['title']} (${totalReportsByType[reportTypes[2]['type']] ?? 0})",
                          color: AppConstants.myBlue100_3,
                          onTap: () => _onChartItemTap(2),
                          isSelected: selectedIndex == 2,
                        ),
                        ChartItem(
                          title:
                              "${reportTypes[0]['title']} (${totalReportsByType[reportTypes[0]['type']] ?? 0})",
                          color: AppConstants.myBlue100_1,
                          onTap: () => _onChartItemTap(0),
                          isSelected: selectedIndex == 0,
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(10),
              ],
            ),
          );
        }
        return const Center(child: Text('No statistics data available'));
      },
    );
  }
}
