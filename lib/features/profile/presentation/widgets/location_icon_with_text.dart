import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class LocationIconWithText extends StatelessWidget {
  const LocationIconWithText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Icon(
          Icons.map_outlined,
          size: 18,
          color: context.theme.blue100_2,
        ),
        Text(
          'Location on Map',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
      ],
    );
  }
}
