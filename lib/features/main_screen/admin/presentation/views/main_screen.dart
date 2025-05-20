import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/all_report_section.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/main_header.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_statistics_card.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_statistics_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

String accestoken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMSIsImp0aSI6ImM1ZmJjNWMwLTAwNGEtNDQ1Yi05YjUyLTQ3NzQzMjJjNTk5OCIsInVzZXJuYW1lIjoibmFydSIsInVpZCI6IjExIiwicm9sZXMiOlsiQWRtaW4iLCJVc2VyIiwiQ3VzdG9tZXIiXSwiZXhwIjoxNzQ3NzI3MDg5LCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.Odtpj7oo5b_i1eW21ZiGwQBN3dHbNiL4RgUZue2xwtI";

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<UserCubit>().searchUsers(accestoken, "esraa");
          context
              .read<ReportCubit>()
              .fetchReportsAndTotals(accestoken, "Vehicle");
          context.read<UserCubit>().fetchUserTotals(accestoken);
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserStatisticsCard(),
                    ReportStatisticsCard(),
                    AllReportSection()
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
