import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooingDetailsCustomerPendingActionButtons extends StatelessWidget {
  const BooingDetailsCustomerPendingActionButtons({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            final isLoading = state is BookingCancelLoading;

            return SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                            title: 'Cancel Booking',
                            actionTitle: 'Yes, Cancel Booking',
                            subtitle:
                                'Are you sure you want to cancel this booking? This action cannot be undone.',
                            onPressed: () {
                              Navigator.pop(context);
                              final bookingCubit = context.read<BookingCubit>();
                              bookingCubit.cancelBooking(booking.id);
                            },
                          ),
                        );
                      },
                style: OutlinedButton.styleFrom(
                  backgroundColor: context.theme.red100_1,
                  side: BorderSide(
                    color: context.theme.red100_1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      )
                    : Text(
                        'Cancel Booking',
                        style: AppStyles.semiBold16(context).copyWith(
                          color: context.theme.white100_1,
                        ),
                      ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
