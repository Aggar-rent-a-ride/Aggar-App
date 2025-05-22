import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_formatted_date.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_type_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ReportList extends StatefulWidget {
  const ReportList(
      {super.key,
      required this.accessToken,
      this.filterType,
      this.filterStatus,
      this.filterDate,
      this.filterSortingDirection});
  final String accessToken;
  final String? filterType;
  final String? filterStatus;
  final String? filterDate;
  final String? filterSortingDirection;

  @override
  _ReportListState createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.9 &&
          !context.read<ReportCubit>().isLoadingMore) {
        context.read<ReportCubit>().isLoadingMore = true;
        context.read<ReportCubit>().fetchReports(
              widget.accessToken,
              widget.filterType,
              widget.filterStatus,
              widget.filterDate,
              widget.filterSortingDirection,
              isLoadMore: true,
            );
      }
    });
  }

  @override
  void dispose() {
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
          return Expanded(
            child: Column(
              children: [
                Expanded(
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
        } else {
          return Shimmer.fromColors(
            baseColor: context.theme.gray100_1,
            highlightColor: context.theme.white100_1,
            child: Column(
              children: List.generate(
                3,
                (index) => Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: context.theme.white100_1,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  margin: const EdgeInsets.only(bottom: 15),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
