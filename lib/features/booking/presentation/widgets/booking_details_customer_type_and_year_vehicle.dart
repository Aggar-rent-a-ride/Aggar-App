import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter/material.dart';

class BookingDetailsCustomerTypeAndYearVehicle extends StatelessWidget {
  const BookingDetailsCustomerTypeAndYearVehicle({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        if (booking.vehicleType != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: context.theme.blue100_1.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              spacing: 5,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.directions_car,
                  size: 12,
                  color: context.theme.blue100_1,
                ),
                Text(
                  booking.vehicleType!,
                  style: AppStyles.medium14(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                ),
              ],
            ),
          ),
        ],
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: context.theme.blue100_1.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Year: ${booking.vehicleYear}',
            style: AppStyles.medium14(context).copyWith(
              color: context.theme.blue100_1,
            ),
          ),
        ),
      ],
    );
  }
}
