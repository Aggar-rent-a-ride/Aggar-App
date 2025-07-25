import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:dio/dio.dart';

class BookingCubit extends Cubit<BookingState> {
  final DioConsumer dioConsumer;
  final TokenRefreshCubit tokenRefreshCubit;

  BookingCubit({
    required this.dioConsumer,
    required this.tokenRefreshCubit,
  }) : super(BookingInitial());

  Future<void> createBooking({
    required int vehicleId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    emit(BookingCreateLoading());

    try {
      final formData = FormData.fromMap({
        'VehicleId': vehicleId.toString(),
        'StartDate': startDate.toIso8601String(),
        'EndDate': endDate.toIso8601String(),
      });

      final response = await _makeAuthenticatedRequest(
        () async => dioConsumer.post(
          EndPoint.createBooking,
          data: formData,
          options: await _getAuthOptions(),
          isFromData: true,
        ),
      );

      final responseData = response as Map<String, dynamic>;
      final statusCode = _getStatusCode(responseData);

      if (_isSuccessStatus(statusCode)) {
        final bookingData = responseData['data'] ?? responseData;
        final booking =
            BookingModel.fromJson(bookingData as Map<String, dynamic>);
        emit(BookingCreateSuccess(booking: booking));
      } else {
        emit(BookingCreateError(
          message:
              responseData['message']?.toString() ?? 'Failed to create booking',
        ));
      }
    } catch (e) {
      _handleError(e, (message) => BookingCreateError(message: message));
    }
  }

  Future<void> getBookingById(int bookingId) async {
    emit(BookingGetByIdLoading());

    try {
      final response = await _makeAuthenticatedRequest(
        () async => dioConsumer.get(
          EndPoint.getBookingById,
          queryParameters: {'id': bookingId},
          options: await _getAuthOptions(),
        ),
      );

      final responseData = response as Map<String, dynamic>;
      final statusCode = _getStatusCode(responseData);
      if (statusCode == 200) {
        final bookingData = responseData['data'] ?? responseData;
        final booking =
            BookingModel.fromJson(bookingData as Map<String, dynamic>);
        emit(BookingGetByIdSuccess(booking: booking));
      } else {
        emit(BookingGetByIdError(
          message:
              responseData['message']?.toString() ?? 'Failed to get booking',
        ));
      }
    } catch (e) {
      _handleError(e, (message) => BookingGetByIdError(message: message));
    }
  }

  Future<void> getRenterPendingBookings({
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    emit(RenterPendingBookingsLoading());

    try {
      final queryParams = <String, dynamic>{
        'pageNo': pageNo,
        'pageSize': pageSize,
      };

      final response = await _makeAuthenticatedRequest(
        () async => dioConsumer.get(
          EndPoint.getRenterPendingBookings,
          queryParameters: queryParams,
          options: await _getAuthOptions(),
        ),
      );

      final responseData = response as Map<String, dynamic>;
      final statusCode = _getStatusCode(responseData);

      if (statusCode == 200) {
        final bookingsData = responseData['data'] ?? responseData;
        final result = _parseBookingsResponse(bookingsData, pageNo, pageSize);

        if (result != null) {
          emit(RenterPendingBookingsSuccess(
            bookings: result['bookings'],
            totalPages: result['totalPages'],
            currentPage: result['currentPage'],
            pageSize: result['pageSize'],
          ));
        } else {
          emit(const RenterPendingBookingsError(
              message: 'Invalid response format'));
        }
      } else {
        emit(RenterPendingBookingsError(
          message: responseData['message']?.toString() ??
              'Failed to get renter pending bookings',
        ));
      }
    } catch (e) {
      _handleError(
          e, (message) => RenterPendingBookingsError(message: message));
    }
  }

  Future<void> getBookingHistory({
    BookingStatus? status,
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    emit(BookingHistoryLoading());

    try {
      final queryParams = <String, dynamic>{
        'pageNo': pageNo,
        'pageSize': pageSize,
      };

      if (status != null) {
        queryParams['status'] = status.value;
      }

      final response = await _makeAuthenticatedRequest(
        () async => dioConsumer.get(
          EndPoint.getBookingHistory,
          queryParameters: queryParams,
          options: await _getAuthOptions(),
        ),
      );

      final responseData = response as Map<String, dynamic>;
      final statusCode = _getStatusCode(responseData);

      if (statusCode == 200) {
        final historyData = responseData['data'] ?? responseData;
        final result =
            _parseBookingHistoryResponse(historyData, pageNo, pageSize);

        if (result != null) {
          emit(BookingHistorySuccess(
            bookings: result['bookings'],
            totalPages: result['totalPages'],
            currentPage: result['currentPage'],
            pageSize: result['pageSize'],
            status: status,
          ));
        } else {
          emit(const BookingHistoryError(message: 'Invalid response format'));
        }
      } else {
        emit(BookingHistoryError(
          message: responseData['message']?.toString() ??
              'Failed to get booking history',
        ));
      }
    } catch (e) {
      _handleError(e, (message) => BookingHistoryError(message: message));
    }
  }

  Future<void> getBookingIntervals() async {
    emit(BookingIntervalsLoading());

    try {
      final response = await _makeAuthenticatedRequest(
        () async => dioConsumer.get(
          EndPoint.getBookingIntervals,
          options: await _getAuthOptions(),
        ),
      );

      final responseData = response as Map<String, dynamic>;
      final statusCode = _getStatusCode(responseData);

      if (statusCode == 200) {
        final intervalsData = responseData['data'] ?? responseData;
        final intervals = _parseBookingIntervalsResponse(intervalsData);

        if (intervals != null) {
          emit(BookingIntervalsSuccess(intervals: intervals));
        } else {
          emit(const BookingIntervalsError(message: 'Invalid response format'));
        }
      } else {
        emit(BookingIntervalsError(
          message: responseData['message']?.toString() ??
              'Failed to get booking intervals',
        ));
      }
    } catch (e) {
      _handleError(e, (message) => BookingIntervalsError(message: message));
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    emit(const BookingCancelLoading());

    try {
      final response = await _makeAuthenticatedRequest(
        () async => dioConsumer.put(
          EndPoint.cancelBooking,
          queryParameters: {'id': bookingId},
          options: await _getAuthOptions(),
        ),
      );

      final responseData = response as Map<String, dynamic>;
      final statusCode = _getStatusCode(responseData);

      if (statusCode == 200) {
        final message = responseData['message']?.toString() ??
            'Booking canceled successfully';
        emit(BookingCancelSuccess(message: message, bookingId: bookingId));
      } else {
        emit(BookingCancelError(
          message:
              responseData['message']?.toString() ?? 'Failed to cancel booking',
        ));
      }
    } catch (e) {
      _handleError(e, (message) => BookingCancelError(message: message));
    }
  }

  Future<void> respondToBooking({
    required int bookingId,
    required bool isAccepted,
  }) async {
    emit(const BookingResponseLoading());

    try {
      final response = await _makeAuthenticatedRequest(
        () async => dioConsumer.put(
          EndPoint.bookingResponse,
          queryParameters: {
            'id': bookingId,
            'isAccepted': isAccepted.toString(),
          },
          options: await _getAuthOptions(),
        ),
      );

      final responseData = response as Map<String, dynamic>;
      final statusCode = _getStatusCode(responseData);

      if (statusCode == 200) {
        final message = responseData['message']?.toString() ??
            (isAccepted
                ? 'You accepted this booking successfully.'
                : 'You rejected this booking successfully.');

        emit(BookingResponseSuccess(
          message: message,
          bookingId: bookingId,
          isAccepted: isAccepted,
        ));
      } else {
        final message = responseData['message']?.toString() ??
            'Failed to respond to booking';

        emit(BookingResponseError(message: message));
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {
        final responseData = e.response?.data as Map<String, dynamic>? ?? {};
        final message = responseData['message']?.toString() ??
            'You need to create a payment account to accept bookings.';

        emit(BookingResponseError(message: message));
      } else {
        _handleError(e, (message) => BookingResponseError(message: message));
      }
    }
  }

  Future<void> confirmBooking(int bookingId) async {
    BookingModel? currentBooking;
    final currentState = state;
    if (currentState is BookingGetByIdSuccess) {
      currentBooking = currentState.booking;
    }
    emit(const BookingConfirmLoading());

    try {
      final response = await _makeAuthenticatedRequest(
        () async => dioConsumer.get(
          '/api/booking/confirm',
          queryParameters: {'id': bookingId},
          options: await _getAuthOptions(),
        ),
      );

      final responseData = response as Map<String, dynamic>;
      final statusCode = _getStatusCode(responseData);

      if (_isSuccessStatus(statusCode)) {
        final data = responseData['data'] as Map<String, dynamic>?;
        final clientSecret = data?['clientSecret'] as String?;
        final message = responseData['message']?.toString() ??
            'Payment session created successfully';

        if (currentBooking != null) {
          emit(BookingConfirmSuccess(
            message: message,
            bookingId: bookingId,
            clientSecret: clientSecret,
            booking: currentBooking,
          ));
        } else {
          emit(const BookingConfirmError(
            message: 'Booking data not available',
          ));
        }
      } else {
        print('DEBUG: Emitting BookingConfirmError');
        emit(BookingConfirmError(
          message: responseData['message']?.toString() ??
              'Failed to confirm booking',
        ));
      }
    } catch (e) {
      print('DEBUG: Error in confirmBooking: $e');
      _handleError(e, (message) => BookingConfirmError(message: message));
    }
  }

  Future<void> acceptBooking(int bookingId) async {
    await respondToBooking(bookingId: bookingId, isAccepted: true);
  }

  Future<void> rejectBooking(int bookingId) async {
    await respondToBooking(bookingId: bookingId, isAccepted: false);
  }

  Future<void> refreshRenterPendingBookings({
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    await getRenterPendingBookings(pageNo: pageNo, pageSize: pageSize);
  }

  Future<void> refreshBookingHistory({
    BookingStatus? status,
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    await getBookingHistory(status: status, pageNo: pageNo, pageSize: pageSize);
  }

  Future<void> refreshBookingIntervals() async {
    await getBookingIntervals();
  }

  void resetState() {
    emit(BookingInitial());
  }

  Future<Options> _getAuthOptions() async {
    final token = await tokenRefreshCubit.ensureValidToken();
    print("CURRENT TOKEN: $token");

    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<dynamic> _makeAuthenticatedRequest(
    Future<dynamic> Function() apiCall,
  ) async {
    try {
      await tokenRefreshCubit.ensureValidToken();
      return await apiCall();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        try {
          await tokenRefreshCubit.refreshToken();
          return await apiCall();
        } catch (refreshError) {
          throw DioException(
            requestOptions: e.requestOptions,
            response: e.response,
            type: DioExceptionType.badResponse,
            error: 'Authentication failed. Please login again.',
          );
        }
      }
      rethrow;
    }
  }

  int _getStatusCode(Map<String, dynamic> responseData) {
    return responseData['statusCode'] ??
        (responseData.containsKey('status') ? responseData['status'] : 200);
  }

  bool _isSuccessStatus(int statusCode) {
    return statusCode == 200 || statusCode == 201;
  }

  void _handleError(
      dynamic error, BookingState Function(String) createErrorState) {
    if (error is DioException && error.response?.statusCode == 401) {
      emit(createErrorState('Authentication failed. Please login again.'));
    } else {
      emit(createErrorState(error.toString()));
    }
  }

  Map<String, dynamic>? _parseBookingsResponse(
    dynamic bookingsData,
    int pageNo,
    int pageSize,
  ) {
    if (bookingsData is Map) {
      final bookingsMap = Map<String, dynamic>.from(bookingsData);

      if (bookingsMap.containsKey('data')) {
        final bookingsResponse = BookingsResponse.fromJson(bookingsMap);
        return {
          'bookings': bookingsResponse.data,
          'totalPages': bookingsResponse.totalPages,
          'currentPage': bookingsResponse.pageNumber,
          'pageSize': bookingsResponse.pageSize,
        };
      }
    } else if (bookingsData is List) {
      final bookings = bookingsData
          .where((item) => item != null)
          .map((item) =>
              BookingModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();

      return {
        'bookings': bookings,
        'totalPages': 1,
        'currentPage': pageNo,
        'pageSize': pageSize,
      };
    }
    return null;
  }

  Map<String, dynamic>? _parseBookingHistoryResponse(
    dynamic historyData,
    int pageNo,
    int pageSize,
  ) {
    if (historyData is Map) {
      final historyMap = Map<String, dynamic>.from(historyData);

      if (historyMap.containsKey('data')) {
        final bookingsList = historyMap['data'] as List?;
        if (bookingsList != null) {
          final bookings = bookingsList
              .where((item) => item != null)
              .map((item) => BookingHistoryModel.fromJson(
                  Map<String, dynamic>.from(item as Map)))
              .toList();

          return {
            'bookings': bookings,
            'totalPages': historyMap['totalPages'] ?? 1,
            'currentPage': historyMap['pageNumber'] ?? pageNo,
            'pageSize': historyMap['pageSize'] ?? pageSize,
          };
        }
      }
    } else if (historyData is List) {
      final bookings = historyData
          .where((item) => item != null)
          .map((item) => BookingHistoryModel.fromJson(
              Map<String, dynamic>.from(item as Map)))
          .toList();

      return {
        'bookings': bookings,
        'totalPages': 1,
        'currentPage': pageNo,
        'pageSize': pageSize,
      };
    }
    return null;
  }

  List<BookingInterval>? _parseBookingIntervalsResponse(dynamic intervalsData) {
    try {
      if (intervalsData is List) {
        return intervalsData
            .where((item) => item != null)
            .map((item) => BookingInterval.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList();
      } else if (intervalsData is Map) {
        final intervalsMap = Map<String, dynamic>.from(intervalsData);

        // Check if there's a nested 'data' field
        if (intervalsMap.containsKey('data') && intervalsMap['data'] is List) {
          final intervalsList = intervalsMap['data'] as List;
          return intervalsList
              .where((item) => item != null)
              .map((item) => BookingInterval.fromJson(
                  Map<String, dynamic>.from(item as Map)))
              .toList();
        }
      }
    } catch (e) {
      print('Error parsing booking intervals: $e');
    }
    return null;
  }
}
