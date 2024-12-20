import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_graph_section.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_colors.dart';

class RatingAndReviewsSection extends StatelessWidget {
  const RatingAndReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //TODO:font !!!
        Text(
          "Rating and Reviews",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.myGray100_3,
            fontWeight: FontWeight.bold,
          ),
        ),
        const RatingGraphSection()
      ],
    );
  }
}
