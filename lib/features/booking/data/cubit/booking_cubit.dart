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
      // Create FormData instead of JSON
      final formData = FormData.fromMap({
        'VehicleId': vehicleId.toString(),
        'StartDate': startDate.toIso8601String(),
        'EndDate': endDate.toIso8601String(),
      });

      final response = await _makeAuthenticatedRequest(() async => 
        dioConsumer.post(
          EndPoint.createBooking,
          data: formData,
          options: await _getAuthOptions(), // Add authorization header
          isFromData: true,
        )
      );

      // Handle Dio response structure
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
        emit(const BookingCreateError(message: 'Authentication failed. Please login again.'));
      } else {
        emit(BookingCreateError(message: e.toString()));
      }
    }
  }

  Future<void> getBookingById(int bookingId) async {
    emit(BookingGetByIdLoading());

    try {
      final response = await _makeAuthenticatedRequest(() async => 
        dioConsumer.get(
          EndPoint.getBookingById,
          queryParameters: {'id': bookingId},
          options: await _getAuthOptions(),
        )
      );

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
        emit(const BookingGetByIdError(message: 'Authentication failed. Please login again.'));
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

      final response = await _makeAuthenticatedRequest(() async => 
        dioConsumer.get(
          EndPoint.getBookingsByStatus,
          queryParameters: queryParams,
          options: await _getAuthOptions(),
        )
      );

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
        emit(const BookingsGetByStatusError(message: 'Authentication failed. Please login again.'));
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

      final response = await _makeAuthenticatedRequest(() async => 
        dioConsumer.get(
          EndPoint.getBookingsCount,
          queryParameters: queryParams,
          options: await _getAuthOptions(),
        )
      );

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
        emit(const BookingsCountError(message: 'Authentication failed. Please login again.'));
      } else {
        emit(BookingsCountError(message: e.toString()));
      }
    }
  }

  // NEW: Cancel booking functionality
  Future<void> cancelBooking(int bookingId) async {
    emit(BookingCancelLoading());

    try {
      final response = await _makeAuthenticatedRequest(() async => 
        dioConsumer.put(
          EndPoint.cancelBooking, 
          queryParameters: {'id': bookingId},
          options: await _getAuthOptions(),
        )
      );

      final responseData = response as Map<String, dynamic>;
      final statusCode = responseData['statusCode'] ??
          (responseData.containsKey('status') ? responseData['status'] : 200);

      if (statusCode == 200) {
        final message = responseData['message']?.toString() ?? 'Booking canceled successfully';
        emit(BookingCancelSuccess(message: message, bookingId: bookingId));
      } else {
        emit(BookingCancelError(
          message: responseData['message']?.toString() ?? 'Failed to cancel booking',
        ));
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        emit(const BookingCancelError(message: 'Authentication failed. Please login again.'));
      } else {
        emit(BookingCancelError(message: e.toString()));
      }
    }
  }

  /// Helper method to get authorization options
  Future<Options> _getAuthOptions() async {
    final token = await tokenRefreshCubit.getAccessToken();
    print("CURRENT TOKEN: $token"); // Debug log
    
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  /// Helper method to handle API calls with automatic token refresh on 401
  Future<dynamic> _makeAuthenticatedRequest(Future<dynamic> Function() apiCall) async {
    try {
      // Ensure we have a valid token before making the request
      await tokenRefreshCubit.ensureValidToken();
      
      // Make the API call
      return await apiCall();
    } on DioException catch (e) {
      // Handle 401 Unauthorized error
      if (e.response?.statusCode == 401) {
        try {
          // Try to refresh the token
          await tokenRefreshCubit.refreshToken();
          
          // Retry the original request with the new token
          return await apiCall();
        } catch (refreshError) {
          // If token refresh fails, throw the original 401 error
          throw DioException(
            requestOptions: e.requestOptions,
            response: e.response,
            type: DioExceptionType.badResponse,
            error: 'Authentication failed. Please login again.',
          );
        }
      }
      // Re-throw other DioExceptions
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

  void resetState() {
    emit(BookingInitial());
  }
}