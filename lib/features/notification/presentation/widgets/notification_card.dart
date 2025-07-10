import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';
import 'package:aggar/core/services/notification_service.dart' as service;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class NotificationCard extends StatelessWidget {
  final service.Notification notification;
  final VoidCallback onTap;
  final bool isNavigating;
  final int? currentBookingId;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.isNavigating,
    this.currentBookingId,
  });

  @override
  Widget build(BuildContext context) {
    // Convert UTC time to local time for display
    final localCreatedAt = _convertUtcToLocal(notification.createdAt);
    final timeAgo = _getTimeAgo(localCreatedAt);
    final avatarImage =
        notification.senderAvatar ?? AppAssets.assetsImagesNotificationPic1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: notification.isRead
            ? context.theme.white100_1
            : context.theme.blue10_2.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.isRead
              ? Colors.transparent
              : context.theme.blue100_1.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(context, avatarImage, notification.isRead),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.senderName ?? 'System',
                                  style: AppStyles.bold14(context).copyWith(
                                    color: context.theme.black100,
                                  ),
                                ),
                              ),
                              Text(
                                timeAgo,
                                style: AppStyles.medium12(context).copyWith(
                                  color: context.theme.black50,
                                ),
                              ),
                            ],
                          ),
                          const Gap(4),
                          Text(
                            notification.content,
                            style: AppStyles.medium14(context).copyWith(
                              color: context.theme.black50,
                              height: 1.4,
                            ),
                          ),
                          if (_isBookingNotification(notification)) ...[
                            const Gap(8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: context.theme.blue10_2.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Tap to view booking details',
                                style: AppStyles.medium12(context).copyWith(
                                  color: context.theme.blue100_1,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: context.theme.blue100_1,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  if (state is BookingGetByIdLoading && isNavigating) {
                    final bookingId =
                        _extractBookingIdFromNotification(notification);
                    if (bookingId == currentBookingId) {
                      return Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  return const Gap(0);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String avatarImage, bool isRead) {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(avatarImage),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: isRead
                  ? Colors.transparent
                  : context.theme.blue100_1.withOpacity(0.3),
              width: 2,
            ),
          ),
        ),
        if (!isRead)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: context.theme.blue100_1,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  DateTime _convertUtcToLocal(DateTime utcTime) {
    if (utcTime.isUtc) {
      return utcTime.toLocal();
    }
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

  bool _isBookingNotification(service.Notification notification) {
    return notification.additionalData?.containsKey('targetType') == true &&
        notification.additionalData!['targetType']?.toString().toLowerCase() ==
            'booking';
  }

  String _getTimeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inMinutes < 1) {
      return 'Just now';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h ago';
    } else if (duration.inDays < 7) {
      return '${duration.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  int? _extractBookingIdFromNotification(service.Notification notification) {
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
}
