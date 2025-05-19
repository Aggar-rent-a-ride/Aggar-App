import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ReportStatusContainer extends StatelessWidget {
  const ReportStatusContainer({
    super.key,
    this.containerColor,
    this.textColor,
    required this.statusText,
  });
  final Color? containerColor;
  final Color? textColor;
  final String statusText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: containerColor,
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
        statusText,
        style: AppStyles.medium12(context).copyWith(
          color: textColor,
        ),
      ),
    );
  }
}
