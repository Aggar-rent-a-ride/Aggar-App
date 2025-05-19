import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ReportTypeWithDescreption extends StatelessWidget {
  const ReportTypeWithDescreption({
    super.key,
    required this.reportType,
    required this.reportDescerption,
  });
  final String reportType;
  final String reportDescerption;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reportType,
          style: AppStyles.bold22(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        Text(
          reportDescerption,
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
