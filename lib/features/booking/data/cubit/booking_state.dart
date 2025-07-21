import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

// Create booking states
class BookingCreateLoading extends BookingState {}

class BookingCreateSuccess extends BookingState {
  final BookingModel booking;

  const BookingCreateSuccess({required this.booking});

  @override
  List<Object?> get props => [booking];
}

class BookingCreateError extends BookingState {
  final String message;

  const BookingCreateError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Get booking by ID states
class BookingGetByIdLoading extends BookingState {}

class BookingGetByIdSuccess extends BookingState {
  final BookingModel booking;

  const BookingGetByIdSuccess({required this.booking});

  @override
  List<Object?> get props => [booking];
}

class BookingGetByIdError extends BookingState {
  final String message;

  const BookingGetByIdError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Get bookings by status states
class BookingsGetByStatusLoading extends BookingState {}

class BookingsGetByStatusSuccess extends BookingState {
  final List<BookingModel> bookings;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  const BookingsGetByStatusSuccess({
    required this.bookings,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [bookings, totalPages, currentPage, pageSize];
}

class BookingsGetByStatusError extends BookingState {
  final String message;

  const BookingsGetByStatusError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bookings count states
class BookingsCountLoading extends BookingState {}

class BookingsCountSuccess extends BookingState {
  final int count;
  final BookingStatus? status;

  const BookingsCountSuccess({
    required this.count,
    this.status,
  });

  @override
  List<Object?> get props => [count, status];
}

class BookingsCountError extends BookingState {
  final String message;

  const BookingsCountError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Renter pending bookings states
class RenterPendingBookingsLoading extends BookingState {}

class RenterPendingBookingsSuccess extends BookingState {
  final List<BookingModel> bookings;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  const RenterPendingBookingsSuccess({
    required this.bookings,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [bookings, totalPages, currentPage, pageSize];
}

class RenterPendingBookingsError extends BookingState {
  final String message;

  const RenterPendingBookingsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class BookingHistoryLoading extends BookingState {}

class BookingHistorySuccess extends BookingState {
  final List<BookingHistoryModel> bookings;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final BookingStatus? status;

  const BookingHistorySuccess({
    required this.bookings,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    this.status,
  });

  @override
  List<Object?> get props =>
      [bookings, totalPages, currentPage, pageSize, status];
}

class BookingHistoryError extends BookingState {
  final String message;

  const BookingHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

class BookingIntervalsLoading extends BookingState {}

class BookingIntervalsSuccess extends BookingState {
  final List<BookingInterval> intervals;

  const BookingIntervalsSuccess({required this.intervals});

  @override
  List<Object?> get props => [intervals];
}

class BookingIntervalsError extends BookingState {
  final String message;

  const BookingIntervalsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class BookingCancelLoading extends BookingState {
  const BookingCancelLoading();
}

class BookingCancelSuccess extends BookingState {
  final String message;
  final int bookingId;

  const BookingCancelSuccess({
    required this.message,
    required this.bookingId,
  });

  @override
  List<Object> get props => [message, bookingId];
}

class BookingCancelError extends BookingState {
  final String message;

  const BookingCancelError({required this.message});

  @override
  List<Object> get props => [message];
}

class BookingResponseLoading extends BookingState {
  const BookingResponseLoading();
}

class BookingResponseSuccess extends BookingState {
  final String message;
  final int bookingId;
  final bool isAccepted;

  const BookingResponseSuccess({
    required this.message,
    required this.bookingId,
    required this.isAccepted,
  });

  @override
  List<Object> get props => [message, bookingId, isAccepted];
}

class BookingResponseError extends BookingState {
  final String message;

  const BookingResponseError({required this.message});

  @override
  List<Object> get props => [message];
}

class BookingConfirmLoading extends BookingState {
  const BookingConfirmLoading();
}

class BookingConfirmSuccess extends BookingState {
  final String message;
  final int bookingId;
  final String? clientSecret;
  final BookingModel booking;

  const BookingConfirmSuccess({
    required this.message,
    required this.bookingId,
    this.clientSecret,
    required this.booking,
  });

  @override
  List<Object?> get props => [message, bookingId, clientSecret, booking];
}

class BookingConfirmError extends BookingState {
  final String message;

  const BookingConfirmError({required this.message});

  @override
  List<Object> get props => [message];
}

class BookingMultipleOperationState extends BookingState {
  final bool isCreating;
  final bool isGettingById;
  final bool isGettingByStatus;
  final bool isGettingCount;
  final bool isGettingRenterPending;
  final bool isGettingHistory;
  final bool isGettingIntervals;
  final BookingModel? currentBooking;
  final List<BookingModel> bookings;
  final List<BookingModel> renterPendingBookings;
  final List<BookingHistoryModel> historyBookings;
  final List<BookingInterval> intervals;
  final int? totalCount;
  final String? errorMessage;

  const BookingMultipleOperationState({
    this.isCreating = false,
    this.isGettingById = false,
    this.isGettingByStatus = false,
    this.isGettingCount = false,
    this.isGettingRenterPending = false,
    this.isGettingHistory = false,
    this.isGettingIntervals = false,
    this.currentBooking,
    this.bookings = const [],
    this.renterPendingBookings = const [],
    this.historyBookings = const [],
    this.intervals = const [],
    this.totalCount,
    this.errorMessage,
  });

  BookingMultipleOperationState copyWith({
    bool? isCreating,
    bool? isGettingById,
    bool? isGettingByStatus,
    bool? isGettingCount,
    bool? isGettingRenterPending,
    bool? isGettingHistory,
    bool? isGettingIntervals,
    BookingModel? currentBooking,
    List<BookingModel>? bookings,
    List<BookingModel>? renterPendingBookings,
    List<BookingHistoryModel>? historyBookings,
    List<BookingInterval>? intervals,
    int? totalCount,
    String? errorMessage,
  }) {
    return BookingMultipleOperationState(
      isCreating: isCreating ?? this.isCreating,
      isGettingById: isGettingById ?? this.isGettingById,
      isGettingByStatus: isGettingByStatus ?? this.isGettingByStatus,
      isGettingCount: isGettingCount ?? this.isGettingCount,
      isGettingRenterPending:
          isGettingRenterPending ?? this.isGettingRenterPending,
      isGettingHistory: isGettingHistory ?? this.isGettingHistory,
      isGettingIntervals: isGettingIntervals ?? this.isGettingIntervals,
      currentBooking: currentBooking ?? this.currentBooking,
      bookings: bookings ?? this.bookings,
      renterPendingBookings:
          renterPendingBookings ?? this.renterPendingBookings,
      historyBookings: historyBookings ?? this.historyBookings,
      intervals: intervals ?? this.intervals, // NEW
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isCreating,
        isGettingById,
        isGettingByStatus,
        isGettingCount,
        isGettingRenterPending,
        isGettingHistory,
        isGettingIntervals,
        currentBooking,
        bookings,
        renterPendingBookings,
        historyBookings,
        intervals,
        totalCount,
        errorMessage,
      ];
}

class BookingInterval extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const BookingInterval({
    required this.startDate,
    required this.endDate,
  });

  factory BookingInterval.fromJson(Map<String, dynamic> json) {
    return BookingInterval(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [startDate, endDate];
}
