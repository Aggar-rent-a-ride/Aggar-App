import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BookingCardWidget extends StatelessWidget {
  final BookingHistoryModel booking;
  final VoidCallback onTap;
  final Color Function(String) getStatusColor;
  final String Function(String) formatDate;

  const BookingCardWidget({
    super.key,
    required this.booking,
    required this.onTap,
    required this.getStatusColor,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.white100_2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${booking.vehicleBrand} ${booking.vehicleModel}',
                      style: AppStyles.bold20(context).copyWith(
                        color: context.theme.black100,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(booking.bookingStatus)
                          .withOpacity(0.07),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: getStatusColor(booking.bookingStatus),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      booking.bookingStatus,
                      style: AppStyles.medium12(context).copyWith(
                        color: getStatusColor(booking.bookingStatus),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(4),
              Text(
                'Vehicle Type: ${booking.vehicleType}',
                style: AppStyles.medium13(context).copyWith(
                  color: context.theme.black25,
                ),
              ),
              const Gap(35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: context.theme.black50,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${formatDate(booking.startDate.toString())} - ${formatDate(booking.endDate.toString())}',
                        style: AppStyles.medium14(context).copyWith(
                          color: context.theme.black50,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'see more details',
                        style: AppStyles.regular13(context).copyWith(
                          color: context.theme.blue100_1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 13,
                        color: context.theme.blue100_1,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
