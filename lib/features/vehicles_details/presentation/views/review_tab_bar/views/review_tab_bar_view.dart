import 'package:aggar/core/widgets/comment_section.dart';
import 'package:aggar/core/widgets/text_with_arrow_back_button.dart';

import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/widgets/review_vehicle_screen.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/loading_review_and_rating.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_and_reviews_section.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../../vehicle_details_after_add/presentation/cubit/review_cubit/review_state.dart';

class ReviewTabBarView extends StatelessWidget {
  const ReviewTabBarView({
    super.key,
    this.vehicleRate,
    required this.vehicleId,
  });
  final double? vehicleRate;
  final String vehicleId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        if (state is ReviewLoading) {
          return const LoadingReviewAndRating();
        } else if (state is ReviewSuccess) {
          final reviews = state.review!.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10,
              children: [
                RatingAndReviewsSection(vehicleRate: vehicleRate),
                ...reviews
                    .take(5)
                    .map(
                      (review) => CommentSection(
                        imageUrl: review.reviewer.imagePath ?? "",
                        name: review.reviewer.name,
                        commentText: review.comments,
                        date: DateFormat(
                          'dd/MM/yyyy',
                        ).format(DateTime.parse(review.createdAt)),
                        rate: review.rate,
                        id: review.id,
                        typeOfReport: "CustomerReview",
                      ),
                    ),
                if (reviews.length > 2)
                  TextWithArrowBackButton(
                    text: 'see all reviews',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewVehicleScreen(
                            vehicleId: vehicleId,
                            type: "CustomerReview",
                          ),
                        ),
                      );
                    },
                  ),
                const Gap(25),
              ],
            ),
          );
        } else if (state is ReviewFailure) {
          return Center(child: Text('Error: ${state.errorMsg}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
