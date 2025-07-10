import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingDetailsCustomerAcceptedActionButtons extends StatelessWidget {
  const BookingDetailsCustomerAcceptedActionButtons({
    super.key,
    required this.isConfirmLoading,
    required this.isCancelLoading,
    required this.booking,
  });

  final bool isConfirmLoading;
  final bool isCancelLoading;
  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isConfirmLoading || isCancelLoading
                ? null
                : () {
                    final bookingCubit = context.read<BookingCubit>();
                    bookingCubit.confirmBooking(booking.id);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.theme.blue100_1,
              foregroundColor: context.theme.blue100_1,
              side: BorderSide(
                color: context.theme.blue100_1,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isConfirmLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Confirm & Pay',
                    style: AppStyles.semiBold16(context).copyWith(
                      color: context.theme.white100_1,
                    ),
                  ),
          ),
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: isCancelLoading || isConfirmLoading
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
            child: isCancelLoading
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
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
