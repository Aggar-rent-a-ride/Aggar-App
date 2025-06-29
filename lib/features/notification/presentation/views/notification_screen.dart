import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/notification/data/cubit/notification_cubit.dart';
import 'package:aggar/features/notification/data/cubit/notification_state.dart';
import 'package:aggar/features/notification/presentation/widgets/connection_status_banner.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_card.dart';
import 'package:aggar/features/notification/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/core/services/notification_service.dart' as service;
import 'package:aggar/features/booking/presentation/views/confirm_booking.dart';

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
            child: BlocConsumer<NotificationCubit, NotificationState>(
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
                } else if (state is NotificationError && !state.isRecoverable) {
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
    final targetType = notification.additionalData?['targetType'] as String?;
    final targetId = notification.additionalData?['targetId'];

    // Get avatar image
    final avatarImage =
        notification.senderAvatar ?? AppAssets.assetsImagesNotificationPic1;

    return GestureDetector(
      onTap: () {
        // Mark as read when tapped
        if (!notification.isRead) {
          context.read<NotificationCubit>().markAsRead(notification.id);
        }
        // Navigate to details view
        _navigateToNotificationDetails(notification, targetType, targetId);
      },
      child: Container(
        color: notification.isRead
            ? null
            : context.theme.blue10_2.withOpacity(0.2),
        child: NotificationCard(
          profileImage: avatarImage,
          name: notification.senderName ?? 'System',
          actionText: notification.content,
          timeAgo: timeAgo,
          isfoundButton: false, // No buttons anymore
          widget: null, // No action buttons
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

  void _navigateToNotificationDetails(
    service.Notification notification,
    String? targetType,
    dynamic targetId,
  ) {
    // If the notification is for a booking confirmation, navigate to BookingConfirmScreen
    if (targetType != null && targetType.toLowerCase() == 'booking') {
      // Try to get bookingId from additionalData (targetBookingId or targetId)
      final bookingId =
          notification.additionalData?['targetBookingId'] ?? targetId;
      if (bookingId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingConfirmScreen(
                bookingId: bookingId is int
                    ? bookingId
                    : int.tryParse(bookingId.toString())),
          ),
        );
        return;
      }
    }
    // Default: Navigate to notification details screen
    Navigator.pushNamed(
      context,
      '/notification-details',
      arguments: {
        'notification': notification,
        'targetType': targetType,
        'targetId': targetId,
      },
    );
  }
}
