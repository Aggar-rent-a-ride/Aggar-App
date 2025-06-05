import 'package:aggar/core/widgets/comment_section.dart';
import 'package:aggar/core/widgets/text_with_arrow_back_button.dart';

import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_and_reviews_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart' show Gap;
import 'package:intl/intl.dart' show DateFormat;

class ReviewTabBarView extends StatelessWidget {
  const ReviewTabBarView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        if (state is ReviewLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReviewVehicleSuccess) {
          final reviews = state.review!.data;
          return Column(
            spacing: 10,
            children: [
              const RatingAndReviewsSection(),
              if (reviews.isEmpty)
                const Center(child: Text('No reviews available')),
              ...reviews.take(state.review!.data.length).map(
                    (review) => CommentSection(
                      imageUrl: review.reviewer.imagePath ?? "",
                      name: review.reviewer.name,
                      commentText: review.comments,
                      date: DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(review.createdAt)),
                      rate: review.rate,
                    ),
                  ),
              if (reviews.length > 2)
                const TextWithArrowBackButton(text: 'see all reviews'),
              const Gap(25),
            ],
          );
        } else if (state is ReviewFailure) {
          return Center(child: Text('Error: ${state.errorMsg}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
