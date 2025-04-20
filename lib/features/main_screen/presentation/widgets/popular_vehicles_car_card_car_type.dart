import 'package:aggar/core/extensions/context_colors_extension.dart';
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
        color: context.theme.black25,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
