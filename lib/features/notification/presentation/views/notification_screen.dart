import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/notification/data/cubit/notification_cubit.dart';
import 'package:aggar/features/notification/data/cubit/notification_state.dart';
import 'package:aggar/features/notification/presentation/widgets/accept_or_feedback_button.dart';
import 'package:aggar/features/notification/presentation/widgets/connection_status_banner.dart';
import 'package:aggar/features/notification/presentation/widgets/deny_button.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_card.dart';
import 'package:aggar/features/notification/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:aggar/core/services/notification_service.dart' as service;

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
                        "Notificaation Error: ${state.message}",
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
    Widget? actionButtons;
    bool hasButtons = false;

    switch (targetType) {
      case 'CustomerReview':
        hasButtons = true;
        actionButtons = AcceptOrFeedbackButton(
          title: "View Review",
          onPressed: () => _handleViewReview(notification, targetId),
        );
        break;
      case 'Message':
        hasButtons = true;
        actionButtons = AcceptOrFeedbackButton(
          title: "Open Chat",
          onPressed: () => _handleOpenChat(notification, targetId),
        );
        break;
      case 'Booking':
        hasButtons = true;
        actionButtons = Row(
          children: [
            AcceptOrFeedbackButton(
              title: "Accept",
              onPressed: () => _handleAcceptBooking(notification, targetId),
            ),
            const Gap(8),
            DenyButton(
              onPressed: () => _handleDenyBooking(notification, targetId),
            ),
          ],
        );
        break;
      default:
        // Handle other notification types or no specific action needed
        if (notification.content.contains('request to start chat')) {
          hasButtons = true;
          actionButtons = Row(
            children: [
              AcceptOrFeedbackButton(
                title: "Accept",
                onPressed: () => _handleAccept(notification),
              ),
              const Gap(8),
              DenyButton(
                onPressed: () => _handleDeny(notification),
              ),
            ],
          );
        } else if (notification.content.contains('feedback')) {
          hasButtons = true;
          actionButtons = AcceptOrFeedbackButton(
            title: "Send Feedback",
            onPressed: () => _handleFeedback(notification),
          );
        }
    }

    // Get avatar image
    final avatarImage =
        notification.senderAvatar ?? AppAssets.assetsImagesNotificationPic1;

    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          context.read<NotificationCubit>().markAsRead(notification.id);
        }
        _handleNotificationTap(notification, targetType, targetId);
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
          isfoundButton: hasButtons,
          widget: actionButtons,
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

  void _handleNotificationTap(
    service.Notification notification,
    String? targetType,
    dynamic targetId,
  ) {
    if (targetType == null || targetId == null) return;

    switch (targetType) {
      case 'CustomerReview':
        _handleViewReview(notification, targetId);
        break;
      case 'Message':
        _handleOpenChat(notification, targetId);
        break;
      case 'Booking':
        _handleViewBooking(notification, targetId);
        break;
      case 'Rental':
        _handleViewRental(notification, targetId);
        break;
    }
  }

  void _handleViewReview(service.Notification notification, dynamic targetId) {
    context.read<NotificationCubit>().markAsRead(notification.id);
  }

  void _handleOpenChat(service.Notification notification, dynamic targetId) {
    context.read<NotificationCubit>().markAsRead(notification.id);
  }

  void _handleViewBooking(service.Notification notification, dynamic targetId) {
    context.read<NotificationCubit>().markAsRead(notification.id);
  }

  void _handleViewRental(service.Notification notification, dynamic targetId) {
    context.read<NotificationCubit>().markAsRead(notification.id);
  }

  void _handleAcceptBooking(
      service.Notification notification, dynamic targetId) {
    context.read<NotificationCubit>().markAsRead(notification.id);
  }

  void _handleDenyBooking(service.Notification notification, dynamic targetId) {
    context.read<NotificationCubit>().markAsRead(notification.id);
  }

  void _handleAccept(service.Notification notification) {
    context.read<NotificationCubit>().markAsRead(notification.id);
  }

  void _handleDeny(service.Notification notification) {
    context.read<NotificationCubit>().markAsRead(notification.id);
  }

  void _handleFeedback(service.Notification notification) {
    context.read<NotificationCubit>().markAsRead(notification.id);
  }
}
