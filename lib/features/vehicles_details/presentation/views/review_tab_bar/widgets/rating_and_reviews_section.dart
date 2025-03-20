import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_graph_section.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/themes/app_colors.dart';

class RatingAndReviewsSection extends StatelessWidget {
  const RatingAndReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rating and Reviews",
            style: AppStyles.bold18(context).copyWith(
              color: AppLightColors.myGray100_3,
            ),
          ),
          const RatingGraphSection()
        ],
      ),
    );
  }
}
