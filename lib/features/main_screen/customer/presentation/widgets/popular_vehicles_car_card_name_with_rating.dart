import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PopularVehiclesCarCardNameWithRating extends StatelessWidget {
  const PopularVehiclesCarCardNameWithRating({
    super.key,
    required this.carName,
    required this.rating,
  });

  final String carName;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            carName,
            style: AppStyles.semiBold24(context).copyWith(
              color: context.theme.black100,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (rating != null) ...[
          const Gap(5),
          Icon(
            Icons.star,
            size: 12,
            color: context.theme.blue100_2,
          ),
          Text(
            rating!.toString(),
            style: AppStyles.semiBold12(context).copyWith(
              color: context.theme.blue100_2,
            ),
          ),
        ] else
          const SizedBox(),
      ],
    );
  }
}
