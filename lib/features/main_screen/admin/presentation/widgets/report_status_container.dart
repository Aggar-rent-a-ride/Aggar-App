import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ReportStatusContainer extends StatelessWidget {
  const ReportStatusContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: context.theme.yellow10_1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            color: Colors.black12,
            offset: Offset(0, 0),
          )
        ],
      ),
      child: Text(
        "Pending",
        style: AppStyles.medium12(context).copyWith(
          color: context.theme.yellow100_1,
        ),
      ),
    );
  }
}
