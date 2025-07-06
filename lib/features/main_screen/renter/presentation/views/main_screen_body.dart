import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_renter.dart';
import 'package:aggar/features/main_screen/renter/data/model/booking_item.dart';
import 'package:aggar/features/main_screen/renter/presentation/widgets/booking_card.dart';
import 'package:aggar/features/main_screen/widgets/main_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gap/gap.dart';
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

  List<BookingInterval> _bookingIntervals = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadPendingBookings();
    _loadBookingIntervals();
  }

  void _loadPendingBookings() {
    context.read<BookingCubit>().getRenterPendingBookings();
  }

  void _loadBookingIntervals() {
    context.read<BookingCubit>().getBookingIntervals();
  }

  Future<void> _onRefresh() async {
    widget.onRefresh();
    _loadPendingBookings();
    _loadBookingIntervals();
    await Future.delayed(const Duration(seconds: 1));
  }

  List<BookingInterval> _getBookingIntervalsForDate(DateTime date) {
    return _bookingIntervals.where((interval) {
      final startDate = DateTime(interval.startDate.year,
          interval.startDate.month, interval.startDate.day);
      final endDate = DateTime(
          interval.endDate.year, interval.endDate.month, interval.endDate.day);
      final checkDate = DateTime(date.year, date.month, date.day);

      return checkDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          checkDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingIntervalsSuccess) {
              setState(() {
                _bookingIntervals = state.intervals;
              });
            } else if (state is BookingIntervalsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Failed to load booking intervals: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: RefreshIndicator(
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
                child: const MainHeader(),
              ),

              // Calendar Section
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.theme.white100_1,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Calendar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: context.theme.black100,
                              ),
                            ),
                            // Add refresh button for calendar
                            IconButton(
                              onPressed: _loadBookingIntervals,
                              icon: Icon(
                                Icons.refresh,
                                color: context.theme.blue100_1,
                                size: 20,
                              ),
                            ),
                          ],
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
                          eventLoader: (day) {
                            return _getBookingIntervalsForDate(day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!isSameDay(_selectedDay, selectedDay)) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });

                              final bookingsForDate =
                                  _getBookingIntervalsForDate(selectedDay);
                              if (bookingsForDate.isNotEmpty) {
                                _showBookingDetailsForDate(
                                    selectedDay, bookingsForDate);
                              }
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
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: context.theme.grey100_1,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: context.theme.grey100_1,
                            ),
                            titleTextStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: context.theme.black100,
                            ),
                          ),
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            weekendTextStyle: TextStyle(
                              color: context.theme.black100,
                            ),
                            holidayTextStyle: TextStyle(
                              color: context.theme.black100,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: context.theme.blue100_1,
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: context.theme.grey100_1,
                              shape: BoxShape.circle,
                            ),
                            defaultTextStyle: TextStyle(
                              color: context.theme.black100,
                            ),
                            markersMaxCount: 3,
                            markerDecoration: BoxDecoration(
                              color: context.theme.green100_1,
                              shape: BoxShape.circle,
                            ),
                            markerSize: 6.0,
                            markerMargin:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                              color: context.theme.grey100_1,
                              fontWeight: FontWeight.w500,
                            ),
                            weekendStyle: TextStyle(
                              color: context.theme.grey100_1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, date, events) {
                              if (events.isNotEmpty) {
                                return Positioned(
                                  bottom: 1,
                                  child: Container(
                                    height: 6,
                                    width: 6,
                                    decoration: BoxDecoration(
                                      color: context.theme.green100_1,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                        ),

                        // Add legend for calendar
                        const Gap(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildLegendItem(
                              color: context.theme.blue100_1,
                              label: 'Selected',
                            ),
                            _buildLegendItem(
                              color: context.theme.grey100_1,
                              label: 'Today',
                            ),
                            _buildLegendItem(
                              color: context.theme.green100_1,
                              label: 'Booked',
                            ),
                          ],
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
                  color: context.theme.white100_1,
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
                          Text(
                            'New Bookings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: context.theme.black100,
                            ),
                          ),
                          IconButton(
                            onPressed: _loadPendingBookings,
                            icon: Icon(
                              Icons.refresh,
                              color: context.theme.blue100_1,
                            ),
                          ),
                        ],
                      ),
                      const Gap(5),

                      // BlocBuilder for BookingCubit
                      BlocBuilder<BookingCubit, BookingState>(
                        builder: (context, state) {
                          if (state is RenterPendingBookingsLoading) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(
                                  color: context.theme.blue100_1,
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
                                      color: context.theme.red100_1,
                                      size: 48,
                                    ),
                                    const Gap(12),
                                    Text(
                                      'Failed to load bookings',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: context.theme.red100_1,
                                      ),
                                    ),
                                    const Gap(8),
                                    Text(
                                      state.message,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: context.theme.grey100_1,
                                      ),
                                    ),
                                    const Gap(16),
                                    ElevatedButton.icon(
                                      onPressed: _loadPendingBookings,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Retry'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            context.theme.blue100_1,
                                        foregroundColor:
                                            context.theme.white100_1,
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
                                        color: context.theme.grey100_1,
                                        size: 64,
                                      ),
                                      const Gap(16),
                                      Text(
                                        'No new bookings',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: context.theme.grey100_1,
                                        ),
                                      ),
                                      const Gap(8),
                                      Text(
                                        'New booking requests will appear here',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: context.theme.grey100_1,
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
                              separatorBuilder: (context, index) =>
                                  const Gap(12),
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
                                    color: context.theme.grey100_1,
                                    size: 64,
                                  ),
                                  const Gap(16),
                                  Text(
                                    'No new bookings',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: context.theme.grey100_1,
                                    ),
                                  ),
                                  const Gap(8),
                                  Text(
                                    'New booking requests will appear here',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: context.theme.grey100_1,
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
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const Gap(4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: context.theme.grey100_1,
          ),
        ),
      ],
    );
  }

  void _showBookingDetailsForDate(
      DateTime selectedDate, List<BookingInterval> bookings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.theme.white100_1,
        title: Text(
          'Bookings for ${_formatDate(selectedDate)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: context.theme.black100,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: context.theme.white100_2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Period',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: context.theme.black100,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        'From: ${_formatFullDate(booking.startDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.theme.grey100_1,
                        ),
                      ),
                      Text(
                        'To: ${_formatFullDate(booking.endDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.theme.grey100_1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: context.theme.blue100_1),
            ),
          ),
        ],
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

  String _formatFullDate(DateTime dateTime) {
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
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return context.theme.blue100_1;
      case 'confirmed':
      case 'accepted':
        return context.theme.green100_1;
      case 'cancelled':
      case 'canceled':
        return context.theme.red100_1;
      case 'rejected':
        return context.theme.red100_1;
      default:
        return context.theme.blue100_1;
    }
  }
}
