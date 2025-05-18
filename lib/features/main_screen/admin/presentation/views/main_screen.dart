import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
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
          context.read<ReportCubit>().fetchReportById(
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMSIsImp0aSI6ImE5MzdkNDQ5LWRmMDgtNDk0NC04ZTNlLTgwNzMxY2FiZDE2YSIsInVzZXJuYW1lIjoibmFydSIsInVpZCI6IjExIiwicm9sZXMiOlsiQWRtaW4iLCJVc2VyIiwiQ3VzdG9tZXIiXSwiZXhwIjoxNzQ3NTc1MzAzLCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.hYSirBOGIcp865bPjsyG9DnQjDShRupyNr8F8mFQLoA",
              54);
          context.read<ReportCubit>().updateReportStatus(
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMSIsImp0aSI6ImE5MzdkNDQ5LWRmMDgtNDk0NC04ZTNlLTgwNzMxY2FiZDE2YSIsInVzZXJuYW1lIjoibmFydSIsInVpZCI6IjExIiwicm9sZXMiOlsiQWRtaW4iLCJVc2VyIiwiQ3VzdG9tZXIiXSwiZXhwIjoxNzQ3NTc1MzAzLCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.hYSirBOGIcp865bPjsyG9DnQjDShRupyNr8F8mFQLoA",
              "Rejected",
              [54]);
          context.read<ReportCubit>().fetchReportTotals(
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMSIsImp0aSI6ImE5MzdkNDQ5LWRmMDgtNDk0NC04ZTNlLTgwNzMxY2FiZDE2YSIsInVzZXJuYW1lIjoibmFydSIsInVpZCI6IjExIiwicm9sZXMiOlsiQWRtaW4iLCJVc2VyIiwiQ3VzdG9tZXIiXSwiZXhwIjoxNzQ3NTc1MzAzLCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.hYSirBOGIcp865bPjsyG9DnQjDShRupyNr8F8mFQLoA");
          context.read<UserCubit>().fetchUserTotals(
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMSIsImp0aSI6ImE5MzdkNDQ5LWRmMDgtNDk0NC04ZTNlLTgwNzMxY2FiZDE2YSIsInVzZXJuYW1lIjoibmFydSIsInVpZCI6IjExIiwicm9sZXMiOlsiQWRtaW4iLCJVc2VyIiwiQ3VzdG9tZXIiXSwiZXhwIjoxNzQ3NTc1MzAzLCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.hYSirBOGIcp865bPjsyG9DnQjDShRupyNr8F8mFQLoA");
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
