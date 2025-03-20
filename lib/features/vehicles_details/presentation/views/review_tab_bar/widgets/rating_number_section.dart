import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_four_stars.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/themes/app_light_colors.dart';
import '../../../../../../core/utils/app_styles.dart' show AppStyles;

class RatingNumberSection extends StatelessWidget {
  const RatingNumberSection(
      {super.key, required this.rating, required this.totalRaring});
  final double rating;
  final String totalRaring;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          rating.toString(),
          style: AppStyles.medium65(context).copyWith(
            color: AppLightColors.myBlack100,
          ),
        ),
        RatingFourStars(
          rating: rating,
          color: AppLightColors.myBlue100_2,
        ),
        const Gap(5),
        /* Text(
          totalRaring,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.myGray100_2,
          ),
        )*/
      ],
    );
  }
}
