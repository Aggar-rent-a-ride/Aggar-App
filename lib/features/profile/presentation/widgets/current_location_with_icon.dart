import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CurrentLocationWithIcon extends StatelessWidget {
  const CurrentLocationWithIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Icon(
          Icons.my_location_rounded,
          size: 18,
          color: context.theme.blue100_2,
        ),
        Text(
          'Current Location',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
      ],
    );
  }
}
