import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_renter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class BookingDetailsRenterActionButtons extends StatelessWidget {
  const BookingDetailsRenterActionButtons({
    super.key,
    required this.bookingData,
    required this.widget,
  });

  final BookingModel? bookingData;
  final BookingDetailsScreenRenter widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => CustomDialog(
                title: 'Decline Booking',
                actionTitle: 'Decline',
                subtitle:
                    'Are you sure you want to decline this booking request? This action cannot be undone.',
                onPressed: () {
                  Navigator.pop(context);
                  context
                      .read<BookingCubit>()
                      .rejectBooking(bookingData?.id ?? widget.booking.id);
                },
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.theme.red100_1,
              foregroundColor: context.theme.red100_1,
              side: BorderSide(
                color: context.theme.red100_1,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Decline',
              style: AppStyles.semiBold16(context).copyWith(
                color: context.theme.white100_1,
              ),
            ),
          ),
        ),
        const Gap(12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CustomDialog(
                  title: 'Accept Booking',
                  actionTitle: "Accept",
                  buttonColor: context.theme.blue100_1,
                  textColor: context.theme.white100_1,
                  subtitle:
                      'Are you sure you want to accept this booking request? This action cannot be undone.',
                  onPressed: () async {
                    Navigator.pop(context);
                    await context
                        .read<BookingCubit>()
                        .acceptBooking(bookingData?.id ?? widget.booking.id);
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.theme.blue100_1,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Accept Booking',
              style: AppStyles.semiBold16(context).copyWith(
                color: context.theme.white100_1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
