import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/see_more_button.dart';
import 'package:aggar/features/profile/presentation/views/review_error_screen.dart';
import 'package:aggar/features/profile/presentation/views/review_user_screen.dart';
import 'package:aggar/features/profile/presentation/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import '../../../vehicle_details_after_add/presentation/cubit/review_cubit/review_state.dart';

class ReviewUserSection extends StatelessWidget {
  const ReviewUserSection({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        if (state is ReviewLoading) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ReviewSuccess) {
          final vehicles = state.review!.data;
          if (vehicles.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rate_review_outlined,
                        size: 50, color: context.theme.blue100_2),
                    const SizedBox(height: 10),
                    Text(
                      'No reviews yet',
                      style: AppStyles.medium16(context).copyWith(
                        color: context.theme.black50,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  children: vehicles
                      .asMap()
                      .entries
                      .map(
                        (entry) => ReviewCard(
                          imageUrl: entry.value.reviewer.imagePath ?? "",
                          name: entry.value.reviewer.name,
                          commentText: entry.value.comments,
                          date: entry.value.createdAt,
                          rate: entry.value.rate,
                          id: entry.value.id,
                        ),
                      )
                      .toList(),
                ),
                SeeMoreButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewUserScreen(
                          userId: userId,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        } else {
          return const ReviewErrorScreen();
        }
      },
    );
  }
}
