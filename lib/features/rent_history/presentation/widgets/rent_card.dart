import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rent_history_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class RentalCard extends StatelessWidget {
  final RentalHistoryItem rental;
  final VoidCallback onViewMore;

  const RentalCard({
    super.key,
    required this.rental,
    required this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBgColor;
    String statusText = rental.rentalStatus;

    switch (rental.rentalStatus) {
      case 'Completed':
        statusColor = Colors.teal;
        statusBgColor = Colors.tealAccent.withOpacity(0.2);
        break;
      case 'In Progress':
        statusColor = Colors.deepOrange;
        statusBgColor = Colors.deepOrange.withOpacity(0.1);
        break;
      case 'Not Started':
        statusColor = Colors.orange;
        statusBgColor = Colors.orange.withOpacity(0.1);
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        statusBgColor = Colors.red.withOpacity(0.1);
        break;
      default:
        statusColor = Colors.grey;
        statusBgColor = Colors.grey.withOpacity(0.1);
    }

    // Format dates and duration
    final dateFormat = DateFormat('dd/MM/yyyy');
    final startDate = dateFormat.format(rental.startDate);
    final endDate = dateFormat.format(rental.endDate);
    final totalTime = '${rental.totalDays} Days';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.calendar_today, size: 20),
                    ),
                    const Gap(10),
                    Text(
                      '#${rental.id}',
                      style: AppStyles.semiBold18(context),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    statusText,
                    style: AppStyles.medium15(context)
                        .copyWith(color: statusColor),
                  ),
                ),
              ],
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client Name',
                      style: AppStyles.regular16(context)
                          .copyWith(color: Colors.grey),
                    ),
                    const Gap(5),
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDDDDDD),
                            shape: BoxShape.circle,
                            image: rental.user.imagePath.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(rental.user.imagePath),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: rental.user.imagePath.isEmpty
                              ? Center(
                                  child: Text(
                                    rental.user.name.isNotEmpty
                                        ? rental.user.name[0]
                                        : '',
                                    style: AppStyles.medium16(context)
                                        .copyWith(color: Colors.white),
                                  ),
                                )
                              : null,
                        ),
                        const Gap(10),
                        Text(
                          rental.user.name,
                          style: AppStyles.medium18(context),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Time',
                      style: AppStyles.regular16(context)
                          .copyWith(color: Colors.grey),
                    ),
                    const Gap(5),
                    Text(
                      totalTime,
                      style: AppStyles.medium18(context),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle ID: ${rental.vehicle.id}',
                      style: AppStyles.regular16(context)
                          .copyWith(color: Colors.grey),
                    ),
                    const Gap(5),
                    Text(
                      '${rental.finalPrice} \$',
                      style: AppStyles.bold16(context)
                          .copyWith(color: Colors.black87),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Start date',
                      style: AppStyles.regular16(context)
                          .copyWith(color: Colors.grey),
                    ),
                    const Gap(5),
                    Text(
                      startDate,
                      style: AppStyles.medium16(context),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(15),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onViewMore,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'View more',
                  style: AppStyles.medium16(context)
                      .copyWith(color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
