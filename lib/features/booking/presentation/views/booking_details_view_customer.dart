import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/presentation/views/payment_page.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_booking_period_with_total_duration_section.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_discount_row.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_pricing_details_section.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_vehicle_information_section.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_state.dart';
import 'package:aggar/features/rent_history/presentation/views/rent_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';

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
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
            } else if (state is BookingCancelError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is BookingConfirmSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              _navigateToPaymentPage(
                  context, state.clientSecret, state.bookingId);
            } else if (state is BookingConfirmError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<RentalHistoryCubit, RentalHistoryState>(
          listener: (context, state) {
            if (state is RentalHistoryRefundSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
            } else if (state is RentalHistoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
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
                  BookingDetailsVehicleInformationSection(booking: booking),
                  BookingDetailsBookingPeriodWithTotalDurationSection(
                      booking: booking),
                  BookingDetailsPricingDetailsSection(booking: booking),
                  if (booking.discount > 0)
                    BookingDetailsDiscountRow(booking: booking),
                  const Divider(height: 24),
                  Row(
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
                        style: AppStyles.semiBold16(context).copyWith(
                          color: context.theme.black100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
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
      return Column(
        children: [
          BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              final isLoading = state is BookingCancelLoading;

              return SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          _showCancelConfirmationDialog(context);
                        },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        )
                      : const Text(
                          'Cancel Booking',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      );
    } else if (status == 'accepted') {
      return BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          final isCancelLoading = state is BookingCancelLoading;
          final isConfirmLoading = state is BookingConfirmLoading;

          return Column(
            children: [
              // Confirm Booking Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isConfirmLoading || isCancelLoading
                      ? null
                      : () {
                          _handleConfirmBooking(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isConfirmLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Confirm & Pay',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              // Cancel Booking Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: isCancelLoading || isConfirmLoading
                      ? null
                      : () {
                          _showCancelConfirmationDialog(context);
                        },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isCancelLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        )
                      : const Text(
                          'Cancel Booking',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      );
    } else if (status == 'confirmed') {
      // Instead of showing buttons, redirect to rental history
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your booking has been confirmed and payment processed successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _navigateToRentalHistory(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'View in Rental History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You can manage your rental (scan QR code, request refunds, etc.) from the Rental History section.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
    }

    // No buttons for other statuses (rejected, canceled, etc.)
    return const SizedBox.shrink();
  }

  void _navigateToRentalHistory(BuildContext context) {
    try {
      // Navigate to rental history page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: context.read<RentalHistoryCubit>(),
            child: const RentHistoryView(),
          ),
        ),
      );
    } catch (e) {
      // Handle navigation error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error navigating to rental history: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text(
            'Are you sure you want to cancel this booking? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('No, Keep Booking'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleCancelBooking(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Yes, Cancel Booking'),
            ),
          ],
        );
      },
    );
  }

  void _handleCancelBooking(BuildContext context) {
    final bookingCubit = context.read<BookingCubit>();
    bookingCubit.cancelBooking(booking.id);
  }

  void _handleConfirmBooking(BuildContext context) {
    final bookingCubit = context.read<BookingCubit>();
    bookingCubit.confirmBooking(booking.id);
  }

  void _navigateToPaymentPage(
      BuildContext context, String? clientSecret, int bookingId) {
    if (clientSecret != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              clientSecret: clientSecret,
              bookingId: bookingId,
              amount: booking.finalPrice,
              booking: booking,
            ),
          ));
    } else {
      // Handle case where client secret is not provided
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment initialization failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
