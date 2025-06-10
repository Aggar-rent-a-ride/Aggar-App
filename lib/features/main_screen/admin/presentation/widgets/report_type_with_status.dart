import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ReportTypewithStatus extends StatelessWidget {
  const ReportTypewithStatus({
    super.key,
    required this.targetType,
  });
  final String targetType;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$targetType Report",
          style: AppStyles.bold24(context).copyWith(
            color: context.theme.black100,
          ),
          semanticsLabel: "$targetType Report",
        ),
        const Spacer(),
      ],
    );
  }
}
