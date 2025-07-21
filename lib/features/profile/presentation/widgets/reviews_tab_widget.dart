import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/profile/presentation/widgets/review_list.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_number_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReviewsTabWidget extends StatelessWidget {
  const ReviewsTabWidget({super.key, required this.user, this.rate});

  final UserModel user;
  final double? rate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(
                  Icons.reviews_outlined,
                  size: 18,
                  color: context.theme.blue100_2,
                ),
                const Gap(8),
                Text(
                  'Review and Rating',
                  style: AppStyles.semiBold16(
                    context,
                  ).copyWith(color: context.theme.black100),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                rate == null
                    ? const SizedBox()
                    : RatingNumberSection(rating: rate),
                Expanded(
                  child: Text(
                    "Rating and reviews are verified and are from people who rent the same type of vehicle that you rent",
                    style: AppStyles.medium15(
                      context,
                    ).copyWith(color: context.theme.black50),
                  ),
                ),
              ],
            ),
            ReviewList(userId: user.id.toString()),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
