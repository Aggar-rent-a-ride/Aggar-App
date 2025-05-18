import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ReportTypeWithDescreption extends StatelessWidget {
  const ReportTypeWithDescreption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer Review Report",
          style: AppStyles.bold22(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        Text(
          "This vehicle does not exactly match the description provided by the renter!",
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: AppStyles.medium12(context).copyWith(
            color: context.theme.black50,
          ),
        ),
      ],
    );
  }
}
