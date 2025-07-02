import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_customer.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_renter.dart';
import 'package:aggar/features/main_screen/renter/data/model/booking_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class BookingHistoryList extends StatefulWidget {
  const BookingHistoryList({super.key});

  @override
  State<BookingHistoryList> createState() => _BookingHistoryListState();
}

class _BookingHistoryListState extends State<BookingHistoryList> {
  final ScrollController _scrollController = ScrollController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  int _currentPage = 1;
  final int _pageSize = 10;
  List<BookingHistoryModel> _allBookings = [];
  bool _isLoadingMore = false;
  int _totalPages = 1;
  BookingStatus? _selectedStatus;
  String? _userType;

  @override
  void initState() {
    super.initState();
    _initializeUserType();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookingHistory();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeUserType() async {
    try {
      final userType = await _secureStorage.read(key: 'userType');
      setState(() {
        _userType = userType;
      });
    } catch (e) {
      print('Error getting user type: $e');
    }
  }

  void _loadBookingHistory({bool isRefresh = false}) {
    if (isRefresh) {
      _currentPage = 1;
      _allBookings.clear();
    }

    context.read<BookingCubit>().getBookingHistory(
          status: _selectedStatus,
          pageNo: _currentPage,
          pageSize: _pageSize,
        );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _currentPage < _totalPages) {
        _loadMoreBookings();
      }
    }
  }

  void _loadMoreBookings() {
    if (_currentPage < _totalPages && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
        _currentPage++;
      });

      context.read<BookingCubit>().getBookingHistory(
            status: _selectedStatus,
            pageNo: _currentPage,
            pageSize: _pageSize,
          );
    }
  }

  void _onStatusFilterChanged(BookingStatus? status) {
    setState(() {
      _selectedStatus = status;
      _currentPage = 1;
      _allBookings.clear();
    });
    _loadBookingHistory();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Convert BookingHistoryModel to BookingModel for customer navigation
  BookingModel _convertToBookingModel(BookingHistoryModel historyModel) {
    return BookingModel(
      id: historyModel.id,
      totalDays: historyModel.durationInDays,
      price: historyModel.finalPrice, // Using finalPrice as base price
      finalPrice: historyModel.finalPrice,
      discount: 0.0, // Not available in history model
      vehicleImagePath: null, // Not available in history model
      vehicleYear: DateTime.now().year, // Default year since not available
      vehicleModel: historyModel.vehicleModel,
      vehicleBrand: historyModel.vehicleBrand,
      vehicleType: historyModel.vehicleType,
      status: historyModel.bookingStatus,
      vehicleId: 0, // Not available in history model
      startDate: historyModel.startDate,
      endDate: historyModel.endDate,
    );
  }

  // Convert BookingHistoryModel to BookingItem for renter navigation
  BookingItem _convertToBookingItem(BookingHistoryModel historyModel) {
    // Generate a color based on booking ID for consistency
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    final color = colors[historyModel.id % colors.length];

    // Extract initial from vehicle model or use default
    final initial = historyModel.vehicleModel.isNotEmpty
        ? historyModel.vehicleModel[0].toUpperCase()
        : 'V';

    return BookingItem(
      id: historyModel.id,
      name: '${historyModel.vehicleBrand} ${historyModel.vehicleModel}',
      date: _formatDate(historyModel.startDate.toString()),
      status: historyModel.bookingStatus,
      initial: initial,
      color: color,
      service: '',
      time: '',
    );
  }

  void _navigateToBookingDetails(BookingHistoryModel booking) {
    if (_userType == null) {
      // If user type is not loaded yet, show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to determine user type. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_userType!.toLowerCase() == 'renter') {
      // Navigate to renter details screen
      final bookingItem = _convertToBookingItem(booking);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingDetailsScreenRenter(
            booking: bookingItem,
          ),
        ),
      ).then((result) {
        // Refresh the list if booking was updated
        if (result != null) {
          _loadBookingHistory(isRefresh: true);
        }
      });
    } else {
      // Navigate to customer details screen (default behavior)
      final bookingModel = _convertToBookingModel(booking);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingDetailsScreenCustomer(
            booking: bookingModel,
          ),
        ),
      ).then((result) {
        // Refresh the list if booking was cancelled or updated
        if (result == true) {
          _loadBookingHistory(isRefresh: true);
        }
      });
    }
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<BookingStatus?>(
        value: _selectedStatus,
        decoration: InputDecoration(
          labelText: 'Filter by Status',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: [
          const DropdownMenuItem<BookingStatus?>(
            value: null,
            child: Text('All Status'),
          ),
          ...BookingStatus.values.map((status) => DropdownMenuItem(
                value: status,
                child: Text(status.value),
              )),
        ],
        onChanged: _onStatusFilterChanged,
      ),
    );
  }

  Widget _buildBookingCard(BookingHistoryModel booking) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToBookingDetails(booking),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${booking.vehicleBrand} ${booking.vehicleModel}',
                      style: AppStyles.bold16(context),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.bookingStatus)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getStatusColor(booking.bookingStatus),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      booking.bookingStatus,
                      style: AppStyles.medium12(context).copyWith(
                        color: _getStatusColor(booking.bookingStatus),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Vehicle Type: ${booking.vehicleType}',
                style: AppStyles.medium14(context).copyWith(
                  color: context.theme.black50,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: context.theme.black50,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_formatDate(booking.startDate.toString())} - ${_formatDate(booking.endDate.toString())}',
                    style: AppStyles.medium14(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.receipt,
                        size: 16,
                        color: context.theme.black50,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Booking #${booking.id}',
                        style: AppStyles.medium12(context).copyWith(
                          color: context.theme.black50,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${booking.finalPrice}',
                        style: AppStyles.bold16(context).copyWith(
                          color: context.theme.blue100_2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: context.theme.black50,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: context.theme.black50,
          ),
          const SizedBox(height: 16),
          Text(
            'No booking history found',
            style: AppStyles.bold18(context).copyWith(
              color: context.theme.black50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your booking history will appear here',
            style: AppStyles.medium14(context).copyWith(
              color: context.theme.black50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading booking history',
            style: AppStyles.bold18(context).copyWith(
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppStyles.medium14(context).copyWith(
              color: context.theme.black50,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _loadBookingHistory(isRefresh: true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingHistorySuccess) {
          setState(() {
            if (_currentPage == 1) {
              _allBookings = state.bookings.reversed.toList();
            } else {
              _allBookings.addAll(state.bookings.reversed.toList());
            }
            _totalPages = state.totalPages;
            _isLoadingMore = false;
          });
        } else if (state is BookingHistoryError) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      },
      builder: (context, state) {
        if (state is BookingHistoryLoading && _allBookings.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is BookingHistoryError && _allBookings.isEmpty) {
          return _buildErrorState(state.message);
        }

        return Column(
          children: [
            const Gap(15),
            _buildStatusFilter(),
            if (_allBookings.isEmpty)
              Expanded(child: _buildEmptyState())
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _loadBookingHistory(isRefresh: true),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _allBookings.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < _allBookings.length) {
                        return _buildBookingCard(_allBookings[index]);
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
