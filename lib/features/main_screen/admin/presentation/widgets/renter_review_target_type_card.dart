import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/rating_row_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class RenterReviewTargetTypeCard extends StatelessWidget {
  const RenterReviewTargetTypeCard({
    super.key,
    required this.rentalId,
    required this.createdAt,
    required this.behavior,
    required this.punctuality,
    required this.comments,
    required this.care,
  });

  final int rentalId;
  final String createdAt;
  final double behavior;
  final double punctuality;
  final String comments;
  final double care;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy, h:mm a');
    final formattedDate = dateFormat.format(DateTime.parse(createdAt));

    return Container(
      decoration: BoxDecoration(
        color: context.theme.blue10_2,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 0)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rating",
              style: AppStyles.bold20(
                context,
              ).copyWith(color: context.theme.black100),
            ),
            const Gap(5),
            RatingRowSection(
              behavior: behavior,
              punctuality: punctuality,
              careOrtruthfulness: care,
            ),
            const Gap(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Comments",
                  style: AppStyles.bold20(
                    context,
                  ).copyWith(color: context.theme.black100),
                ),
                Text(
                  comments,
                  style: AppStyles.medium14(
                    context,
                  ).copyWith(color: context.theme.black50),
                ),
              ],
            ),
            const Gap(10),
            Text(
              formattedDate,
              style: AppStyles.regular12(
                context,
              ).copyWith(color: context.theme.black50),
            ),
          ],
        ),
      ),
    );
  }
}
