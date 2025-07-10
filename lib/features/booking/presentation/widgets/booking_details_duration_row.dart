import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter/material.dart';

class BookingDetailsDurationRow extends StatelessWidget {
  const BookingDetailsDurationRow({
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
          '${booking.totalDays} Day${booking.totalDays > 1 ? 's' : ''}',
          style: AppStyles.medium14(context).copyWith(
            color: context.theme.black50,
          ),
        ),
        Text(
          '\$${booking.price.toStringAsFixed(2)}',
          style: AppStyles.semiBold18(context).copyWith(
            color: context.theme.black100,
          ),
        ),
      ],
    );
  }
}
