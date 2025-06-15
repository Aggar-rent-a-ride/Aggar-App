import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/comment_section.dart';
import 'package:aggar/core/widgets/text_with_arrow_back_button.dart';

import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/loading_review_and_rating.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_and_reviews_section.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ReviewTabBarView extends StatelessWidget {
  const ReviewTabBarView({
    super.key,
    this.vehicleRate,
  });
  final double? vehicleRate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        if (state is ReviewLoading) {
          return const LoadingReviewAndRating();
        } else if (state is ReviewVehicleSuccess) {
          final reviews = state.review!.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10,
              children: [
                RatingAndReviewsSection(
                  vehicleRate: vehicleRate,
                ),
                if (reviews.isEmpty)
                  Center(
                      child: Text(
                    'No reviews available',
                    style: AppStyles.medium16(context)
                        .copyWith(color: context.theme.black50),
                  )),
                ...reviews.take(10).map(
                      (review) => CommentSection(
                        imageUrl: review.reviewer.imagePath ?? "",
                        name: review.reviewer.name,
                        commentText: review.comments,
                        date: DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(review.createdAt)),
                        rate: review.rate,
                        id: review.id,
                        typeOfReport: "CustomerReview",
                      ),
                    ),
                if (reviews.length > 2)
                  TextWithArrowBackButton(
                    text: 'see all reviews',
                    onPressed: () {
                      //TODO
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
