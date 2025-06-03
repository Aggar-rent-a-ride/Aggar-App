import 'package:aggar/features/booking/data/cubit/booking_state.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';

class BookingCubit extends Cubit<BookingState> {
  final DioConsumer dioConsumer;

  BookingCubit({required this.dioConsumer}) : super(BookingInitial());

  Future<void> createBooking({
    required int vehicleId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    emit(BookingCreateLoading());

    try {
      final bookingRequest = BookingRequest(
        vehicleId: vehicleId,
        startDate: startDate,
        endDate: endDate,
      );

      final response = await dioConsumer.post(
        EndPoint.createBooking,
        data: bookingRequest.toJson(),
        isFromData: true,
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
      emit(BookingCreateError(message: e.toString()));
    }
  }

  Future<void> getBookingById(int bookingId) async {
    emit(BookingGetByIdLoading());

    try {
      final response = await dioConsumer.get(
        EndPoint.getBookingById,
        queryParameters: {'id': bookingId},
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
      emit(BookingGetByIdError(message: e.toString()));
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

      final response = await dioConsumer.get(
        EndPoint.getBookingsByStatus,
        queryParameters: queryParams,
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
      emit(BookingsGetByStatusError(message: e.toString()));
    }
  }

  Future<void> getBookingsCount({BookingStatus? status}) async {
    emit(BookingsCountLoading());

    try {
      final queryParams = <String, dynamic>{};
      if (status != null) {
        queryParams['status'] = status.value;
      }

      final response = await dioConsumer.get(
        EndPoint.getBookingsCount,
        queryParameters: queryParams,
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
      emit(BookingsCountError(message: e.toString()));
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
