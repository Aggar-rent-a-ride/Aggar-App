import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class RentalCard extends StatelessWidget {
  final RentalHistoryItem rental;
  final VoidCallback onViewMore;

  const RentalCard({super.key, required this.rental, required this.onViewMore});

  // Helper method to get status colors - only 3 values
  Map<String, Color> _getStatusColors(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return {
          'color': Colors.green,
          'bgColor': Colors.green.withOpacity(0.15),
        };
      case 'notstarted':
        return {
          'color': Colors.orange,
          'bgColor': Colors.orange.withOpacity(0.15),
        };
      case 'refunded':
        return {'color': Colors.red, 'bgColor': Colors.red.withOpacity(0.15)};
      default:
        return {'color': Colors.grey, 'bgColor': Colors.grey.withOpacity(0.15)};
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColors = _getStatusColors(rental.rentalStatus);
    final statusColor = statusColors['color']!;
    final statusBgColor = statusColors['bgColor']!;
    final statusText = rental.rentalStatus;

    final dateFormat = DateFormat('dd/MM/yyyy');
    final startDate = dateFormat.format(rental.startDate);
    final totalTime = '${rental.totalDays} Days';

    return Container(
      decoration: BoxDecoration(
        color: context.theme.white100_2,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(blurRadius: 2, color: Colors.black12, offset: Offset(0, 0)),
        ],
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
                        border: Border.all(
                          color: context.theme.black50.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: context.theme.black50.withOpacity(0.5),
                      ),
                    ),
                    const Gap(10),
                    Text(
                      '#${rental.id}',
                      style: AppStyles.semiBold18(
                        context,
                      ).copyWith(color: context.theme.black100),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        statusText,
                        style: AppStyles.medium15(
                          context,
                        ).copyWith(color: statusColor),
                      ),
                    ],
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
                      style: AppStyles.regular16(
                        context,
                      ).copyWith(color: context.theme.black25),
                    ),
                    const Gap(5),
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: context.theme.blue100_1.withOpacity(0.2),
                            shape: BoxShape.circle,
                            image:
                                rental.user.imagePath != null &&
                                    rental.user.imagePath!.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(
                                      EndPoint.baseUrl + rental.user.imagePath!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child:
                              rental.user.imagePath == null ||
                                  rental.user.imagePath!.isEmpty
                              ? Center(
                                  child: Text(
                                    rental.user.name.isNotEmpty
                                        ? rental.user.name[0]
                                        : '',
                                    style: AppStyles.medium16(
                                      context,
                                    ).copyWith(color: context.theme.black100),
                                  ),
                                )
                              : null,
                        ),
                        const Gap(10),
                        Text(
                          rental.user.name,
                          style: AppStyles.medium18(
                            context,
                          ).copyWith(color: context.theme.black100),
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
                      style: AppStyles.regular16(
                        context,
                      ).copyWith(color: context.theme.black25),
                    ),
                    const Gap(5),
                    Text(
                      totalTime,
                      style: AppStyles.medium18(
                        context,
                      ).copyWith(color: context.theme.black50),
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
                      style: AppStyles.regular16(
                        context,
                      ).copyWith(color: context.theme.black25),
                    ),
                    const Gap(5),
                    Text(
                      '${rental.finalPrice} \$',
                      style: AppStyles.bold16(
                        context,
                      ).copyWith(color: context.theme.blue100_1),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Start date',
                      style: AppStyles.regular16(
                        context,
                      ).copyWith(color: context.theme.black25),
                    ),
                    const Gap(5),
                    Text(
                      startDate,
                      style: AppStyles.medium16(
                        context,
                      ).copyWith(color: context.theme.black50),
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
                  side: BorderSide(
                    color: context.theme.black100,
                  ), // Fixed blue color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'View more',
                  style: AppStyles.medium16(
                    context,
                  ).copyWith(color: context.theme.black100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
