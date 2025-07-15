import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/presentation/views/payment_page.dart';
import 'package:aggar/features/booking/presentation/widgets/booing_details_customer_pending_action_buttons.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_customer_accepted_action_buttons.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_customer_booking_period_with_total_duration_section.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_customer_conirmed_box.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_customer_discount_row.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_customer_pricing_details_section.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_customer_total_amout.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_customer_vehicle_information_section.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';
import 'package:gap/gap.dart';

class BookingDetailsScreenCustomer extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsScreenCustomer({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingCancelSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  context,
                  "Success",
                  state.message,
                  SnackBarType.success,
                ),
              );
              Navigator.pop(context, true);
            } else if (state is BookingCancelError) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  context,
                  "Error",
                  state.message,
                  SnackBarType.error,
                ),
              );
            } else if (state is BookingConfirmSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  context,
                  "Success",
                  state.message,
                  SnackBarType.success,
                ),
              );
              if (state.clientSecret != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        clientSecret: state.clientSecret!,
                        bookingId: state.bookingId,
                        amount: booking.finalPrice,
                        booking: booking,
                      ),
                    ));
              } else {
                // Handle case where client secret is not provided
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                    context,
                    "Error",
                    "Payment initialization failed. Please try again.",
                    SnackBarType.error,
                  ),
                );
              }
            } else if (state is BookingConfirmError) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  context,
                  "Error",
                  state.message,
                  SnackBarType.error,
                ),
              );
            }
          },
        ),
        BlocListener<RentalHistoryCubit, RentalHistoryState>(
          listener: (context, state) {
            if (state is RentalHistoryRefundSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  context,
                  "Success",
                  state.message,
                  SnackBarType.success,
                ),
              );
              Navigator.pop(context, true);
            } else if (state is RentalHistoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  context,
                  "Error",
                  state.message,
                  SnackBarType.error,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: context.theme.white100_1,
        appBar: AppBar(
          elevation: 1,
          shadowColor: Colors.grey[900],
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          backgroundColor: context.theme.white100_1,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(booking.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                booking.status,
                style: TextStyle(
                  color: _getStatusColor(booking.status),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.theme.black100,
            ),
            onPressed: () {
              print(booking.vehicleImagePath);
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Booking Details',
            style: AppStyles.semiBold24(context)
                .copyWith(color: context.theme.black100),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 0),
                    blurRadius: 4,
                  )
                ],
                color: context.theme.white100_2,
                borderRadius: BorderRadius.circular(15)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookingDetailsCustomerVehicleInformationSection(
                      booking: booking),
                  BookingDetailsCustomerBookingPeriodWithTotalDurationSection(
                      booking: booking),
                  BookingDetailsCustomerPricingDetailsSection(booking: booking),
                  if (booking.discount > 0)
                    BookingDetailsCustomerDiscountRow(booking: booking),
                  const Divider(height: 24),
                  BookingDetailsCustomerTotalAmout(booking: booking),
                  const Gap(5),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final status = booking.status.toLowerCase();

    if (status == 'pending') {
      return BooingDetailsCustomerPendingActionButtons(booking: booking);
    } else if (status == 'accepted') {
      return BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          final isCancelLoading = state is BookingCancelLoading;
          final isConfirmLoading = state is BookingConfirmLoading;

          return BookingDetailsCustomerAcceptedActionButtons(
              isConfirmLoading: isConfirmLoading,
              isCancelLoading: isCancelLoading,
              booking: booking);
        },
      );
    } else if (status == 'confirmed') {
      return const BookingDetailsCustomerConirmedBox();
    }
    return const SizedBox.shrink();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
      case 'confirmed':
        return Colors.green;
      case 'rejected':
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
