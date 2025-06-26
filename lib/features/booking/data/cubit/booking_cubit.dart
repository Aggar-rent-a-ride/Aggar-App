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

      final response =
          await _makeAuthenticatedRequest(() async => dioConsumer.post(
                EndPoint.createBooking,
                data: formData,
                options: await _getAuthOptions(), // Add authorization header
                isFromData: true,
              ));

      final responseData = response as Map<String, dynamic>;
      final statusCode = responseData['statusCode'] ??
          (response.containsKey('status') ? response['status'] : 200);

      if (statusCode == 201 || statusCode == 200) {
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
      if (e is DioException && e.response?.statusCode == 401) {
        emit(const BookingCreateError(
            message: 'Authentication failed. Please login again.'));
      } else {
        emit(BookingCreateError(message: e.toString()));
      }
    }
  }

  Future<void> getBookingById(int bookingId) async {
    emit(BookingGetByIdLoading());

    try {
      final response =
          await _makeAuthenticatedRequest(() async => dioConsumer.get(
                EndPoint.getBookingById,
                queryParameters: {'id': bookingId},
                options: await _getAuthOptions(),
              ));

      final responseData = response as Map<String, dynamic>;
      final statusCode = responseData['statusCode'] ??
          (responseData.containsKey('status') ? responseData['status'] : 200);

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
      if (e is DioException && e.response?.statusCode == 401) {
        emit(const BookingGetByIdError(
            message: 'Authentication failed. Please login again.'));
      } else {
        emit(BookingGetByIdError(message: e.toString()));
      }
    }
  }

  Future<void> getBookingsByStatus({
    BookingStatus? status,
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    emit(BookingsGetByStatusLoading());

    try {
      final queryParams = <String, dynamic>{
        'pageNo': pageNo,
        'pageSize': pageSize,
      };

      if (status != null) {
        queryParams['status'] = status.value;
      }

      final response =
          await _makeAuthenticatedRequest(() async => dioConsumer.get(
                EndPoint.getBookingsByStatus,
                queryParameters: queryParams,
                options: await _getAuthOptions(),
              ));

      final responseData = response as Map<String, dynamic>;
      final statusCode = responseData['statusCode'] ??
          (responseData.containsKey('status') ? responseData['status'] : 200);

      if (statusCode == 200) {
        final bookingsData = responseData['data'] ?? responseData;

        if (bookingsData is List) {
          final bookings = bookingsData
              .where((item) => item != null)
              .map((item) =>
                  BookingModel.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList();

          emit(BookingsGetByStatusSuccess(
            bookings: bookings,
            totalPages: 1,
            currentPage: pageNo,
            pageSize: pageSize,
          ));
        } else if (bookingsData is Map) {
          final bookingsMap = Map<String, dynamic>.from(bookingsData);

          if (bookingsMap.containsKey('data')) {
            final bookingsResponse = BookingsResponse.fromJson(bookingsMap);

            emit(BookingsGetByStatusSuccess(
              bookings: bookingsResponse.data,
              totalPages: bookingsResponse.totalPages,
              currentPage: bookingsResponse.pageNumber,
              pageSize: bookingsResponse.pageSize,
            ));
          } else {
            emit(const BookingsGetByStatusError(
              message: 'Invalid response format',
            ));
          }
        } else {
          emit(const BookingsGetByStatusError(
            message: 'Invalid response format',
          ));
        }
      } else {
        emit(BookingsGetByStatusError(
          message:
              responseData['message']?.toString() ?? 'Failed to get bookings',
        ));
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        emit(const BookingsGetByStatusError(
            message: 'Authentication failed. Please login again.'));
      } else {
        emit(BookingsGetByStatusError(message: e.toString()));
      }
    }
  }

  Future<void> getBookingsCount({BookingStatus? status}) async {
    emit(BookingsCountLoading());

    try {
      final queryParams = <String, dynamic>{};
      if (status != null) {
        queryParams['status'] = status.value;
      }

      final response =
          await _makeAuthenticatedRequest(() async => dioConsumer.get(
                EndPoint.getBookingsCount,
                queryParameters: queryParams,
                options: await _getAuthOptions(),
              ));

      final responseData = response as Map<String, dynamic>;
      final statusCode = responseData['statusCode'] ??
          (responseData.containsKey('status') ? responseData['status'] : 200);

      if (statusCode == 200) {
        final count = responseData['data'] ?? responseData['count'] ?? 0;
        emit(BookingsCountSuccess(count: count as int, status: status));
      } else {
        emit(BookingsCountError(
          message: responseData['message']?.toString() ??
              'Failed to get bookings count',
        ));
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        emit(const BookingsCountError(
            message: 'Authentication failed. Please login again.'));
      } else {
        emit(BookingsCountError(message: e.toString()));
      }
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

      final response =
          await _makeAuthenticatedRequest(() async => dioConsumer.get(
                EndPoint
                    .getRenterPendingBookings, 
                queryParameters: queryParams,
                options: await _getAuthOptions(),
              ));

      final responseData = response as Map<String, dynamic>;
      final statusCode = responseData['statusCode'] ??
          (responseData.containsKey('status') ? responseData['status'] : 200);

      if (statusCode == 200) {
        final bookingsData = responseData['data'] ?? responseData;

        if (bookingsData is Map) {
          final bookingsMap = Map<String, dynamic>.from(bookingsData);

          if (bookingsMap.containsKey('data')) {
            final bookingsResponse = BookingsResponse.fromJson(bookingsMap);

            emit(RenterPendingBookingsSuccess(
              bookings: bookingsResponse.data,
              totalPages: bookingsResponse.totalPages,
              currentPage: bookingsResponse.pageNumber,
              pageSize: bookingsResponse.pageSize,
            ));
          } else {
            emit(const RenterPendingBookingsError(
              message: 'Invalid response format',
            ));
          }
        } else if (bookingsData is List) {
          final bookings = bookingsData
              .where((item) => item != null)
              .map((item) =>
                  BookingModel.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList();

          emit(RenterPendingBookingsSuccess(
            bookings: bookings,
            totalPages: 1,
            currentPage: pageNo,
            pageSize: pageSize,
          ));
        } else {
          emit(const RenterPendingBookingsError(
            message: 'Invalid response format',
          ));
        }
      } else {
        emit(RenterPendingBookingsError(
          message: responseData['message']?.toString() ??
              'Failed to get renter pending bookings',
        ));
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        emit(const RenterPendingBookingsError(
            message: 'Authentication failed. Please login again.'));
      } else {
        emit(RenterPendingBookingsError(message: e.toString()));
      }
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    emit(const BookingCancelLoading());

    try {
      final response =
          await _makeAuthenticatedRequest(() async => dioConsumer.put(
                EndPoint.cancelBooking,
                queryParameters: {'id': bookingId},
                options: await _getAuthOptions(),
              ));

      final responseData = response as Map<String, dynamic>;
      final statusCode = responseData['statusCode'] ??
          (responseData.containsKey('status') ? responseData['status'] : 200);

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
      if (e is DioException && e.response?.statusCode == 401) {
        emit(const BookingCancelError(
            message: 'Authentication failed. Please login again.'));
      } else {
        emit(BookingCancelError(message: e.toString()));
      }
    }
  }

  Future<void> respondToBooking({
    required int bookingId,
    required bool isAccepted,
  }) async {
    emit(const BookingResponseLoading());

    try {
      final response =
          await _makeAuthenticatedRequest(() async => dioConsumer.put(
                EndPoint.bookingResponse, // You'll need to add this to your EndPoint class
                queryParameters: {
                  'id': bookingId,
                  'isAccepted': isAccepted.toString(),
                },
                options: await _getAuthOptions(),
              ));

      final responseData = response as Map<String, dynamic>;
      final statusCode = responseData['statusCode'] ??
          (responseData.containsKey('status') ? responseData['status'] : 200);

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
        emit(BookingResponseError(
          message: responseData['message']?.toString() ?? 
              'Failed to respond to booking',
        ));
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        emit(const BookingResponseError(
            message: 'Authentication failed. Please login again.'));
      } else {
        emit(BookingResponseError(message: e.toString()));
      }
    }
  }

  Future<void> acceptBooking(int bookingId) async {
    await respondToBooking(bookingId: bookingId, isAccepted: true);
  }

  Future<void> rejectBooking(int bookingId) async {
    await respondToBooking(bookingId: bookingId, isAccepted: false);
  }

  Future<Options> _getAuthOptions() async {
    final token = await tokenRefreshCubit.getAccessToken();
    print("CURRENT TOKEN: $token"); // Debug log

    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<dynamic> _makeAuthenticatedRequest(
      Future<dynamic> Function() apiCall) async {
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

  Future<void> refreshBookings({
    BookingStatus? status,
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    await getBookingsByStatus(
      status: status,
      pageNo: pageNo,
      pageSize: pageSize,
    );
  }

  Future<void> refreshRenterPendingBookings({
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    await getRenterPendingBookings(
      pageNo: pageNo,
      pageSize: pageSize,
    );
  }

  void resetState() {
    emit(BookingInitial());
  }
}
