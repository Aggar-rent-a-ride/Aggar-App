import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/renter/data/model/booking_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../../core/helper/custom_snack_bar.dart';

class BookingCard extends StatelessWidget {
  final BookingItem booking;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.theme.black10),
          color: context.theme.white100_2,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: MediaQuery.sizeOf(context).width * 0.05,
              backgroundColor: booking.color,
              child: Text(
                booking.initial,
                style: AppStyles.semiBold18(context).copyWith(
                  color: AppConstants.myWhite100_1,
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.name,
                    style: AppStyles.semiBold16(context).copyWith(
                      color: context.theme.black100,
                    ),
                  ),
                  Text(
                    booking.service,
                    style: AppStyles.medium13(context).copyWith(
                      color: context.theme.black50,
                    ),
                  ),
                  const Gap(5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusBackgroundColor(booking.status),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      booking.status,
                      style: AppStyles.regular10(context).copyWith(
                        color: _getStatusTextColor(booking.status),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  booking.time,
                  style: AppStyles.medium14(context).copyWith(
                    color: context.theme.black100,
                  ),
                ),
                Text(
                  booking.date,
                  style: AppStyles.regular12(context).copyWith(
                    color: context.theme.black50,
                  ),
                ),
                const Gap(8),
                if (booking.status.toLowerCase() == 'pending') ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(
                        icon: Icons.check,
                        color: context.theme.green100_1,
                        onPressed: () => _handleAcceptBooking(context),
                      ),
                      const Gap(8),
                      _buildActionButton(
                        icon: Icons.close,
                        color: context.theme.red100_1,
                        onPressed: () => _handleRejectBooking(context),
                      ),
                    ],
                  ),
                ] else ...[
                  // Show status icon for non-pending bookings
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _getStatusIconColor(booking.status),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(booking.status),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[100]!;
      case 'accepted':
        return Colors.green[100]!;
      case 'rejected':
        return Colors.red[100]!;
      case 'completed':
        return Colors.blue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[800]!;
      case 'accepted':
        return Colors.green[800]!;
      case 'rejected':
        return Colors.red[800]!;
      case 'completed':
        return Colors.blue[800]!;
      default:
        return Colors.grey[800]!;
    }
  }

  Color _getStatusIconColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Icons.check;
      case 'rejected':
        return Icons.close;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.help_outline;
    }
  }

  Future<void> _handleAcceptBooking(BuildContext context) async {
    try {
      final tokenCubit = context.read<TokenRefreshCubit>();
      final token = await tokenCubit.ensureValidToken();

      if (token != null && token.isNotEmpty) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6B73FF),
            ),
          ),
        );

        // TODO: Implement actual API call to accept booking
        // await context.read<BookingCubit>().acceptBooking(booking.id, token);

        // Simulate API call delay
        await Future.delayed(const Duration(seconds: 1));

        Navigator.pop(context); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Accepted booking for ${booking.name}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            "Error",
            "'Session expired. Please login again.'",
            SnackBarType.error,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog if open
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accepting booking: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleRejectBooking(BuildContext context) async {
    // Show confirmation dialog
    final shouldReject = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Booking'),
        content: Text(
            'Are you sure you want to reject the booking for ${booking.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (shouldReject != true) return;

    try {
      final tokenCubit = context.read<TokenRefreshCubit>();
      final token = await tokenCubit.ensureValidToken();

      if (token != null && token.isNotEmpty) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6B73FF),
            ),
          ),
        );

        // TODO: Implement actual API call to reject booking
        // await context.read<BookingCubit>().rejectBooking(booking.id, token);

        // Simulate API call delay
        await Future.delayed(const Duration(seconds: 1));

        Navigator.pop(context); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rejected booking for ${booking.name}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            "Error",
            "'Session expired. Please login again.'",
            SnackBarType.error,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog if open
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rejecting booking: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
