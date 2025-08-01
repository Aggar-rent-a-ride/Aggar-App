import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
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
import 'dart:async';

class MainScreenBody extends StatefulWidget {
  const MainScreenBody({super.key, required this.onRefresh});
  final VoidCallback onRefresh;
  @override
  State<MainScreenBody> createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<MainScreenBody> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<BookingInterval> _bookingIntervals = [];

  Timer? _refreshTimer;
  static const Duration _refreshInterval = Duration(seconds: 30);

  Timer? _debounceTimer;
  bool _isLoadingPending = false;
  bool _isLoadingIntervals = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _initialLoad();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _initialLoad() {
    _loadPendingBookings();
    _loadBookingIntervalsOnce();
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (timer) {
      if (mounted) {
        _loadPendingBookings();
      }
    });
  }

  void _loadPendingBookings() {
    if (_isLoadingPending) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted && !_isLoadingPending) {
        setState(() {
          _isLoadingPending = true;
        });
        context
            .read<BookingCubit>()
            .getRenterPendingBookings()
            .then((_) {
              if (mounted) {
                setState(() {
                  _isLoadingPending = false;
                });
              }
            })
            .catchError((error) {
              if (mounted) {
                setState(() {
                  _isLoadingPending = false;
                });
              }
            });
      }
    });
  }

  void _loadBookingIntervalsOnce() {
    if (_isLoadingIntervals) return;

    setState(() {
      _isLoadingIntervals = true;
    });

    context
        .read<BookingCubit>()
        .getBookingIntervals()
        .then((_) {
          if (mounted) {
            setState(() {
              _isLoadingIntervals = false;
            });
          }
        })
        .catchError((error) {
          if (mounted) {
            setState(() {
              _isLoadingIntervals = false;
            });
          }
        });
  }

  void _forceRefreshIntervals() {
    _loadBookingIntervalsOnce();
  }

  Future<void> _onRefresh() async {
    widget.onRefresh();
    _loadPendingBookings();
    _loadBookingIntervalsOnce();
    await Future.delayed(const Duration(seconds: 1));
  }

  List<BookingInterval> _getBookingIntervalsForDate(DateTime date) {
    return _bookingIntervals.where((interval) {
      final startDate = DateTime(
        interval.startDate.year,
        interval.startDate.month,
        interval.startDate.day,
      );
      final endDate = DateTime(
        interval.endDate.year,
        interval.endDate.month,
        interval.endDate.day,
      );
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
                customSnackBar(
                  context,
                  "Error",
                  'Failed to load booking intervals: ${state.message}',
                  SnackBarType.error,
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
                  left: 20,
                  right: 20,
                  top: 55,
                  bottom: 20,
                ),
                child: const MainHeader(isRenter: true),
              ),
              // Calendar Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.theme.white100_1,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Calendar',
                              style: AppStyles.bold20(
                                context,
                              ).copyWith(color: context.theme.black100),
                            ),
                            // Manual refresh button for calendar only
                            IconButton(
                              onPressed: _isLoadingIntervals
                                  ? null
                                  : _forceRefreshIntervals,
                              icon: _isLoadingIntervals
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: context.theme.blue100_1,
                                      ),
                                    )
                                  : Icon(
                                      Icons.refresh,
                                      color: context.theme.blue100_1,
                                      size: 20,
                                    ),
                            ),
                          ],
                        ),
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
                                  selectedDay,
                                  bookingsForDate,
                                );
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
                            titleTextStyle: AppStyles.semiBold16(
                              context,
                            ).copyWith(color: context.theme.black100),
                          ),
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            weekendTextStyle: AppStyles.semiBold16(
                              context,
                            ).copyWith(color: context.theme.black100),
                            holidayTextStyle: AppStyles.semiBold16(
                              context,
                            ).copyWith(color: context.theme.black100),
                            selectedDecoration: BoxDecoration(
                              color: context.theme.blue100_1,
                              shape: BoxShape.circle,
                            ),
                            selectedTextStyle: AppStyles.semiBold16(
                              context,
                            ).copyWith(color: context.theme.white100_1),
                            todayDecoration: BoxDecoration(
                              color: context.theme.grey100_1,
                              shape: BoxShape.circle,
                            ),
                            todayTextStyle: AppStyles.semiBold16(
                              context,
                            ).copyWith(color: context.theme.black100),
                            defaultTextStyle: TextStyle(
                              color: context.theme.black100,
                            ),
                            markersMaxCount: 3,
                            markerDecoration: BoxDecoration(
                              color: context.theme.green100_1,
                              shape: BoxShape.circle,
                            ),
                            markerSize: 6.0,
                            markerMargin: const EdgeInsets.symmetric(
                              horizontal: 1.0,
                            ),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: AppStyles.semiBold16(
                              context,
                            ).copyWith(color: context.theme.black50),
                            weekendStyle: AppStyles.semiBold16(
                              context,
                            ).copyWith(color: context.theme.black50),
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        const Gap(16),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(5),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: context.theme.white100_1,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 0),
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
                          Row(
                            children: [
                              Text(
                                'New Bookings',
                                style: AppStyles.bold18(
                                  context,
                                ).copyWith(color: context.theme.black100),
                              ),
                              const Gap(8),
                              // Auto-refresh indicator
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: context.theme.green100_1.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: context.theme.green100_1.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.autorenew,
                                      size: 12,
                                      color: context.theme.green100_1,
                                    ),
                                    const Gap(4),
                                    Text(
                                      'Auto',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: context.theme.green100_1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: _isLoadingPending
                                ? null
                                : _loadPendingBookings,
                            icon: _isLoadingPending
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: context.theme.blue100_1,
                                    ),
                                  )
                                : Icon(
                                    Icons.refresh,
                                    color: context.theme.blue100_1,
                                  ),
                          ),
                        ],
                      ),
                      BlocBuilder<BookingCubit, BookingState>(
                        builder: (context, state) {
                          if (state is RenterPendingBookingsLoading &&
                              !_isLoadingPending) {
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
                                        'New booking requests will appear here automatically',
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
                            print(state.bookings);
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
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
                                    'New booking requests will appear here automatically',
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const Gap(4),
        Text(
          label,
          style: AppStyles.semiBold12(
            context,
          ).copyWith(color: context.theme.black50),
        ),
      ],
    );
  }

  void _showBookingDetailsForDate(
    DateTime selectedDate,
    List<BookingInterval> bookings,
  ) {
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
      'Dec',
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
      'Dec',
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
