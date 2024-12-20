import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_four_stars.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/utils/app_colors.dart';

class RatingNumberSection extends StatelessWidget {
  const RatingNumberSection(
      {super.key, required this.rating, required this.totalRaring});
  final double rating;
  final String totalRaring;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rating.toString(),
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w500,
          ),
        ),
        RatingFourStars(
          rating: rating,
          color: AppColors.myBlue100_2,
        ),
        const Gap(5),
        Text(
          totalRaring,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.myGray100_2,
          ),
        )
      ],
    );
  }
}
