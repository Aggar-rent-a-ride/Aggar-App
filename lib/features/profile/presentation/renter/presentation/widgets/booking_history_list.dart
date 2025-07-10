import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_customer.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_renter.dart';
import 'package:aggar/features/main_screen/renter/data/model/booking_item.dart';
import 'package:aggar/features/profile/presentation/widgets/booking_card_widget.dart';
import 'package:aggar/features/profile/presentation/widgets/empty_state_widget.dart';
import 'package:aggar/features/profile/presentation/widgets/error_state_widget.dart';
import 'package:aggar/features/profile/presentation/widgets/status_filter_widget.dart';
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
      price: historyModel.finalPrice,
      finalPrice: historyModel.finalPrice,
      discount: 0.0,
      vehicleImagePath: null,
      vehicleYear: DateTime.now().year,
      vehicleModel: historyModel.vehicleModel,
      vehicleBrand: historyModel.vehicleBrand,
      vehicleType: historyModel.vehicleType,
      status: historyModel.bookingStatus,
      vehicleId: 0,
      startDate: historyModel.startDate,
      endDate: historyModel.endDate,
    );
  }

  // Convert BookingHistoryModel to BookingItem for renter navigation
  BookingItem _convertToBookingItem(BookingHistoryModel historyModel) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to determine user type. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_userType!.toLowerCase() == 'renter') {
      final bookingItem = _convertToBookingItem(booking);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingDetailsScreenRenter(
            booking: bookingItem,
          ),
        ),
      ).then((result) {
        if (result != null) {
          _loadBookingHistory(isRefresh: true);
        }
      });
    } else {
      final bookingModel = _convertToBookingModel(booking);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingDetailsScreenCustomer(
            booking: bookingModel,
          ),
        ),
      ).then((result) {
        if (result == true) {
          _loadBookingHistory(isRefresh: true);
        }
      });
    }
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
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is BookingHistoryError && _allBookings.isEmpty) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () => _loadBookingHistory(isRefresh: true),
          );
        }

        const filterHeight = 80.0;
        const gapHeight = 15.0;
        const minContentHeight = 200.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(15),
            StatusFilterWidget(
              selectedStatus: _selectedStatus,
              onStatusChanged: _onStatusFilterChanged,
            ),
            if (_allBookings.isEmpty)
              const EmptyStateWidget()
            else
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: minContentHeight,
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: RefreshIndicator(
                    onRefresh: () async => _loadBookingHistory(isRefresh: true),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      controller: _scrollController,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _allBookings.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < _allBookings.length) {
                          return BookingCardWidget(
                            booking: _allBookings[index],
                            onTap: () =>
                                _navigateToBookingDetails(_allBookings[index]),
                            getStatusColor: _getStatusColor,
                            formatDate: _formatDate,
                          );
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
              ),
          ],
        );
      },
    );
  }
}
