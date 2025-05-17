import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class UserStatisticsTitle extends StatelessWidget {
  const UserStatisticsTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "User Statistics",
          style: AppStyles.bold20(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        Text(
          "total users in your system",
          style: AppStyles.medium12(context).copyWith(
            color: context.theme.black25,
          ),
        ),
      ],
    );
  }
}
