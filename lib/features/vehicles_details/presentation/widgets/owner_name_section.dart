import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class OwnerNameSection extends StatelessWidget {
  const OwnerNameSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO: style here will be change
          Text(
            "Brian Smith",
            style: TextStyle(
              color: AppColors.myBlack100,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          //TODO: style here will be change
          Text(
            "Owner",
            style: TextStyle(
              color: AppColors.myGray100_2,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
