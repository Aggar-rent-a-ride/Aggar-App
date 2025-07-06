import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/notification/data/cubit/notification_cubit.dart';
import 'package:aggar/features/notification/data/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class NotificationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 80,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: context.theme.black100,
          size: 20,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: AppStyles.bold24(context).copyWith(
                color: context.theme.black100,
                height: 1.2,
              ),
            ),
            const Gap(2),
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationsLoaded) {
                  final unreadCount = state.unreadCount;
                  return Text(
                    unreadCount > 0
                        ? '$unreadCount new notification${unreadCount > 1 ? 's' : ''}'
                        : 'All caught up!',
                    style: AppStyles.medium12(context).copyWith(
                      color: unreadCount > 0
                          ? context.theme.blue100_1
                          : context.theme.black50,
                    ),
                  );
                }
                return const Gap(0);
              },
            ),
          ],
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state is NotificationsLoaded && state.unreadCount > 0)
                    _buildActionButton(
                      context,
                      icon: Icons.mark_email_read_outlined,
                      tooltip: 'Mark all as read',
                      onPressed: () =>
                          context.read<NotificationCubit>().markAllAsRead(),
                    ),
                  const Gap(8),
                  _buildActionButton(
                    context,
                    icon: _getRefreshIcon(state),
                    tooltip: _getRefreshTooltip(state),
                    onPressed: () => _handleRefresh(context, state),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.blue10_2.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        color: context.theme.blue100_1,
        onPressed: onPressed,
        tooltip: tooltip,
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
      ),
    );
  }

  IconData _getRefreshIcon(NotificationState state) {
    if (state is NotificationConnectionState && !state.isConnected ||
        state is NotificationError && state.isRecoverable) {
      return Icons.wifi_off_outlined;
    }
    return Icons.refresh_outlined;
  }

  String _getRefreshTooltip(NotificationState state) {
    if (state is NotificationConnectionState && !state.isConnected ||
        state is NotificationError && state.isRecoverable) {
      return 'Reconnect';
    }
    return 'Refresh';
  }

  void _handleRefresh(BuildContext context, NotificationState state) {
    if (state is NotificationConnectionState && !state.isConnected ||
        state is NotificationError && state.isRecoverable) {
      context.read<NotificationCubit>().reconnect();
    } else {
      context.read<NotificationCubit>().fetchNotifications();
    }
  }
}
