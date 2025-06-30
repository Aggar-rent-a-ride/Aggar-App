import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/notification/data/cubit/notification_cubit.dart';
import 'package:aggar/features/notification/data/cubit/notification_state.dart';
import 'package:aggar/features/notification/presentation/widgets/connection_status_banner.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_card.dart';
import 'package:aggar/features/notification/presentation/widgets/section_header.dart';
// Add these imports for booking functionality
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_customer.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_renter.dart';
import 'package:aggar/features/main_screen/renter/data/model/booking_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/core/services/notification_service.dart' as service;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationCubit>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Notifications',
            style: AppStyles.bold24(context).copyWith(
              color: context.theme.black100,
            ),
          ),
        ),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationConnectionState && !state.isConnected ||
                  state is NotificationError && state.isRecoverable) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () =>
                      context.read<NotificationCubit>().reconnect(),
                  tooltip: 'Reconnect',
                );
              }
              if (state is NotificationsLoaded &&
                  state.notifications.isNotEmpty) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.unreadCount > 0)
                      IconButton(
                        icon: const Icon(Icons.done_all),
                        onPressed: () =>
                            context.read<NotificationCubit>().markAllAsRead(),
                        tooltip: 'Mark all as read',
                      ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => context
                          .read<NotificationCubit>()
                          .fetchNotifications(),
                      tooltip: 'Refresh',
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          _buildConnectionStatusBanner(),
          Expanded(
            child: MultiBlocListener(
              listeners: [
                // Existing notification listener
                BlocListener<NotificationCubit, NotificationState>(
                  listenWhen: (previous, current) =>
                      current is NotificationError ||
                      current is NotificationReceived,
                  listener: (context, state) {
                    if (state is NotificationError) {
                      if (!state.isRecoverable ||
                          !(state.message.contains('Failed to connect') ||
                              state.message.contains('connection'))) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            context,
                            "Error",
                            "Notification Error: ${state.message}",
                            SnackBarType.error,
                          ),
                        );
                      }
                    } else if (state is NotificationReceived) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackBar(
                          context,
                          "Success",
                          state.notification.content,
                          SnackBarType.success,
                        ),
                      );
                    }
                  },
                ),
                // Add booking listener for navigation after fetching booking details
                BlocListener<BookingCubit, BookingState>(
                  listener: (context, state) {
                    if (state is BookingGetByIdSuccess) {
                      // Navigate to booking details screen after successful fetch
                      _navigateToBookingDetails(state.booking);
                    } else if (state is BookingGetByIdError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackBar(
                          context,
                          "Error",
                          "Failed to load booking: ${state.message}",
                          SnackBarType.error,
                        ),
                      );
                    }
                  },
                ),
              ],
              child: BlocBuilder<NotificationCubit, NotificationState>(
                buildWhen: (previous, current) =>
                    current is NotificationLoading ||
                    current is NotificationsLoaded ||
                    current is NotificationError && !current.isRecoverable,
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NotificationsLoaded) {
                    if (state.notifications.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 64,
                              color: context.theme.black50,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No notifications yet',
                              style: AppStyles.medium18(context).copyWith(
                                color: context.theme.black50,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return _buildNotificationsList(state.notifications);
                  } else if (state is NotificationError &&
                      !state.isRecoverable) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: AppStyles.medium16(context).copyWith(
                              color: context.theme.black100,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<NotificationCubit>().initialize(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.theme.blue100_1,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatusBanner() {
    return BlocBuilder<NotificationCubit, NotificationState>(
      buildWhen: (previous, current) =>
          current is NotificationConnectionState ||
          current is ConnectionRetrying ||
          current is NotificationError && current.isRecoverable,
      builder: (context, state) {
        if (state is NotificationConnectionState && !state.isConnected) {
          return ConnectionStatusBanner(
            message: state.connectionErrorMessage ??
                'Connection lost. Attempting to reconnect...',
            color: Colors.orange,
            onRetry: () => context.read<NotificationCubit>().reconnect(),
          );
        } else if (state is ConnectionRetrying) {
          return ConnectionStatusBanner(
            message:
                'Reconnecting... Attempt ${state.attemptNumber} of ${state.maxAttempts}',
            color: Colors.orange,
            showProgress: true,
            onRetry: () => context.read<NotificationCubit>().reconnect(),
          );
        } else if (state is NotificationError && state.isRecoverable) {
          return ConnectionStatusBanner(
            message: state.message,
            color: Colors.red,
            onRetry: () => context.read<NotificationCubit>().reconnect(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildNotificationsList(List<service.Notification> notifications) {
    // Group notifications by date
    final today = <service.Notification>[];
    final earlier = <service.Notification>[];

    final now = DateTime.now();
    for (final notification in notifications) {
      if (notification.createdAt.day == now.day &&
          notification.createdAt.month == now.month &&
          notification.createdAt.year == now.year) {
        today.add(notification);
      } else {
        earlier.add(notification);
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<NotificationCubit>().fetchNotifications();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (today.isNotEmpty) ...[
            SectionHeader(
              title: 'Today',
              markTitle: 'Mark all as read',
              onMarkAsRead: () =>
                  context.read<NotificationCubit>().markAllAsRead(),
            ),
            ...today
                .map((notification) => _buildNotificationCard(notification)),
          ],
          if (earlier.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: SectionHeader(
                title: 'Earlier',
                markTitle: 'Mark all as read',
                onMarkAsRead: () =>
                    context.read<NotificationCubit>().markAllAsRead(),
              ),
            ),
            ...earlier
                .map((notification) => _buildNotificationCard(notification)),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(service.Notification notification) {
    final timeAgo = _getTimeAgo(notification.createdAt);

    // Get avatar image
    final avatarImage =
        notification.senderAvatar ?? AppAssets.assetsImagesNotificationPic1;

    return GestureDetector(
      onTap: () {
        // Mark as read when tapped
        if (!notification.isRead) {
          context.read<NotificationCubit>().markAsRead(notification.id);
        }

        // Handle notification tap
        _handleNotificationTap(notification);
      },
      child: Container(
        color: notification.isRead
            ? null
            : context.theme.blue10_2.withOpacity(0.2),
        child: Stack(
          children: [
            NotificationCard(
              profileImage: avatarImage,
              name: notification.senderName ?? 'System',
              actionText: notification.content,
              timeAgo: timeAgo,
              isfoundButton: false,
              widget: null,
            ),
            // Add loading overlay when fetching booking details
            BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                if (state is BookingGetByIdLoading) {
                  return Positioned.fill(
                    child: Container(
                      color: Colors.black12,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} min ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hr ago';
    } else if (duration.inDays < 7) {
      return '${duration.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _handleNotificationTap(service.Notification notification) {
    // Extract target type and booking ID from the notification
    // Based on your API response, these should be direct properties of the notification
    final targetType = notification.additionalData?['targetType'] as String? ??
        _extractTargetTypeFromNotification(notification);
    final targetBookingId = notification.additionalData?['targetBookingId'] ??
        _extractBookingIdFromNotification(notification);

    print("Notification tapped:");
    print("Target Type: $targetType");
    print("Target Booking ID: $targetBookingId");
    print("Additional Data: ${notification.additionalData}");

    if (targetType?.toLowerCase() == 'booking' && targetBookingId != null) {
      // Convert to int if it's a string
      final bookingId = targetBookingId is int
          ? targetBookingId
          : int.tryParse(targetBookingId.toString());

      if (bookingId != null) {
        print("Fetching booking with ID: $bookingId");
        // Use BookingCubit to fetch booking details
        context.read<BookingCubit>().getBookingById(bookingId);
        return;
      }
    }

    // Fallback: Navigate to general notification details
    _navigateToNotificationDetails(notification);
  }

  // Helper methods to extract data from notification
  String? _extractTargetTypeFromNotification(
      service.Notification notification) {
    // Check if targetType is a direct property of the notification
    // You might need to adjust this based on your actual notification model
    if (notification.additionalData?.containsKey('targetType') == true) {
      return notification.additionalData!['targetType'] as String?;
    }

    // Check if the content mentions booking to infer type
    if (notification.content.toLowerCase().contains('booking')) {
      return 'Booking';
    }

    return null;
  }

  int? _extractBookingIdFromNotification(service.Notification notification) {
    // Check additionalData first
    if (notification.additionalData?.containsKey('targetBookingId') == true) {
      final bookingId = notification.additionalData!['targetBookingId'];
      return bookingId is int ? bookingId : int.tryParse(bookingId.toString());
    }

    // Check if targetId is the booking ID
    if (notification.additionalData?.containsKey('targetId') == true) {
      final targetId = notification.additionalData!['targetId'];
      return targetId is int ? targetId : int.tryParse(targetId.toString());
    }

    return null;
  }

  void _navigateToBookingDetails(dynamic booking) {
    // Navigate to booking details screen using MaterialPageRoute
    // First, determine user type to decide which screen to show
    _getUserTypeAndNavigate(booking);
  }

  Future<void> _getUserTypeAndNavigate(dynamic booking) async {
    try {
      const secureStorage = FlutterSecureStorage();
      final userType = await secureStorage.read(key: 'userType');

      if (userType?.toLowerCase() == 'renter') {
        // Convert booking to BookingItem for renter screen
        final bookingItem = _convertToBookingItem(booking);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetailsScreenRenter(
              booking: bookingItem,
            ),
          ),
        );
      } else {
        // Default to customer screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetailsScreenCustomer(
              booking: booking,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error determining user type: $e');
      // Fallback to customer screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingDetailsScreenCustomer(
            booking: booking,
          ),
        ),
      );
    }
  }

  // Convert BookingModel to BookingItem for renter navigation
  BookingItem _convertToBookingItem(dynamic booking) {
    // Generate a color based on booking ID for consistency
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

    // Extract initial from vehicle model or use default
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _navigateToNotificationDetails(service.Notification notification) {
    // Navigate to general notification details screen
    // For now, just show a snackbar since we don't have a dedicated notification details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification: ${notification.content}'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
