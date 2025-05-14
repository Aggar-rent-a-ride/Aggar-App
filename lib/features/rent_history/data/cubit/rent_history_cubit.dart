import 'package:aggar/core/api/api_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_state.dart';
import 'package:aggar/features/rent_history/data/models/rent_history_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

class RentalHistoryCubit extends Cubit<RentalHistoryState> {
  final ApiConsumer apiConsumer;
  final int pageSize;
  List<RentalHistoryItem> _allRentals = [];

  RentalHistoryCubit({
    required this.apiConsumer,
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
      final result = await apiConsumer.get(
        EndPoint.rentalHistory,
        queryParameters: {
          'pageNo': pageNo,
          'pageSize': pageSize,
        },
      );

      final List<dynamic> rentalsList = result as List<dynamic>;
      final rentals =
          rentalsList.map((item) => RentalHistoryItem.fromJson(item)).toList();

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
      emit(RentalHistoryError(message: e.toString()));
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
}