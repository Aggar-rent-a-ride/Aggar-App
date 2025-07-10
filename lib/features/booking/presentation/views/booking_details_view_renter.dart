import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_renter_action_buttons.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_renter_booking_period_with_total_duration_section.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_renter_discount_row.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_renter_pricing_details_section.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_renter_total_amout.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_renter_vehicle_information_section.dart';
import 'package:aggar/features/main_screen/renter/data/model/booking_item.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/payment/presentation/views/connected_account_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class BookingDetailsScreenRenter extends StatefulWidget {
  final BookingItem booking;

  const BookingDetailsScreenRenter({
    super.key,
    required this.booking,
  });

  @override
  State<BookingDetailsScreenRenter> createState() =>
      _BookingDetailsScreenRenterState();
}

class _BookingDetailsScreenRenterState
    extends State<BookingDetailsScreenRenter> {
  bool _isProcessingResponse = false;

  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().getBookingById(widget.booking.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              color: _getStatusColor(widget.booking.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.booking.status,
              style: TextStyle(
                color: _getStatusColor(widget.booking.status),
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
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingGetByIdError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is BookingResponseSuccess) {
            setState(() {
              _isProcessingResponse = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor:
                    state.isAccepted ? Colors.green : Colors.orange,
              ),
            );

            Navigator.pop(context, state.isAccepted ? 'accepted' : 'rejected');
          }

          if (state is BookingResponseError) {
            setState(() {
              _isProcessingResponse = false;
            });

            // Check if the error is about needing a payment account
            if (state.message.toLowerCase().contains('payment account') ||
                state.message
                    .toLowerCase()
                    .contains('create a payment account')) {
              _showPaymentAccountRequiredDialog(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }

          if (state is BookingResponseLoading) {
            setState(() {
              _isProcessingResponse = true;
            });
          }
        },
        builder: (context, state) {
          if (state is BookingGetByIdLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6B73FF),
              ),
            );
          } else if (state is BookingGetByIdSuccess) {
            BookingModel? bookingDataID;
            bookingDataID = state.booking;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 0),
                      blurRadius: 4,
                    )
                  ],
                  color: context.theme.white100_2,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookingDetailsRenterVehicleInformationSection(
                          bookingData: bookingDataID, widget: widget),
                      BookingDetailsRenterBookingPeriodWithTotalDurationSection(
                          bookingData: bookingDataID),
                      BookingDetailsRenterPricingDetailsSection(
                          bookingData: bookingDataID),
                      if (bookingDataID.discount > 0)
                        BookingDetailsRenterDiscountRow(
                            bookingData: bookingDataID),
                      const Divider(height: 24),
                      BookingDetailsRenterTotalAmout(
                          bookingData: bookingDataID),
                      const Gap(24),
                      if ((bookingDataID.status).toLowerCase() ==
                          'pending') ...[
                        if (_isProcessingResponse) ...[
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const CircularProgressIndicator(
                                  color: Color(0xFF6B73FF),
                                ),
                                const Gap(12),
                                Text(
                                  'Processing your response...',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          BookingDetailsRenterActionButtons(
                              bookingData: bookingDataID, widget: widget),
                        ],
                      ] else ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _getStatusColor(bookingDataID.status)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor(bookingDataID.status)
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getStatusIcon(bookingDataID.status),
                                color: _getStatusColor(bookingDataID.status),
                              ),
                              const Gap(12),
                              Expanded(
                                child: Text(
                                  _getStatusMessage(bookingDataID.status),
                                  style: AppStyles.semiBold16(context).copyWith(
                                    color:
                                        _getStatusColor(bookingDataID.status),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const Gap(20),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const Gap(16),
                  Text(
                    'Error loading booking details',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Gap(8),
                  Text(
                    "an Error has occured",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(24),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<BookingCubit>()
                          .getBookingById(widget.booking.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B73FF),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
      case 'accepted':
        return Colors.green;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'confirmed':
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
      case 'cancelled':
        return Icons.cancel;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.info;
    }
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'accepted':
        return 'You have accepted this booking request.';
      case 'rejected':
        return 'You have declined this booking request.';
      case 'cancelled':
        return 'This booking has been cancelled.';
      case 'completed':
        return 'This booking has been completed.';
      default:
        return 'Booking status: ${status.toUpperCase()}';
    }
  }

  // NEW METHOD: Show payment account required dialog
  void _showPaymentAccountRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: Icon(
            Icons.account_balance,
            size: 48,
            color: Colors.blue[600],
          ),
          title: const Text(
            'Payment Account Required',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'To accept bookings and receive payments, you need to connect your bank account first.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              Gap(12),
              Text(
                'This is a one-time setup that enables secure payment processing.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Later',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _navigateToConnectedAccountPage(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('Setup Account'),
            ),
          ],
        );
      },
    );
  }

  // NEW METHOD: Navigate to ConnectedAccountPage
  void _navigateToConnectedAccountPage(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ConnectedAccountPage(),
      ),
    );

    // If the user successfully connected their account, you might want to refresh the booking
    if (result == true) {
      // Refresh the booking data or show a success message
      context.read<BookingCubit>().getBookingById(widget.booking.id);
    }
  }
}
