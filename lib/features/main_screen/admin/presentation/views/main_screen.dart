import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/line_colored.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_statistics_card.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_status_container.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_type_card.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/reported_by_section_with_reported_date.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_statistics_card.dart';
import 'package:aggar/features/main_screen/widgets/main_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: RefreshIndicator(
        onRefresh: () async {},
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
