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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Booking Details',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
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
          }

          if (state is BookingGetByIdError) {
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
                    state.message,
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

          BookingModel? bookingData;
          if (state is BookingGetByIdSuccess) {
            bookingData = state.booking;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Booking Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(bookingData?.status ??
                                        widget.booking.status)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                bookingData?.status ?? widget.booking.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getStatusColor(bookingData?.status ??
                                      widget.booking.status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(24),
                        const Text(
                          'Customer Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Gap(12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: widget.booking.color,
                              child: Text(
                                widget.booking.initial,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const Gap(12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.booking.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Premium Member',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6B73FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.message,
                                color: Color(0xFF6B73FF),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const Gap(24),
                        const Text(
                          'Vehicle Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Gap(12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (bookingData?.vehicleImagePath != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        'https://aggarapi.runasp.net${bookingData!.vehicleImagePath}',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.directions_car,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  const Gap(12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bookingData?.vehicleModel ??
                                              'Vehicle',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const Gap(4),
                                        Text(
                                          'Year: ${bookingData?.vehicleYear ?? 'N/A'}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(24),
                        const Text(
                          'Booking Period',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Gap(12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'START DATE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    _formatDate(bookingData?.startDate) ??
                                        widget.booking.date,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'END DATE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    _formatDate(bookingData?.endDate) ??
                                        widget.booking.date,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Total Duration',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${bookingData?.totalDays ?? 1} ${(bookingData?.totalDays ?? 1) == 1 ? 'Day' : 'Days'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(24),
                        const Text(
                          'Pricing Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Gap(12),
                        _buildPriceRow('Base Price',
                            '\$${bookingData?.price.toStringAsFixed(2) ?? '0.00'}'),
                        if ((bookingData?.discount ?? 0) > 0)
                          _buildPriceRow('Discount',
                              '-\$${((bookingData?.price ?? 0) * (bookingData?.discount ?? 0) / 100).toStringAsFixed(2)}'),
                        const Gap(12),
                        const Divider(),
                        const Gap(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '\$${bookingData?.finalPrice.toStringAsFixed(2) ?? '0.00'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6B73FF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                if ((bookingData?.status ?? widget.booking.status)
                        .toLowerCase() ==
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
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showDeclineConfirmation(
                                context, bookingData?.id ?? widget.booking.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Decline',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showAcceptConfirmation(
                                context, bookingData?.id ?? widget.booking.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6B73FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Accept Booking',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                              bookingData?.status ?? widget.booking.status)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(
                                bookingData?.status ?? widget.booking.status)
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getStatusIcon(
                              bookingData?.status ?? widget.booking.status),
                          color: _getStatusColor(
                              bookingData?.status ?? widget.booking.status),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Text(
                            _getStatusMessage(
                                bookingData?.status ?? widget.booking.status),
                            style: TextStyle(
                              color: _getStatusColor(
                                  bookingData?.status ?? widget.booking.status),
                              fontWeight: FontWeight.w500,
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
          );
        },
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
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

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return '${date.day}/${date.month}/${date.year}';
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

  void _showAcceptConfirmation(BuildContext context, int bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Accept Booking',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to accept this booking request? This action cannot be undone.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleAcceptBooking(context, bookingId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B73FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  void _showDeclineConfirmation(BuildContext context, int bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Decline Booking',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to decline this booking request? This action cannot be undone.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleRejectBooking(context, bookingId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Decline'),
            ),
          ],
        );
      },
    );
  }

  void _handleAcceptBooking(BuildContext context, int bookingId) {
    context.read<BookingCubit>().acceptBooking(bookingId);
  }

  void _handleRejectBooking(BuildContext context, int bookingId) {
    context.read<BookingCubit>().rejectBooking(bookingId);
  }
}
