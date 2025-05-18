import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_statistics_card.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_type_card.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_statistics_card.dart';
import 'package:aggar/features/main_screen/widgets/main_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ReportCubit>().fetchReportTotals(
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMSIsImp0aSI6ImY4NTc5OGM2LTlhNzQtNGYyMy05MDEzLTJkYTk4M2MzMTVhOCIsInVzZXJuYW1lIjoibmFydSIsInVpZCI6IjExIiwicm9sZXMiOlsiQWRtaW4iLCJVc2VyIiwiQ3VzdG9tZXIiXSwiZXhwIjoxNzQ3NTY2NzYxLCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.uJdb9g1qOoZMFG4KV1cm6UhZLL3DCF1LplqC29FDZr0");
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
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const UserStatisticsCard(),
                    const ReportStatisticsCard(),
                    Row(
                      children: [
                        Text(
                          "All Reports",
                          style: AppStyles.bold20(context).copyWith(
                            color: context.theme.blue100_1,
                          ),
                        ),
                        // here is a filter
                      ],
                    ),
                    const ReportTypeCard()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
