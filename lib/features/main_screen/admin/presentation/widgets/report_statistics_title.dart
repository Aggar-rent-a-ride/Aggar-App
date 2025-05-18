import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ReportStatisticsTitle extends StatelessWidget {
  const ReportStatisticsTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reports Statistics",
          style: AppStyles.bold20(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        Text(
          "total reports in your system",
          style: AppStyles.medium12(context).copyWith(
            color: context.theme.black25,
          ),
        ),
      ],
    );
  }
}
