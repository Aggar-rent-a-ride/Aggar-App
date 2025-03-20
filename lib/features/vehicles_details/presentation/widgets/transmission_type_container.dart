import 'package:aggar/core/themes/app_light_colors.dart';
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
            color: AppLightColors.myBlack25,
            offset: const Offset(0, 0),
            blurRadius: 4,
          ),
        ],
        color: AppLightColors.myBlue10_2,
      ),
      child: Text(
        transmissionType,
        style: AppStyles.semiBold12(context).copyWith(
          color: AppLightColors.myBlue100_2,
        ),
      ),
    );
  }
}
