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

  RentalHistoryCubit({
    required this.dio,
    required this.tokenRefreshCubit,
    this.pageSize = 10,
  }) : super(RentalHistoryInitial());

  Future<void> getRentalHistory({int pageNo = 1, bool refresh = false}) async {
    if (refresh) {
      _allRentals = [];
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
      final accessToken = await tokenRefreshCubit.getAccessToken();

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
      emit(RentalHistoryLoaded(
        rentals: _allRentals,
        currentPage: pageNo,
        hasMoreData: rentals.length >= pageSize,
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

  void loadMoreRentals() {
    if (state is RentalHistoryLoaded) {
      final currentState = state as RentalHistoryLoaded;
      if (currentState.hasMoreData) {
        getRentalHistory(pageNo: currentState.currentPage + 1);
      }
    }
  }

  void refreshRentalHistory() {
    getRentalHistory(pageNo: 1, refresh: true);
  }

  List<RentalHistoryItem> getRentalsByStatus(String status) {
    if (state is RentalHistoryLoaded) {
      final currentState = state as RentalHistoryLoaded;
      return currentState.rentals
          .where((rental) => rental.rentalStatus == status)
          .toList();
    }
    return [];
  }

  RentalHistoryItem? getRentalDetails(int rentalId) {
    if (state is RentalHistoryLoaded) {
      final currentState = state as RentalHistoryLoaded;
      try {
        return currentState.rentals
            .firstWhere((rental) => rental.id == rentalId);
      } catch (e) {
        return null;
      }
    }
    return null;
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
}
