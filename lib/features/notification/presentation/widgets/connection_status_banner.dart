import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/notification/data/cubit/notification_cubit.dart';
import 'package:aggar/features/notification/data/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ConnectionStatusBanner extends StatelessWidget {
  const ConnectionStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      buildWhen: (previous, current) =>
          current is NotificationConnectionState ||
          current is ConnectionRetrying ||
          current is NotificationError && current.isRecoverable,
      builder: (context, state) {
        if (state is NotificationConnectionState && !state.isConnected) {
          return _StatusBanner(
            message: state.connectionErrorMessage ??
                'Connection lost. Tap to reconnect.',
            color: Colors.orange,
            icon: Icons.wifi_off_outlined,
            onTap: () => context.read<NotificationCubit>().reconnect(),
          );
        } else if (state is ConnectionRetrying) {
          return _StatusBanner(
            message:
                'Reconnecting... (${state.attemptNumber}/${state.maxAttempts})',
            color: Colors.blue,
            icon: Icons.sync_outlined,
            showProgress: true,
            onTap: () => context.read<NotificationCubit>().reconnect(),
          );
        } else if (state is NotificationError && state.isRecoverable) {
          return _StatusBanner(
            message: state.message,
            color: Colors.red,
            icon: Icons.error_outline,
            onTap: () => context.read<NotificationCubit>().reconnect(),
          );
        }
        return const Gap(0);
      },
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;
  final bool showProgress;
  final VoidCallback? onTap;

  const _StatusBanner({
    required this.message,
    required this.color,
    required this.icon,
    this.showProgress = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Gap(12),
                Expanded(
                  child: Text(
                    message,
                    style: AppStyles.medium14(context).copyWith(
                      color: color,
                    ),
                  ),
                ),
                if (showProgress) ...[
                  const Gap(8),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ] else if (onTap != null) ...[
                  const Gap(8),
                  Icon(Icons.refresh, color: color, size: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
