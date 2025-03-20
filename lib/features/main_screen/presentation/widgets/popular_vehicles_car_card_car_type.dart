import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class PopularVehiclesCarCardCarType extends StatelessWidget {
  const PopularVehiclesCarCardCarType({
    super.key,
    required this.carType,
  });

  final String carType;

  @override
  Widget build(BuildContext context) {
    return Text(
      carType,
      style: AppStyles.medium14(context).copyWith(
        color: AppLightColors.myBlack25,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
