import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RentalDetailsPriceSection extends StatelessWidget {
  const RentalDetailsPriceSection({
    super.key,
    required this.statusColor,
    required this.rentalItem,
  });

  final Color statusColor;
  final RentalHistoryItem rentalItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.theme.white100_2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: AppStyles.regular14(context).copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Gap(4),
                  Text(
                    '\$${rentalItem.finalPrice.toStringAsFixed(2)}',
                    style: AppStyles.bold28(context).copyWith(
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              if (rentalItem.discount > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_offer,
                        size: 16,
                        color: Colors.green[700],
                      ),
                      const Gap(4),
                      Text(
                        '${rentalItem.discount.toInt()}% OFF',
                        style: AppStyles.semiBold12(context).copyWith(
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
