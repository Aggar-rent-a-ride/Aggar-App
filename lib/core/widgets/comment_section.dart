import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/name_and_rate_section.dart';
import 'package:flutter/material.dart';

class CommentSection extends StatelessWidget {
  const CommentSection(
      {super.key,
      required this.name,
      required this.date,
      required this.commentText,
      required this.rate});
  final String name;
  final String date;
  final String commentText;
  final double rate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.myGreen100_1,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0),
              color: AppColors.myBlack25,
              spreadRadius: 0,
              blurRadius: 2,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              NameAndRateSection(
                imageUrl: AppAssets.assetsImagesAvatar,
                name: name,
                rate: rate,
                date: date,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  commentText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.myGray100_3,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
