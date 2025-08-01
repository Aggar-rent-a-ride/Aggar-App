import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/widgets/see_more_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/filter_cubit/filter_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/statistics_cubit/statistics_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/views/all_users_screen.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/all_report_section.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/loading_all_report_section.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/loading_report_statistics_card.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/loading_user_statistics_card.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/main_header.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_statistics_card.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_statistics_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AdminMainCubit, AdminMainState>(
            listener: (context, state) {
              if (state is AdminMainAuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                    context,
                    "Error",
                    "Auth Error: ${state.message}",
                    SnackBarType.error,
                  ),
                );
              } else if (state is AdminMainDisconnected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                    context,
                    "Error",
                    "No internet connection",
                    SnackBarType.error,
                  ),
                );
              } else if (state is AdminMainConnected) {
                context.read<FilterCubit>().resetFilters();
                context.read<ReportCubit>().fetchReports(
                      state.accessToken,
                      null,
                      null,
                      null,
                      null,
                    );
              }
            },
          ),
          BlocListener<FilterCubit, FilterState>(
            listener: (context, state) {
              if (state is FilterVehicleReset) {
                final adminState = context.read<AdminMainCubit>().state;
                if (adminState is AdminMainConnected) {
                  context.read<ReportCubit>().fetchReports(
                        adminState.accessToken,
                        null,
                        null,
                        null,
                        null,
                      );
                }
              }
            },
          ),
        ],
        child: BlocBuilder<AdminMainCubit, AdminMainState>(
          builder: (context, state) {
            if (state is AdminMainLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AdminMainDisconnected) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Please check your internet connection'),
                    ElevatedButton(
                      onPressed: () => context
                          .read<AdminMainCubit>()
                          .checkInternetConnection(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is AdminMainAuthError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<AdminMainCubit>().initializeScreen(),
                      child: const Text('Retry Login'),
                    ),
                  ],
                ),
              );
            } else if (state is AdminMainConnected) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<AdminMainCubit>().refreshData();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: context.theme.blue100_8,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 55, bottom: 20),
                        child: const MainHeader(),
                      ),
                      const Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: BlocBuilder<ReportCubit, ReportState>(
                          builder: (context, reportState) {
                            if (reportState is ReportError) {
                              return Center(
                                child: Column(
                                  children: [
                                    Text(
                                        'Report Error: ${reportState.message}'),
                                    ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<StatisticsCubit>()
                                            .fetchTotalReports(
                                                state.accessToken);
                                        context
                                            .read<ReportCubit>()
                                            .fetchReports(
                                              state.accessToken,
                                              null,
                                              null,
                                              null,
                                              null,
                                            );
                                      },
                                      child: const Text('Retry Reports'),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!state.isUserStatisticsLoaded)
                                  const LoadingUserStatisticsCard()
                                else
                                  const UserStatisticsCard(),
                                SeeMoreButton(onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AllUsersScreen(),
                                    ),
                                  );
                                }),
                                if (!state.isStatisticsLoaded)
                                  const LoadingReportStatisticsCard()
                                else
                                  const ReportStatisticsCard(),
                                const Gap(10),
                                if (!state.isReportsLoaded)
                                  const LoadingAllReportSection()
                                else
                                  const AllReportSection(),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Initializing...'),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AdminMainCubit>().initializeScreen(),
                    child: const Text('Retry Initialization'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
