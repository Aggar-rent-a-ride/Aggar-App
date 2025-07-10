import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter/material.dart';

class BookingDetailsCustomerTotalAmout extends StatelessWidget {
  const BookingDetailsCustomerTotalAmout({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Amount',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        Text(
          '\$${booking.finalPrice.toStringAsFixed(2)}',
          style: AppStyles.semiBold20(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
      ],
    );
  }
}
