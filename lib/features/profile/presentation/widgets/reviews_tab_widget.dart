import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_number_section.dart';
import 'package:flutter/material.dart';

class ReviewsTabWidget extends StatelessWidget {
  const ReviewsTabWidget({
    super.key,
    required this.user,
    this.rate,
  });

  final UserModel user;
  final double? rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Rating and Reviews",
              style: AppStyles.bold18(context).copyWith(
                color: context.theme.blue100_1,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                rate == null
                    ? const SizedBox()
                    : RatingNumberSection(
                        rating: rate,
                      ),
                Expanded(
                  child: Text(
                    "Rating and reviews are verified and are from people who rent the same type of vehicle that you rent  ",
                    style: AppStyles.medium15(context).copyWith(
                      color: context.theme.black50,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
