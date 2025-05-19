import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ReportedBySection extends StatelessWidget {
  const ReportedBySection({
    super.key,
    required this.reportedBy,
  });
  final String reportedBy;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "reported by",
          style: AppStyles.medium12(context).copyWith(
            color: context.theme.black50,
          ),
        ),
        Text(
          reportedBy,
          style: AppStyles.bold14(context).copyWith(
            color: context.theme.black100,
          ),
        ),
      ],
    );
  }
}
