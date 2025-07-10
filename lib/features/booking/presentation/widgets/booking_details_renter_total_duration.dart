import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter/material.dart';

class BookingDetailsRenterTotalDuration extends StatelessWidget {
  const BookingDetailsRenterTotalDuration({
    super.key,
    required this.bookingData,
  });

  final BookingModel? bookingData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Duration',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        Text(
          '${bookingData!.totalDays} Day${bookingData!.totalDays > 1 ? 's' : ''}',
          style: AppStyles.bold18(context).copyWith(
            color: context.theme.black100,
          ),
        ),
      ],
    );
  }
}
