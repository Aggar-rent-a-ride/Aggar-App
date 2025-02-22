import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class TransmissionTypeContainer extends StatelessWidget {
  const TransmissionTypeContainer({
    super.key,
    required this.transmissionType,
  });

  final String transmissionType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AppColors.myBlack25,
            offset: const Offset(0, 0),
            blurRadius: 4,
          ),
        ],
        color: AppColors.myBlue100_8,
      ),
      child: Text(
        transmissionType,
        style: AppStyles.semiBold12(context).copyWith(
          color: AppColors.myBlue100_2,
        ),
      ),
    );
  }
}
