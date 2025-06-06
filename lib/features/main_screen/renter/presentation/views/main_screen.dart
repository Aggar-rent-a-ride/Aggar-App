import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/widgets/main_header.dart';
import 'package:aggar/features/notification/presentation/views/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gap/gap.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _currentAccessToken = '';
  bool _isLoadingToken = true; // Add loading state

  // Sample booking data
  final List<BookingItem> _bookings = [
    BookingItem(
      name: 'Mike Chen',
      service: 'Hair Cut & Trim',
      time: '2:15 PM',
      date: 'Dec 10',
      status: 'Pending',
      color: const Color(0xFF6B73FF),
      initial: 'M',
    ),
    BookingItem(
      name: 'Emma Davis',
      service: 'Color Treatment',
      time: '4:00 PM',
      date: 'Dec 10',
      status: 'Pending',
      color: const Color(0xFF8B5CF6),
      initial: 'E',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    WidgetsBinding.instance.addObserver(this);

    // Load token immediately when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRefreshToken();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkAndRefreshToken();
    }
  }

  Future<void> _checkAndRefreshToken() async {
    if (!mounted) return;

    setState(() {
      _isLoadingToken = true;
    });

    final tokenCubit = context.read<TokenRefreshCubit>();

    try {
      // First try to get existing valid token
      String? token = tokenCubit.currentAccessToken;

      // If no cached token or it's expired, get a fresh one
      if (token == null || token.isEmpty) {
        token = await tokenCubit.getAccessToken();
      }

      if (mounted && token != null && token.isNotEmpty) {
        setState(() {
          _currentAccessToken = token!;
          _isLoadingToken = false;
        });
        print(
            'Token loaded successfully: ${token.substring(0, 10)}...'); // Log first 10 chars for debugging
      } else {
        if (mounted) {
          setState(() {
            _currentAccessToken = '';
            _isLoadingToken = false;
          });
        }
        print('Failed to load token');
      }
    } catch (e) {
      print('Error checking token: $e');
      if (mounted) {
        setState(() {
          _currentAccessToken = '';
          _isLoadingToken = false;
        });
        _handleTokenRefreshFailure();
      }
    }
  }

  void _handleTokenRefreshFailure() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session expired. Please login again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _onRefresh() async {
    await _checkAndRefreshToken();
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocListener<TokenRefreshCubit, TokenRefreshState>(
        listener: (context, state) {
          if (state is TokenRefreshFailure) {
            _handleTokenRefreshFailure();
          } else if (state is TokenRefreshSuccess) {
            setState(() {
              _currentAccessToken = state.accessToken;
              _isLoadingToken = false;
            });
            print(
                'Token updated from BLoC: ${state.accessToken.substring(0, 10)}...');
          }
        },
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
                  child: _isLoadingToken
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
                        )
                      : MainHeader(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationScreen(),
                              )),
                          accesstoken:
                              _currentAccessToken, // This will now have the actual token
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

                // Show bookings only if token is loaded
                if (!_isLoadingToken)
                  Container(
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
                          const Text(
                            'New Bookings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const Gap(16),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _bookings.length,
                            separatorBuilder: (context, index) => const Gap(12),
                            itemBuilder: (context, index) {
                              final booking = _bookings[index];
                              return BookingCard(booking: booking);
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
      ),
    );
  }
}

// Your existing BookingCard and BookingItem classes remain the same...
class BookingCard extends StatelessWidget {
  final BookingItem booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: booking.color,
            child: Text(
              booking.initial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const Gap(12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Gap(2),
                Text(
                  booking.service,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Gap(4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.orange[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                booking.time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                booking.date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const Gap(8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final tokenCubit = context.read<TokenRefreshCubit>();
                      final token = await tokenCubit.getAccessToken();

                      if (token != null && token.isNotEmpty) {
                        // Handle accept action with valid token
                        _handleAcceptBooking(context, booking);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Session expired. Please login again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const Gap(8),
                  GestureDetector(
                    onTap: () async {
                      // Ensure valid token before making API call
                      final tokenCubit = context.read<TokenRefreshCubit>();
                      final token = await tokenCubit.getAccessToken();

                      if (token != null && token.isNotEmpty) {
                        _handleRejectBooking(context, booking);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Session expired. Please login again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAcceptBooking(BuildContext context, BookingItem booking) {
    print('Accepting booking for ${booking.name}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted booking for ${booking.name}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleRejectBooking(BuildContext context, BookingItem booking) {
    print('Rejecting booking for ${booking.name}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rejected booking for ${booking.name}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class BookingItem {
  final String name;
  final String service;
  final String time;
  final String date;
  final String status;
  final Color color;
  final String initial;

  BookingItem({
    required this.name,
    required this.service,
    required this.time,
    required this.date,
    required this.status,
    required this.color,
    required this.initial,
  });
}
