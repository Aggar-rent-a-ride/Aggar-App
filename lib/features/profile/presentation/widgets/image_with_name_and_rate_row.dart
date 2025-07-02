import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/avatar_chat_view.dart';
import 'package:aggar/features/profile/presentation/widgets/rate_number_section_with_stars.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImageWithNameAndRateRow extends StatelessWidget {
  const ImageWithNameAndRateRow({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.date,
    required this.rate,
  });

  final String imageUrl;
  final String name;
  final String date;
  final double rate;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AvatarChatView(
          image: imageUrl,
          size: 40,
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppStyles.bold16(context).copyWith(
                  color: context.theme.black100,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                date,
                style: AppStyles.medium12(context).copyWith(
                  color: context.theme.black50,
                ),
              ),
            ],
          ),
        ),
        RateNumberSectionWithStars(
            rate: rate,
            containerColor: rate >= 4.0
                ? const Color(0xFFECFDF5)
                : rate >= 3.0
                    ? const Color(0xFFFFFBEA)
                    : const Color(0xFFFFF1F2),
            color: rate >= 4.0
                ? const Color(0xFF059669)
                : rate >= 3.0
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFFEF4444)),
      ],
    );
  }
}
