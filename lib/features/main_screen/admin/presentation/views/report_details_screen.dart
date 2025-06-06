import 'package:aggar/core/extensions/context_colors_extension.dart';

import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_details_body.dart';

import 'package:flutter/material.dart';

class ReportDetailsScreen extends StatelessWidget {
  const ReportDetailsScreen({super.key});

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
            const ReportDetailsBody()
          ],
        ),
      ),
    );
  }
}
