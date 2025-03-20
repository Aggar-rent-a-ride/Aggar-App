import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart' show AppStyles;
import 'package:flutter/material.dart';

class BottomNavigationBarRentalPrice extends StatelessWidget {
  const BottomNavigationBarRentalPrice({
    super.key,
    required this.price,
  });
  final double price;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Rental Price",
            style: AppStyles.bold18(context).copyWith(
              color: AppLightColors.myGray100_2,
            ),
          ),
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '$price\$',
                  style: AppStyles.bold28(context).copyWith(
                    color: AppLightColors.myBlue100_2,
                  ), // Bold text style
                ),
                const TextSpan(
                  text: '/day',
                ),
              ],
            ),
            style: AppStyles.medium20(context).copyWith(
              color: AppLightColors.myBlack50,
            ), // Base text style
          ),
        ],
      ),
    );
  }
}
