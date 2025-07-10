import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_renter_daily_rate_row.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_renter_duration_row.dart';
import 'package:flutter/material.dart';

class BookingDetailsRenterPricingDetailsSection extends StatelessWidget {
  const BookingDetailsRenterPricingDetailsSection({
    super.key,
    required this.bookingData,
  });

  final BookingModel? bookingData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pricing Details',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        BookingDetailsRenterDailyRateRow(bookingData: bookingData),
        BookingDetailsRenterDurationRow(bookingData: bookingData),
      ],
    );
  }
}
