import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class OwnerNameSection extends StatelessWidget {
  const OwnerNameSection({
    super.key,
    required this.renterName,
  });
  final String renterName;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            renterName,
            style: AppStyles.bold16(context).copyWith(
              color: context.theme.blue100_2,
            ),
          ),
          Text(
            "Owner",
            style: AppStyles.semiBold14(context).copyWith(
              color: context.theme.black50,
            ),
          ),
        ],
      ),
    );
  }
}
