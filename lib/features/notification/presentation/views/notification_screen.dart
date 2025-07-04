import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/notification/data/cubit/notification_cubit.dart';
import 'package:aggar/features/notification/data/cubit/notification_state.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_app_bar.dart';
// Remove this import: import 'package:aggar/features/notification/presentation/widgets/connection_status_banner.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_loading_state.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_empty_state.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_error_state.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_list.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isNavigating = false;
  int? _currentBookingId;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationCubit>().initialize();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      appBar: const NotificationAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Remove this line: const ConnectionStatusBanner(),
            Expanded(
              child: MultiBlocListener(
                listeners: [
                  BlocListener<BookingCubit, BookingState>(
                    listener: (context, state) {
                      if (state is BookingGetByIdSuccess && _isNavigating) {
                        NotificationHandler.handleBookingSuccess(
                          context,
                          state.booking,
                          (value) => setState(() => _isNavigating = value),
                          (value) => setState(() => _currentBookingId = value),
                        );
                      } else if (state is BookingGetByIdError) {
                        NotificationHandler.handleBookingError(
                          context,
                          state.message,
                          (value) => setState(() => _isNavigating = value),
                          (value) => setState(() => _currentBookingId = value),
                        );
                      }
                    },
                  ),
                ],
                child: _buildNotificationBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBody() {
    return BlocBuilder<NotificationCubit, NotificationState>(
      // Remove buildWhen to listen to ALL state changes for real-time updates
      builder: (context, state) {
        if (state is NotificationLoading) {
          return const NotificationLoadingState();
        } else if (state is NotificationsLoaded) {
          if (state.notifications.isEmpty) {
            return const NotificationEmptyState();
          }
          return NotificationList(
            notifications: state.notifications,
            isNavigating: _isNavigating,
            currentBookingId: _currentBookingId,
            onNotificationTap: (notification) =>
                NotificationHandler.handleNotificationTap(
              context,
              notification,
              _isNavigating,
              _currentBookingId,
              (value) => setState(() => _isNavigating = value),
              (value) => setState(() => _currentBookingId = value),
            ),
          );
        } else if (state is NotificationError && !state.isRecoverable) {
          return NotificationErrorState(message: state.message);
        }
        return const NotificationLoadingState();
      },
    );
  }
}
