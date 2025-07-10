import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:aggar/features/rent_history/presentation/widgets/rental_details_date_range_section.dart';
import 'package:aggar/features/rent_history/presentation/widgets/rental_details_price_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RentalDetailsRentalSummarySection extends StatelessWidget {
  const RentalDetailsRentalSummarySection({
    super.key,
    required this.statusColor,
    required this.rentalItem,
  });

  final Color statusColor;
  final RentalHistoryItem rentalItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.theme.white100_2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rental Summary',
                      style: AppStyles.bold20(context).copyWith(
                        color: statusColor,
                      ),
                    ),
                    Text(
                      'Complete rental overview',
                      style: AppStyles.regular14(context).copyWith(
                        color: context.theme.black50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(24),
          RentalDetailsDateRangeSection(
              statusColor: statusColor, rentalItem: rentalItem),
          const Gap(16),
          RentalDetailsPriceSection(
              statusColor: statusColor, rentalItem: rentalItem),
        ],
      ),
    );
  }
}
