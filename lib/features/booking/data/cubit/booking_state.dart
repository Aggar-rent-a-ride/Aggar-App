import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

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

class BookingMultipleOperationState extends BookingState {
  final bool isCreating;
  final bool isGettingById;
  final bool isGettingByStatus;
  final bool isGettingCount;
  final BookingModel? currentBooking;
  final List<BookingModel> bookings;
  final int? totalCount;
  final String? errorMessage;

  const BookingMultipleOperationState({
    this.isCreating = false,
    this.isGettingById = false,
    this.isGettingByStatus = false,
    this.isGettingCount = false,
    this.currentBooking,
    this.bookings = const [],
    this.totalCount,
    this.errorMessage,
  });

  BookingMultipleOperationState copyWith({
    bool? isCreating,
    bool? isGettingById,
    bool? isGettingByStatus,
    bool? isGettingCount,
    BookingModel? currentBooking,
    List<BookingModel>? bookings,
    int? totalCount,
    String? errorMessage,
  }) {
    return BookingMultipleOperationState(
      isCreating: isCreating ?? this.isCreating,
      isGettingById: isGettingById ?? this.isGettingById,
      isGettingByStatus: isGettingByStatus ?? this.isGettingByStatus,
      isGettingCount: isGettingCount ?? this.isGettingCount,
      currentBooking: currentBooking ?? this.currentBooking,
      bookings: bookings ?? this.bookings,
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
        currentBooking,
        bookings,
        totalCount,
        errorMessage,
      ];
}
