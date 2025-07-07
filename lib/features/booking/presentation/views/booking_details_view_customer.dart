import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/presentation/views/payment_page.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_booking_period.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_type_and_year_vehicle.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_vehicle_image.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_state.dart';
import 'package:aggar/features/rent_history/presentation/views/rent_history_view.dart';
import 'package:aggar/features/rent_history/presentation/views/scanner_qr_code_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

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
        // New RentalHistoryCubit listener for refund states
        BlocListener<RentalHistoryCubit, RentalHistoryState>(
          listener: (context, state) {
            if (state is RentalHistoryRefundSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate back to refresh the bookings list
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
                  Text(
                    'Pricing Details',
                    style: AppStyles.semiBold16(context).copyWith(
                      color: context.theme.black100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Rate',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '\$${(booking.price / booking.totalDays).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${booking.totalDays} Day${booking.totalDays > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '\$${booking.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (booking.discount > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '-\$${booking.discount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${booking.finalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons based on status
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

  void _handleScanQRCode(BuildContext context) async {
    try {
      // Navigate to QR scanner page and wait for result
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: context.read<RentalHistoryCubit>(),
            child: QRScannerPage(rentalId: booking.id),
          ),
        ),
      );

      if (result == true) {
        // Rental was confirmed successfully
        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Rental confirmed successfully! You can now access the vehicle.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate back to refresh the bookings list
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Handle navigation error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening QR scanner: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showRefundConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Request Refund'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to request a refund for this booking?',
              ),
              const SizedBox(height: 12),
              Text(
                'Refund Amount: \$${booking.finalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6366F1),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Processing time: 3-5 business days',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleRefundRequest(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
              ),
              child: const Text('Request Refund'),
            ),
          ],
        );
      },
    );
  }

  // FIXED: Modified refund handler to use booking ID directly
  void _handleRefundRequest(BuildContext context) {
    try {
      final rentalHistoryCubit = context.read<RentalHistoryCubit>();

      // Use the booking ID directly for refund request
      // This assumes your backend API can handle refunds using booking ID
      rentalHistoryCubit.refundRental(rentalId: booking.id);

      // Show loading message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Processing refund request...'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      // Handle any errors in the refund request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing refund: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildPricingRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
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

class BookingDetailsVehicleInformationSection extends StatelessWidget {
  const BookingDetailsVehicleInformationSection({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Information',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        BookingDetailsVehicleImage(booking: booking),
        Text(
          '${booking.vehicleBrand ?? ''} ${booking.vehicleModel} (${booking.vehicleYear})',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        BookingDetailsTypeAndYearVehicle(booking: booking),
      ],
    );
  }
}

class BookingDetailsBookingPeriodWithTotalDurationSection
    extends StatelessWidget {
  const BookingDetailsBookingPeriodWithTotalDurationSection({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Period',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        BookingDetailsBookingPeriod(booking: booking),
        BookingDetailsTotalDuration(booking: booking),
      ],
    );
  }
}

class BookingDetailsTotalDuration extends StatelessWidget {
  const BookingDetailsTotalDuration({
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
          'Total Duration',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        Text(
          '${booking.totalDays} Day${booking.totalDays > 1 ? 's' : ''}',
          style: AppStyles.bold18(context).copyWith(
            color: context.theme.black100,
          ),
        ),
      ],
    );
  }
}
