import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailsCustomerBookingPeriod extends StatelessWidget {
  const BookingDetailsCustomerBookingPeriod({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'START DATE',
                style: AppStyles.regular14(context).copyWith(
                  color: context.theme.blue100_1,
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(booking.startDate),
                style: AppStyles.bold16(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
              Text(
                DateFormat('h:mm a').format(booking.startDate),
                style: AppStyles.medium12(context).copyWith(
                  color: context.theme.black50,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'END DATE',
                style: AppStyles.regular14(context).copyWith(
                  color: context.theme.blue100_1,
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(booking.endDate),
                style: AppStyles.bold16(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
              Text(
                DateFormat('h:mm a').format(booking.endDate),
                style: AppStyles.medium12(context).copyWith(
                  color: context.theme.black50,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
