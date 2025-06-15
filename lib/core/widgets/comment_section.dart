import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/name_and_rate_section.dart';
import 'package:flutter/material.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({
    super.key,
    required this.name,
    required this.date,
    required this.commentText,
    required this.rate,
    required this.imageUrl,
    required this.id,
    required this.typeOfReport,
  });
  final String name;
  final String date;
  final String commentText;
  final double rate;
  final String imageUrl;
  final int id;
  final String typeOfReport;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: context.theme.blue100_7,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0),
              color: Colors.black26,
              blurRadius: 2,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NameAndRateSection(
                  imageUrl: imageUrl,
                  name: name,
                  rate: rate,
                  date: date,
                  reviewId: id,
                  typeOfReport: typeOfReport),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  commentText,
                  style: AppStyles.medium14(context).copyWith(
                    color: AppLightColors.myBlack50,
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
