import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/list_vehicle_model.dart';
import '../../../data/model/vehicle_model.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit() : super(VehicleInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  bool isLoadingMoreAll = false;
  bool isLoadingMorePopular = false;
  bool isLoadingMoreMostRented = false;

  int currentPageAll = 1;
  int currentPagePopular = 1;
  int currentPageMostRented = 1;

  int totalPagesAll = 1;
  int totalPagesPopular = 1;
  int totalPagesMostRented = 1;

  List<VehicleModel> _allVehicles = [];
  List<VehicleModel> _popularVehicles = [];
  List<VehicleModel> _mostRentedVehicles = [];

  List<VehicleModel> get allVehicles => List.unmodifiable(_allVehicles);
  List<VehicleModel> get popularVehicles => List.unmodifiable(_popularVehicles);
  List<VehicleModel> get mostRentedVehicles =>
      List.unmodifiable(_mostRentedVehicles);

  void resetAllVehicles() {
    _allVehicles.clear();
    currentPageAll = 1;
    totalPagesAll = 1;
    isLoadingMoreAll = false;
  }

  void resetPopularVehicles() {
    _popularVehicles.clear();
    currentPagePopular = 1;
    totalPagesPopular = 1;
    isLoadingMorePopular = false;
  }

  void resetMostRentedVehicles() {
    _mostRentedVehicles.clear();
    currentPageMostRented = 1;
    totalPagesMostRented = 1;
    isLoadingMoreMostRented = false;
  }

  Future<void> fetchAllVehicles(String accessToken,
      {bool isLoadMore = false, int? page}) async {
    final targetPage = page ?? (isLoadMore ? currentPageAll + 1 : 1);
    if (isLoadMore && isLoadingMoreAll) return;
    if (isLoadMore && targetPage > totalPagesAll) return;

    try {
      if (!isLoadMore) {
        emit(VehicleLoading());
        resetAllVehicles();
      } else {
        isLoadingMoreAll = true;
        emit(VehicleLoadingMore(
          vehicles:
              ListVehicleModel(data: _allVehicles, totalPages: totalPagesAll),
        ));
      }

      final response = await dioConsumer.get(
        EndPoint.getVehicles,
        queryParameters: {"pageNo": targetPage, "pageSize": 8},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      final vehicles = ListVehicleModel.fromJson(response);

      if (isLoadMore) {
        _allVehicles.addAll(vehicles.data);
      } else {
        _allVehicles = List.from(vehicles.data);
      }

      if (_allVehicles.length > 50) {
        _allVehicles.removeRange(0, _allVehicles.length - 50);
      }

      currentPageAll = targetPage;
      totalPagesAll = vehicles.totalPages ?? 1;

      emit(VehicleLoaded(
        vehicles: ListVehicleModel(
          data: _allVehicles,
          totalPages: totalPagesAll,
        ),
      ));
      return;
    } finally {
      if (isLoadMore) {
        isLoadingMoreAll = false;
      }
    }
  }

  Future<void> fetchPopularVehicles(String accessToken,
      {bool isLoadMore = false, int? page}) async {
    final targetPage = page ?? (isLoadMore ? currentPagePopular + 1 : 1);

    if (isLoadMore && isLoadingMorePopular) return;
    if (isLoadMore && targetPage > totalPagesPopular) return;
    try {
      if (!isLoadMore) {
        emit(VehicleLoading());
        resetPopularVehicles();
      } else {
        isLoadingMorePopular = true;
        emit(VehicleLoadingMore(
          vehicles: ListVehicleModel(
              data: _popularVehicles, totalPages: totalPagesPopular),
        ));
      }

      final response = await dioConsumer.get(
        EndPoint.getPopularVehicles,
        queryParameters: {"pageNo": targetPage, "pageSize": 8},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      final vehicles = ListVehicleModel.fromJson(response);

      if (isLoadMore) {
        _popularVehicles.addAll(vehicles.data);
      } else {
        _popularVehicles = List.from(vehicles.data);
      }
      if (_popularVehicles.length > 50) {
        _popularVehicles.removeRange(0, _popularVehicles.length - 50);
      }
      currentPagePopular = targetPage;
      totalPagesPopular = vehicles.totalPages ?? 1;

      emit(VehicleLoaded(
        vehicles: ListVehicleModel(
          data: _popularVehicles,
          totalPages: totalPagesPopular,
        ),
      ));
      return;
    } finally {
      if (isLoadMore) {
        isLoadingMorePopular = false;
      }
    }
  }

  Future<void> fetchMostRentedVehicles(String accessToken,
      {bool isLoadMore = false, int? page}) async {
    final targetPage = page ?? (isLoadMore ? currentPageMostRented + 1 : 1);
    if (isLoadMore && isLoadingMoreMostRented) return;
    if (isLoadMore && targetPage > totalPagesMostRented) return;
    try {
      if (!isLoadMore) {
        emit(VehicleLoading());
        resetMostRentedVehicles();
      } else {
        isLoadingMoreMostRented = true;
        emit(VehicleLoadingMore(
          vehicles: ListVehicleModel(
              data: _mostRentedVehicles, totalPages: totalPagesMostRented),
        ));
      }

      final response = await dioConsumer.get(
        EndPoint.mostRentedVehicles,
        queryParameters: {"pageNo": targetPage, "pageSize": 8},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      final vehicles = ListVehicleModel.fromJson(response);

      if (isLoadMore) {
        _mostRentedVehicles.addAll(vehicles.data);
      } else {
        _mostRentedVehicles = List.from(vehicles.data);
      }
      if (_mostRentedVehicles.length > 50) {
        _mostRentedVehicles.removeRange(0, _mostRentedVehicles.length - 50);
      }
      currentPageMostRented = targetPage;
      totalPagesMostRented = vehicles.totalPages ?? 1;

      emit(VehicleLoaded(
        vehicles: ListVehicleModel(
          data: _mostRentedVehicles,
          totalPages: totalPagesMostRented,
        ),
      ));
      return;
    } finally {
      if (isLoadMore) {
        isLoadingMoreMostRented = false;
      }
    }
  }

  void loadMoreVehicles(String accessToken) {
    if (isLoadingMoreAll || currentPageAll >= totalPagesAll) return;
    fetchAllVehicles(accessToken, isLoadMore: true);
  }

  void loadMorePopularVehicles(String accessToken) {
    if (isLoadingMorePopular || currentPagePopular >= totalPagesPopular) return;
    fetchPopularVehicles(accessToken, isLoadMore: true);
  }

  void loadMoreMostRentedVehicles(String accessToken) {
    if (isLoadingMoreMostRented ||
        currentPageMostRented >= totalPagesMostRented) return;
    fetchMostRentedVehicles(accessToken, isLoadMore: true);
  }

  bool get canLoadMoreAll =>
      currentPageAll < totalPagesAll && !isLoadingMoreAll;
  bool get canLoadMorePopular =>
      currentPagePopular < totalPagesPopular && !isLoadingMorePopular;
  bool get canLoadMoreMostRented =>
      currentPageMostRented < totalPagesMostRented && !isLoadingMoreMostRented;
}
