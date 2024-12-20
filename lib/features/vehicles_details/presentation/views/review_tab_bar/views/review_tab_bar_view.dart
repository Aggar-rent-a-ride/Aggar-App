import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/comment_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_and_reviews_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/see_all_reviews_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReviewTabBarView extends StatelessWidget {
  const ReviewTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Gap(20),
          RatingAndReviewsSection(),
          CommentSection(
            name: "Scarlett  Johansson",
            commentText: "Was a good deal, nice person but bad car , fix it mf",
            date: "11/8/2024",
            rate: 3,
          ),
          CommentSection(
            name: "Scarlett  Johansson",
            commentText: "Was a good deal, nice person but bad car , fix it mf",
            date: "11/8/2024",
            rate: 3,
          ),
          SeeAllReviewsButton()
        ],
      ),
    );
  }
}
