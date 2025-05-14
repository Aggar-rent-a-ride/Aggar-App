import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rental_info.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RentalCard extends StatelessWidget {
  final RentalInfo rental;

  const RentalCard({
    super.key,
    required this.rental,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBgColor;
    String statusText;

    switch (rental.status) {
      case RentalStatus.Completed:
        statusColor = Colors.teal;
        statusBgColor = Colors.tealAccent.withOpacity(0.2);
        statusText = 'Completed';
        break;
      case RentalStatus.InProgress:
        statusColor = Colors.deepOrange;
        statusBgColor = Colors.deepOrange.withOpacity(0.1);
        statusText = 'In Progress';
        break;
      case RentalStatus.NotStarted:
        statusColor = Colors.orange;
        statusBgColor = Colors.orange.withOpacity(0.1);
        statusText = 'Not Started';
        break;
      case RentalStatus.Cancelled:
        statusColor = Colors.red;
        statusBgColor = Colors.red.withOpacity(0.1);
        statusText = 'Cancelled';
        break;
    }

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
                      rental.id,
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
                          decoration: const BoxDecoration(
                            color: Color(0xFFDDDDDD),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              rental.clientName.isNotEmpty
                                  ? rental.clientName[0]
                                  : '',
                              style: AppStyles.medium16(context)
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        const Gap(10),
                        Text(
                          rental.clientName,
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
                      rental.totalTime,
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
                      rental.carNameId,
                      style: AppStyles.regular16(context)
                          .copyWith(color: Colors.grey),
                    ),
                    const Gap(5),
                    Text(
                      rental.carModel,
                      style: AppStyles.bold16(context)
                          .copyWith(color: Colors.black87),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Arrival time',
                      style: AppStyles.regular16(context)
                          .copyWith(color: Colors.grey),
                    ),
                    const Gap(5),
                    Text(
                      rental.arrivalTime,
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
                onPressed: () {},
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
