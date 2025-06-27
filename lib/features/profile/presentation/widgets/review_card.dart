import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

class ReviewCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String commentText;
  final String date;
  final double rate;
  final int id;
  final String typeOfReport;
  final VoidCallback? onTap;

  const ReviewCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.commentText,
    required this.date,
    required this.rate,
    required this.id,
    required this.typeOfReport,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.white100_1,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.theme.gray100_1.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: context.theme.blue100_1.withOpacity(0.1),
                  child: Text(
                    name[1],
                    style: AppStyles.bold16(context).copyWith(
                      color: context.theme.blue100_1,
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppStyles.bold14(context).copyWith(
                          color: context.theme.blue100_1,
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                                5,
                                (starIndex) => Icon(
                                      Icons.star,
                                      size: 14,
                                      color: starIndex < (rate)
                                          ? Colors.amber
                                          : context.theme.gray100_1,
                                    )),
                          ),
                          const Gap(8),
                          Text(
                            date,
                            style: AppStyles.medium12(context).copyWith(
                              color: context.theme.gray100_2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(12),
            Text(
              commentText,
              style: AppStyles.medium14(context).copyWith(
                color: context.theme.gray100_2,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
