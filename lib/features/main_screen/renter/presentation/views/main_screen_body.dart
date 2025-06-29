import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_renter.dart';
import 'package:aggar/features/main_screen/renter/data/model/booking_item.dart';
import 'package:aggar/features/main_screen/renter/presentation/widgets/booking_card.dart';
import 'package:aggar/features/main_screen/widgets/main_header.dart';
import 'package:aggar/features/notification/presentation/views/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gap/gap.dart';

// Import your booking cubit here
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';

class MainScreenBody extends StatefulWidget {
  const MainScreenBody({
    super.key,
    required this.onRefresh,
  });

  final VoidCallback onRefresh;

  @override
  State<MainScreenBody> createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<MainScreenBody> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadPendingBookings();
  }

  void _loadPendingBookings() {
    context.read<BookingCubit>().getRenterPendingBookings();
  }

  Future<void> _onRefresh() async {
    widget.onRefresh();
    _loadPendingBookings();
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.theme.blue100_8,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 55, bottom: 20),
              child: MainHeader(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    )),
              ),
            ),

            // Calendar Section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calendar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Gap(16),
                      TableCalendar<dynamic>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: Colors.grey,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          weekendTextStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                          holidayTextStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: Color(0xFF6B73FF),
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          defaultTextStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          weekendStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Gap(24),

            // New Bookings Section with BlocBuilder
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'New Bookings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          onPressed: _loadPendingBookings,
                          icon: const Icon(
                            Icons.refresh,
                            color: Color(0xFF6B73FF),
                          ),
                        ),
                      ],
                    ),
                    const Gap(5),

                    // BlocBuilder for BookingCubit
                    BlocBuilder<BookingCubit, BookingState>(
                      builder: (context, state) {
                        if (state is RenterPendingBookingsLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                color: Color(0xFF6B73FF),
                              ),
                            ),
                          );
                        }

                        if (state is RenterPendingBookingsError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red[400],
                                    size: 48,
                                  ),
                                  const Gap(12),
                                  Text(
                                    'Failed to load bookings',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                  const Gap(8),
                                  Text(
                                    state.message,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const Gap(16),
                                  ElevatedButton.icon(
                                    onPressed: _loadPendingBookings,
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Retry'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6B73FF),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (state is RenterPendingBookingsSuccess) {
                          if (state.bookings.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.event_available,
                                      color: Colors.grey[400],
                                      size: 64,
                                    ),
                                    const Gap(16),
                                    Text(
                                      'No new bookings',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Gap(8),
                                    Text(
                                      'New booking requests will appear here',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Convert BookingModel to BookingItem for display
                          final bookingItems = state.bookings.map((booking) {
                            // Create a display name from vehicle brand and model
                            final vehicleName =
                                '${booking.vehicleBrand ?? ''} ${booking.vehicleModel}'
                                    .trim();
                            final displayName = vehicleName.isNotEmpty
                                ? vehicleName
                                : 'Unknown Vehicle';

                            return BookingItem(
                              id: booking.id,
                              name: displayName,
                              service:
                                  '${booking.totalDays} ${booking.totalDays == 1 ? 'Day' : 'Days'} Rental',
                              time: _formatTime(booking.startDate),
                              date: _formatDate(booking.startDate),
                              status: booking.status,
                              color: _getStatusColor(booking.status),
                              initial: displayName.isNotEmpty
                                  ? displayName[0].toUpperCase()
                                  : 'V',
                            );
                          }).toList();

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookingItems.length,
                            separatorBuilder: (context, index) => const Gap(12),
                            itemBuilder: (context, index) {
                              final bookingItem = bookingItems[index];
                              final originalBooking = state.bookings[index];
                              return BookingCard(
                                booking: bookingItem,
                                onTap: () =>
                                    _navigateToBookingDetails(bookingItem),
                              );
                            },
                          );
                        }

                        // Default empty state for initial load
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.event_available,
                                  color: Colors.grey[400],
                                  size: 64,
                                ),
                                const Gap(16),
                                Text(
                                  'No new bookings',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  'New booking requests will appear here',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const Gap(20),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToBookingDetails(BookingItem booking) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailsScreenRenter(booking: booking),
      ),
    );

    // Refresh bookings if action was taken
    if (result != null && (result == 'accepted' || result == 'rejected')) {
      _loadPendingBookings();
    }
  }

  // Helper methods for formatting data
  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'TBD';
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'TBD';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFF6B73FF);
      case 'confirmed':
      case 'accepted':
        return const Color(0xFF10B981);
      case 'cancelled':
      case 'canceled':
        return const Color(0xFFEF4444);
      case 'rejected':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B73FF);
    }
  }
}
