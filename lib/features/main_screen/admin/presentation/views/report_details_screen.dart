import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_status_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReportDetailsScreen extends StatelessWidget {
  const ReportDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: SingleChildScrollView(
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
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: context.theme.white100_1,
                      size: 20,
                    ),
                  ),
                  Text(
                    "Report details",
                    style: AppStyles.bold20(context).copyWith(
                      color: context.theme.white100_1,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Vehicle Report",
                        style: AppStyles.bold24(context).copyWith(
                          color: context.theme.black100,
                        ),
                      ),
                      const Spacer(),
                      ReportStatusContainer(
                        statusText: "Pending",
                        containerColor: AppConstants.myYellow10_1,
                        textColor: AppConstants.myYellow100_1,
                      )
                    ],
                  ),
                  const Gap(5),
                  Text(
                    "desception of the vehicle reportdesception of the vehicle reportdesception of the vehicle reportdesception of the vehicle reportdesception of the vehicle report",
                    style: AppStyles.medium15(context).copyWith(
                      color: context.theme.black100,
                    ),
                  ),
                  const Gap(15),
                  Container(
                    height: 500,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.black26,
                          offset: Offset(0, 0),
                        )
                      ],
                      color: context.theme.blue10_2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [],
                    ),
                  ),
                  const Gap(15),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reporter",
                            style: AppStyles.medium13(context).copyWith(
                              color: context.theme.black50,
                            ),
                          ),
                          Text(
                            "Esraa Ehab",
                            style: AppStyles.bold15(context).copyWith(
                              color: context.theme.black100,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Created At",
                            style: AppStyles.medium13(context).copyWith(
                              color: context.theme.black50,
                            ),
                          ),
                          Text(
                            "05:00 Am in 20-5-2025",
                            style: AppStyles.bold15(context).copyWith(
                              color: context.theme.black100,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
