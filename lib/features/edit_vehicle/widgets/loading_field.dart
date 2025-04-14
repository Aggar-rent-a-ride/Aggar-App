import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:flutter/material.dart';

class LoadingField extends StatelessWidget {
  const LoadingField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 80,
            color: AppLightColors.myWhite100_1,
          ),
          Container(
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppLightColors.myWhite100_1,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}
