import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/filter_cubit/filter_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/views/no_internet_all_report_screen.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/filter_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllReportsScreen extends StatelessWidget {
  const AllReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminMainCubit, AdminMainState>(
      builder: (context, state) {
        if (state is AdminMainConnected) {
          return PopScope(
            canPop: true,
            onPopInvoked: (didPop) {
              if (didPop) {
                context.read<FilterCubit>().resetFilters();
              }
            },
            child: Scaffold(
              backgroundColor: context.theme.white100_1,
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
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
                          left: 12, right: 12, top: 55, bottom: 8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.read<FilterCubit>().resetFilters();
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: context.theme.white100_1,
                              size: 20,
                            ),
                          ),
                          Text(
                            "All Reports",
                            style: AppStyles.bold20(context).copyWith(
                              color: context.theme.white100_1,
                            ),
                          ),
                          const Spacer(),
                          FilterButton(
                            accessToken: state.accessToken,
                          ),
                        ],
                      ),
                    ),
                    ReportList(
                      accessToken: state.accessToken,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is AdminMainDisconnected) {
          return const NoInternetAllReportScreen();
        } else if (state is AdminMainAuthError) {
          return Scaffold(
            backgroundColor: context.theme.white100_1,
            body: Center(
              child: Text(
                state.message,
                style: AppStyles.semiBold18(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
