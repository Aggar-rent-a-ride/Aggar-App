import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_customer_daily_rate_row.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_customer_duration_row.dart';

import 'package:flutter/material.dart';

class BookingDetailsCustomerPricingDetailsSection extends StatelessWidget {
  const BookingDetailsCustomerPricingDetailsSection({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

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
        BookingDetailsCustomerDailyRateRow(booking: booking),
        BookingDetailsCustomerDurationRow(booking: booking),
      ],
    );
  }
}
