import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:flutter/material.dart';

class RentalDetailsStatusBox extends StatelessWidget {
  const RentalDetailsStatusBox({
    super.key,
    required this.statusColor,
    required this.rentalItem,
  });

  final Color statusColor;
  final RentalHistoryItem rentalItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        rentalItem.rentalStatus,
        style: AppStyles.semiBold14(context).copyWith(
          color: context.theme.white100_1,
        ),
      ),
    );
  }
}
