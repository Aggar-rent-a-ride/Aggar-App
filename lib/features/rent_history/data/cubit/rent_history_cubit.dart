import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_state.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

class RentalHistoryCubit extends Cubit<RentalHistoryState> {
  final Dio dio;
  final TokenRefreshCubit tokenRefreshCubit;
  final int pageSize;
  List<RentalHistoryItem> _allRentals = [];
  String? _activeFilter;

  RentalHistoryCubit({
    required this.dio,
    required this.tokenRefreshCubit,
    this.pageSize = 10,
  }) : super(RentalHistoryInitial());

  Future<void> getRentalHistory({int pageNo = 1, bool refresh = false}) async {
    if (refresh) {
      _allRentals = [];
      _activeFilter = null;
      emit(RentalHistoryInitial());
    }

    if (pageNo == 1 || refresh) {
      emit(RentalHistoryLoading());
    } else {
      final currentState = state;
      if (currentState is RentalHistoryLoaded && !currentState.hasMoreData) {
        return;
      }
    }

    try {
      final accessToken = await tokenRefreshCubit.ensureValidToken();

      if (accessToken == null) {
        emit(RentalHistoryError(
            message: 'Authentication failed. Please login again.'));
        return;
      }

      final response = await dio.get(
        EndPoint.rentalHistory,
        queryParameters: {
          'pageNo': pageNo,
          'pageSize': pageSize,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      List<RentalHistoryItem> rentals = [];

      try {
        if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;

          if (responseData.containsKey('data') &&
              responseData['data'] is Map<String, dynamic>) {
            final innerData = responseData['data'] as Map<String, dynamic>;

            if (innerData.containsKey('data') && innerData['data'] is List) {
              final List<dynamic> rentalsList = innerData['data'];

              for (var item in rentalsList) {
                try {
                  rentals.add(RentalHistoryItem.fromJson(item));
                } catch (e) {}
              }
            }
          } else if (responseData.containsKey('data') &&
              responseData['data'] is List) {
            final List<dynamic> rentalsList = responseData['data'];

            for (var item in rentalsList) {
              try {
                rentals.add(RentalHistoryItem.fromJson(item));
              } catch (e) {}
            }
          }
        } else if (response.data is List) {
          final List<dynamic> rentalsList = response.data;
          for (var item in rentalsList) {
            try {
              rentals.add(RentalHistoryItem.fromJson(item));
            } catch (e) {}
          }
        } else {
          throw Exception(
              'Unexpected API response format: ${response.data.runtimeType}');
        }
      } catch (parseError) {
        throw Exception('Failed to parse rental data: $parseError');
      }

      if (refresh || pageNo == 1) {
        _allRentals = rentals;
      } else {
        _allRentals = [..._allRentals, ...rentals];
      }

      // Apply current filter if one is active
      List<RentalHistoryItem> displayedRentals = _allRentals;
      if (_activeFilter != null && _activeFilter != 'all') {
        displayedRentals = _filterRentalsByStatus(_activeFilter!);
      }

      emit(RentalHistoryLoaded(
        rentals: _allRentals,
        displayedRentals: displayedRentals,
        currentPage: pageNo,
        hasMoreData: rentals.length >= pageSize,
        activeFilter: _activeFilter ?? 'all',
      ));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        try {
          // Try to refresh the token and retry the request once
          await tokenRefreshCubit.refreshToken();
          // Retry the request
          return getRentalHistory(pageNo: pageNo, refresh: refresh);
        } catch (refreshError) {
          emit(RentalHistoryError(
              message: 'Session expired. Please login again.'));
        }
      } else {
        emit(RentalHistoryError(message: e.toString()));
      }
    } catch (e) {
      emit(RentalHistoryError(
          message: 'Failed to load rental history: ${e.toString()}'));
    }
  }

