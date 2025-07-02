import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_formatted_date.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/filter_cubit/filter_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_type_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class ReportList extends StatefulWidget {
  const ReportList({super.key, required this.accessToken});
  final String accessToken;

  @override
  _ReportListState createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initial fetch of reports
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialReports();
    });
  }

  void _fetchInitialReports() {
    final filterCubit = context.read<FilterCubit>();
    context.read<ReportCubit>().fetchReports(
          widget.accessToken,
          filterCubit.selectedType,
          filterCubit.selectedStatus,
          filterCubit.selectedDate,
          filterCubit.selectedSortingDirection,
        );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final reportCubit = context.read<ReportCubit>();
      final filterCubit = context.read<FilterCubit>();

      // Only load more if not already loading
      if (!reportCubit.isLoadingMore) {
        reportCubit.isLoadingMore = true;
        reportCubit.fetchReports(
          widget.accessToken,
          filterCubit.selectedType,
          filterCubit.selectedStatus,
          filterCubit.selectedDate,
          filterCubit.selectedSortingDirection,
          isLoadMore: true,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state is ReportsLoaded || state is ReportsLoadingMore) {
          final reports = state is ReportsLoaded
              ? state.reports.data
              : (state as ReportsLoadingMore).reports.data;

          if (reports.isEmpty) {
            return Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.report_off,
                      size: 64,
                      color: context.theme.grey100_1,
                    ),
                    const Gap(16),
                    Text(
                      'No reports found',
                      style: TextStyle(
                        fontSize: 18,
                        color: context.theme.grey100_1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Try adjusting your filters',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.theme.grey100_1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Expanded(
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final filterCubit = context.read<FilterCubit>();
                      await context.read<ReportCubit>().refreshReports(
                            widget.accessToken,
                            filterCubit.selectedType,
                            filterCubit.selectedStatus,
                            filterCubit.selectedDate,
                            filterCubit.selectedSortingDirection,
                          );
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        DateTime datetime =
                            DateTime.parse(reports[index].createdAt);
                        return ReportTypeCard(
                          reportId: reports[index].id,
                          date: getFormattedDate(datetime),
                          reportDescription: reports[index].description,
                          reportType: reports[index].targetType,
                          reportedBy: reports[index].reporter.name,
                          statusText: reports[index].status,
                          containerColor: reports[index].status == "Pending"
                              ? AppConstants.myYellow10_1
                              : reports[index].status == "Reviewed"
                                  ? AppConstants.myGreen10_1
                                  : AppConstants.myRed10_1,
                          textColor: reports[index].status == "Pending"
                              ? AppConstants.myYellow100_1
                              : reports[index].status == "Reviewed"
                                  ? AppConstants.myGreen100_1
                                  : AppConstants.myRed100_1,
                        );
                      },
                    ),
                  ),
                ),
                if (state is ReportsLoadingMore)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: CircularProgressIndicator(
                      color: context.theme.blue100_5,
                    ),
                  ),
              ],
            ),
          );
        } else if (state is ReportError) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: context.theme.red100_1,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading reports',
                    style: TextStyle(
                      fontSize: 18,
                      color: context.theme.black100,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.theme.grey100_1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchInitialReports,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Loading state
          return Expanded(
            child: Shimmer.fromColors(
              baseColor: context.theme.grey100_1,
              highlightColor: context.theme.white100_1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  children: List.generate(
                    5,
                    (index) => Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: context.theme.white100_1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 15),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
