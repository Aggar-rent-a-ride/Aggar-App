import 'package:aggar/core/widgets/comment_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_and_reviews_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/see_all_reviews_button.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_assets.dart' show AppAssets;

class ReviewTabBarView extends StatelessWidget {
  const ReviewTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 10,
      children: [
        RatingAndReviewsSection(),
        CommentSection(
          imageUrl: AppAssets.assetsImagesNotificationPic1,
          name: "Scarlett  Johansson",
          commentText: "Was a good deal, nice person but bad car , fix it mf",
          date: "11/8/2024",
          rate: 3,
        ),
        CommentSection(
          imageUrl: AppAssets.assetsImagesNotificationPic2,
          name: "Scarlett  Johansson",
          commentText: "Was a good deal, nice person but bad car , fix it mf",
          date: "11/8/2024",
          rate: 3,
        ),
        SeeAllReviewsButton()
      ],
    );
  }
}