  Future<RentalHistoryItem?> getRentalById({required int rentalId}) async {
    try {
      final accessToken = await tokenRefreshCubit.ensureValidToken();

      if (accessToken == null) {
        emit(RentalHistoryError(
            message: 'Authentication failed. Please login again.'));
        return null;
      }

      final response = await dio.get(
        EndPoint.rental,
        queryParameters: {
          'id': rentalId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        try {
          if (response.data is Map<String, dynamic>) {
            final responseData = response.data as Map<String, dynamic>;

            if (responseData.containsKey('data') &&
                responseData['data'] != null) {
              return RentalHistoryItem.fromJson(responseData['data']);
            }
          }
          throw Exception('Invalid response format');
        } catch (parseError) {
          throw Exception('Failed to parse rental data: $parseError');
        }
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        try {
          await tokenRefreshCubit.refreshToken();
          return getRentalById(rentalId: rentalId);
        } catch (refreshError) {
          emit(RentalHistoryError(
              message: 'Session expired. Please login again.'));
          return null;
        }
      } else {
        emit(RentalHistoryError(
            message:
                'Failed to get rental details: ${e.response?.data['message'] ?? e.toString()}'));
        return null;
      }
    } catch (e) {
      emit(RentalHistoryError(
          message: 'Failed to get rental details: ${e.toString()}'));
      return null;
    }
  }

  Future<void> confirmRental({
    required int rentalId,
    required String scannedQrCode,
  }) async {
    try {
      final accessToken = await tokenRefreshCubit.ensureValidToken();

      if (accessToken == null) {
        emit(RentalHistoryError(
            message: 'Authentication failed. Please login again.'));
        return;
      }

      final response = await dio.post(
        EndPoint.confirmRental,
        queryParameters: {
          'rentalId': rentalId,
        },
        data: {
          'scannedQrCode': scannedQrCode,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        await getRentalHistory(pageNo: 1, refresh: true);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        try {
          await tokenRefreshCubit.refreshToken();
          return confirmRental(
              rentalId: rentalId, scannedQrCode: scannedQrCode);
        } catch (refreshError) {
          emit(RentalHistoryError(
              message: 'Session expired. Please login again.'));
        }
      } else {
        emit(RentalHistoryError(
            message:
                'Failed to confirm rental: ${e.response?.data['message'] ?? e.toString()}'));
      }
    } catch (e) {
      emit(RentalHistoryError(
          message: 'Failed to confirm rental: ${e.toString()}'));
    }
  }

  Future<void> refundRental({required int rentalId}) async {
    // Emit loading state
    emit(RentalHistoryRefundLoading());

    try {
      final accessToken = await tokenRefreshCubit.ensureValidToken();

      if (accessToken == null) {
        emit(RentalHistoryRefundError(
            message: 'Authentication failed. Please login again.'));
        return;
      }

      final response = await dio.get(
        EndPoint.refundRental,
        queryParameters: {
          'id': rentalId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Emit success state
        emit(RentalHistoryRefundSuccess(
          message:
              'Refund request submitted successfully.\n Processing time: 3-5 business days.',
        ));

        // Refresh the rental history after successful refund
        await getRentalHistory(pageNo: 1, refresh: true);
      } else {
        emit(RentalHistoryRefundError(
          message: 'Failed to process refund request. Please try again.',
        ));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        try {
          await tokenRefreshCubit.refreshToken();
          return refundRental(rentalId: rentalId);
        } catch (refreshError) {
          emit(RentalHistoryRefundError(
              message: 'Session expired. Please login again.'));
        }
      } else {
        emit(RentalHistoryRefundError(
            message:
                'Failed to refund rental: ${e.response?.data['message'] ?? e.toString()}'));
      }
    } catch (e) {
      emit(RentalHistoryRefundError(
          message: 'Failed to refund rental: ${e.toString()}'));
    }
  }

  void loadMoreRentals() {
    if (state is RentalHistoryLoaded) {
      final currentState = state as RentalHistoryLoaded;
      // Only load more if we're showing all rentals (not filtered)
      if (currentState.hasMoreData && _activeFilter == 'all') {
        getRentalHistory(pageNo: currentState.currentPage + 1);
      }
    }
  }

  void refreshRentalHistory() {
    getRentalHistory(pageNo: 1, refresh: true);
  }

  // New method to handle filtering
  void filterRentals(String filter) {
    _activeFilter = filter;

    if (state is RentalHistoryLoaded) {
      final currentState = state as RentalHistoryLoaded;

      List<RentalHistoryItem> displayedRentals;
      if (filter == 'all') {
        displayedRentals = currentState.rentals;
      } else {
        displayedRentals = _filterRentalsByStatus(filter);
      }

      emit(RentalHistoryLoaded(
        rentals: currentState.rentals,
        displayedRentals: displayedRentals,
        currentPage: currentState.currentPage,
        hasMoreData: currentState.hasMoreData,
        activeFilter: filter,
      ));
    }
  }

  // Helper method to filter rentals by status
  List<RentalHistoryItem> _filterRentalsByStatus(String status) {
    return _allRentals
        .where((rental) =>
            rental.rentalStatus.toLowerCase() == status.toLowerCase())
        .toList();
  }

  List<RentalHistoryItem> getRentalsByStatus(String status) {
    return _allRentals
        .where((rental) =>
            rental.rentalStatus.toLowerCase() == status.toLowerCase())
        .toList();
  }

  RentalHistoryItem? getRentalDetails(int rentalId) {
    try {
      return _allRentals.firstWhere((rental) => rental.id == rentalId);
    } catch (e) {
      return null;
    }
  }

  // Status-specific filter methods - Updated to match actual API status values
  List<RentalHistoryItem> getConfirmedRentals() {
    return getRentalsByStatus('Confirmed');
  }

  List<RentalHistoryItem> getCompletedRentals() {
    return getRentalsByStatus('Completed');
  }

  List<RentalHistoryItem> getInProgressRentals() {
    return getRentalsByStatus('In Progress');
  }

  List<RentalHistoryItem> getNotStartedRentals() {
    return getRentalsByStatus('Not Started');
  }

  List<RentalHistoryItem> getCancelledRentals() {
    return getRentalsByStatus('Cancelled');
  }

  List<RentalHistoryItem> getRefundedRentals() {
    return getRentalsByStatus('Refunded');
  }
}
