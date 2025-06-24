import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/profile/presentation/widgets/review_card.dart';
import 'package:aggar/features/vehicle_details_after_add/data/model/review_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewUserList extends StatelessWidget {
  const ReviewUserList({
    super.key,
    required ScrollController scrollController,
    required this.reviews,
    required this.canLoadMore,
    required this.isLoadingMore,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<ReviewModel> reviews;
  final bool canLoadMore;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              controller: _scrollController,
              itemCount:
                  reviews.length + (canLoadMore || isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == reviews.length) {
                  if (isLoadingMore) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: context.theme.blue100_8,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }

                final review = reviews[index];
                return ReviewCard(
                  imageUrl: review.reviewer.imagePath ?? "",
                  name: review.reviewer.name,
                  commentText: review.comments,
                  date: DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(review.createdAt)),
                  rate: review.rate,
                  id: review.id,
                  typeOfReport: "CustomerReview",
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
