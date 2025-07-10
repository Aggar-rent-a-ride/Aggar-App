import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter/material.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
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
                      style: AppStyles.bold16(context),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(booking.bookingStatus)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: getStatusColor(booking.bookingStatus),
                        width: 1,
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
              const SizedBox(height: 8),
              Text(
                'Vehicle Type: ${booking.vehicleType}',
                style: AppStyles.medium14(context).copyWith(
                  color: context.theme.black50,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: context.theme.black50,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${formatDate(booking.startDate.toString())} - ${formatDate(booking.endDate.toString())}',
                    style: AppStyles.medium14(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.receipt,
                        size: 16,
                        color: context.theme.black50,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Booking #${booking.id}',
                        style: AppStyles.medium12(context).copyWith(
                          color: context.theme.black50,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${booking.finalPrice}',
                        style: AppStyles.bold16(context).copyWith(
                          color: context.theme.blue100_2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: context.theme.black50,
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
