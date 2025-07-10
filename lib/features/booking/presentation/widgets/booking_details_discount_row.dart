import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter/material.dart';

class BookingDetailsDiscountRow extends StatelessWidget {
  const BookingDetailsDiscountRow({
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
          'Discount',
          style: AppStyles.medium14(context).copyWith(
            color: context.theme.black50,
          ),
        ),
        Text(
          '-\$${booking.discount.toStringAsFixed(2)}',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.green100_1,
          ),
        ),
      ],
    );
  }
}
