import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/notification/data/cubit/notification_cubit.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_card.dart';
import 'package:aggar/core/services/notification_service.dart' as service;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class NotificationList extends StatelessWidget {
  final List<service.Notification> notifications;
  final bool isNavigating;
  final int? currentBookingId;
  final Function(service.Notification) onNotificationTap;

  const NotificationList({
    super.key,
    required this.notifications,
    required this.isNavigating,
    this.currentBookingId,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final today = <service.Notification>[];
    final yesterday = <service.Notification>[];
    final earlier = <service.Notification>[];

    final now = DateTime.now();
    final yesterdayDate = now.subtract(const Duration(days: 1));

    for (final notification in notifications) {
      // Convert UTC time to local time
      final notificationDate = _convertUtcToLocal(notification.createdAt);

      if (_isSameDay(notificationDate, now)) {
        today.add(notification);
      } else if (_isSameDay(notificationDate, yesterdayDate)) {
        yesterday.add(notification);
      } else {
        earlier.add(notification);
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<NotificationCubit>().fetchNotifications();
      },
      color: context.theme.blue100_1,
      backgroundColor: Colors.white,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const Gap(8),
          if (today.isNotEmpty) ...[
            _buildSectionHeader(context, 'Today', today.length),
            ...today.map((notification) => NotificationCard(
                  notification: notification,
                  onTap: () => onNotificationTap(notification),
                  isNavigating: isNavigating,
                  currentBookingId: currentBookingId,
                )),
            const Gap(16),
          ],
          if (yesterday.isNotEmpty) ...[
            _buildSectionHeader(context, 'Yesterday', yesterday.length),
            ...yesterday.map((notification) => NotificationCard(
                  notification: notification,
                  onTap: () => onNotificationTap(notification),
                  isNavigating: isNavigating,
                  currentBookingId: currentBookingId,
                )),
            const Gap(16),
          ],
          if (earlier.isNotEmpty) ...[
            _buildSectionHeader(context, 'Earlier', earlier.length),
            ...earlier.map((notification) => NotificationCard(
                  notification: notification,
                  onTap: () => onNotificationTap(notification),
                  isNavigating: isNavigating,
                  currentBookingId: currentBookingId,
                )),
          ],
          const Gap(32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: AppStyles.bold16(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
              const Gap(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: context.theme.blue10_2.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: AppStyles.medium12(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => context.read<NotificationCubit>().markAllAsRead(),
            child: Text(
              'Mark all as read',
              style: AppStyles.medium12(context).copyWith(
                color: context.theme.blue100_1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fix timezone conversion
  DateTime _convertUtcToLocal(DateTime utcTime) {
    // If the time is already in UTC, convert to local
    if (utcTime.isUtc) {
      return utcTime.toLocal();
    }
    // If it's not marked as UTC but comes from server, assume it's UTC
    return DateTime.utc(
      utcTime.year,
      utcTime.month,
      utcTime.day,
      utcTime.hour,
      utcTime.minute,
      utcTime.second,
      utcTime.millisecond,
    ).toLocal();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
