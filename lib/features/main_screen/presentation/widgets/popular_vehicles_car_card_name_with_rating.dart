import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class PopularVehiclesCarCardNameWithRating extends StatelessWidget {
  const PopularVehiclesCarCardNameWithRating({
    super.key,
    required this.carName,
    required this.rating,
  });

  final String carName;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.32,
          child: Text(
            carName,
            style: AppStyles.semiBold24(context),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        Icon(
          Icons.star,
          size: 12,
          color: context.theme.blue100_2,
        ),
        Text(
          rating.toString(),
          style: AppStyles.semiBold12(context).copyWith(
            color: context.theme.blue100_2,
          ),
        ),
      ],
    );
  }
}
