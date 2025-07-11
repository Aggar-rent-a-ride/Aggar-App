import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class RentalDetailsDateRangeSection extends StatelessWidget {
  const RentalDetailsDateRangeSection({
    super.key,
    required this.statusColor,
    required this.rentalItem,
  });

  final Color statusColor;
  final RentalHistoryItem rentalItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.white100_2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.theme.black10,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: statusColor,
                size: 20,
              ),
              const Gap(8),
              Text(
                'Rental Period',
                style: AppStyles.semiBold16(context).copyWith(
                  color: statusColor,
                ),
              ),
            ],
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Date',
                      style: AppStyles.regular12(context).copyWith(
                        color: context.theme.black50,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      DateFormat('dd MMM yyyy').format(rentalItem.startDate),
                      style: AppStyles.semiBold14(context).copyWith(
                        color: context.theme.black100,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: context.theme.white100_4,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: context.theme.blue100_1,
                    ),
                    const Gap(4),
                    Text(
                      '${rentalItem.endDate.difference(rentalItem.startDate).inDays + 1} days',
                      style: AppStyles.medium12(context).copyWith(
                        color: context.theme.blue100_1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'End Date',
                      style: AppStyles.regular12(context).copyWith(
                        color: context.theme.black50,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      DateFormat('dd MMM yyyy').format(rentalItem.endDate),
                      style: AppStyles.semiBold14(context).copyWith(
                        color: context.theme.black100,
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
