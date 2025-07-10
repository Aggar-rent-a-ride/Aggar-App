import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_renter_booking_period.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_renter_total_duration.dart';
import 'package:flutter/material.dart';

class BookingDetailsRenterBookingPeriodWithTotalDurationSection
    extends StatelessWidget {
  const BookingDetailsRenterBookingPeriodWithTotalDurationSection({
    super.key,
    required this.bookingData,
  });

  final BookingModel? bookingData;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Period',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        BookingDetailsRenterBookingPeriod(bookingData: bookingData),
        BookingDetailsRenterTotalDuration(bookingData: bookingData),
      ],
    );
  }
}
