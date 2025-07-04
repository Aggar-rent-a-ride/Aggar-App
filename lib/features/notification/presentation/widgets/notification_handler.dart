import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_customer.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_renter.dart';
import 'package:aggar/features/main_screen/renter/data/model/booking_item.dart';
import 'package:aggar/features/notification/data/cubit/notification_cubit.dart';
import 'package:aggar/core/services/notification_service.dart' as service;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationHandler {
  static void handleNotificationTap(
    BuildContext context,
    service.Notification notification,
    bool isNavigating,
    int? currentBookingId,
    Function(bool) setIsNavigating,
    Function(int?) setCurrentBookingId,
  ) {
    if (isNavigating) {
      print('Already navigating, ignoring tap');
      return;
    }

    print('Handling notification tap for notification: ${notification.id}');

    // Mark as read first
    if (!notification.isRead) {
      context.read<NotificationCubit>().markAsRead(notification.id);
    }

    final targetType = notification.additionalData?['targetType'] as String? ??
        _extractTargetTypeFromNotification(notification);
    final targetBookingId = notification.additionalData?['targetBookingId'] ??
        _extractBookingIdFromNotification(notification);

    if (targetType?.toLowerCase() == 'booking' && targetBookingId != null) {
      final bookingId = targetBookingId is int
          ? targetBookingId
          : int.tryParse(targetBookingId.toString());

      if (bookingId != null) {
        print('Fetching booking with ID: $bookingId');

        setIsNavigating(true);
        setCurrentBookingId(bookingId);

        context.read<BookingCubit>().getBookingById(bookingId);
        return;
      }
    }

    _navigateToNotificationDetails(context, notification);
  }

  static void handleBookingSuccess(
    BuildContext context,
    dynamic booking,
    Function(bool) setIsNavigating,
    Function(int?) setCurrentBookingId,
  ) {
    setIsNavigating(false);
    setCurrentBookingId(null);
    _navigateToBookingDetails(context, booking);
  }

  static void handleBookingError(
    BuildContext context,
    String message,
    Function(bool) setIsNavigating,
    Function(int?) setCurrentBookingId,
  ) {
    setIsNavigating(false);
    setCurrentBookingId(null);
    _showErrorSnackBar(context, "Failed to load booking: $message");
  }

  static String? _extractTargetTypeFromNotification(
      service.Notification notification) {
    if (notification.additionalData?.containsKey('targetType') == true) {
      return notification.additionalData!['targetType'] as String?;
    }
    if (notification.content.toLowerCase().contains('booking')) {
      return 'Booking';
    }
    return null;
  }

  static int? _extractBookingIdFromNotification(
      service.Notification notification) {
    if (notification.additionalData?.containsKey('targetBookingId') == true) {
      final bookingId = notification.additionalData!['targetBookingId'];
      return bookingId is int ? bookingId : int.tryParse(bookingId.toString());
    }
    if (notification.additionalData?.containsKey('targetId') == true) {
      final targetId = notification.additionalData!['targetId'];
      return targetId is int ? targetId : int.tryParse(targetId.toString());
    }
    return null;
  }

  static void _navigateToBookingDetails(BuildContext context, dynamic booking) {
    print('Navigating to booking details for booking: ${booking.id}');
    _getUserTypeAndNavigate(context, booking);
  }

  static Future<void> _getUserTypeAndNavigate(
      BuildContext context, dynamic booking) async {
    try {
      const secureStorage = FlutterSecureStorage();
      final userType = await secureStorage.read(key: 'userType');

      if (!context.mounted) return;

      if (userType?.toLowerCase() == 'renter') {
        final bookingItem = _convertToBookingItem(booking);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BookingDetailsScreenRenter(booking: bookingItem),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BookingDetailsScreenCustomer(booking: booking),
          ),
        );
      }
    } catch (e) {
      print('Error during navigation: $e');
      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingDetailsScreenCustomer(booking: booking),
        ),
      );
    }
  }

  static BookingItem _convertToBookingItem(dynamic booking) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    final color = colors[booking.id % colors.length];
    final initial = booking.vehicleModel.isNotEmpty
        ? booking.vehicleModel[0].toUpperCase()
        : 'V';

    return BookingItem(
      id: booking.id,
      name: '${booking.vehicleBrand} ${booking.vehicleModel}',
      date: _formatDate(booking.startDate.toString()),
      status: booking.status,
      initial: initial,
      color: color,
      service: '',
      time: '',
    );
  }

  static String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  static void _navigateToNotificationDetails(
      BuildContext context, service.Notification notification) {
    _showSuccessSnackBar(context, 'Notification: ${notification.content}');
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
        context,
        "Error",
        message,
        SnackBarType.error,
      ),
    );
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
        context,
        "Success",
        message,
        SnackBarType.success,
      ),
    );
  }
}
