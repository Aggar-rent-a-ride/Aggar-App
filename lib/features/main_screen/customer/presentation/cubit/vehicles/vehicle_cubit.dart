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
  bool isLoadingMore = false;
  int currentPage = 1;
  List<VehicleModel> _allVehicles = [];
  List<VehicleModel> _popularVehicles = [];
  List<VehicleModel> _mostRentedVehicles = [];

  // Getters to access vehicle lists
  List<VehicleModel> get allVehicles => _allVehicles;
  List<VehicleModel> get popularVehicles => _popularVehicles;
  List<VehicleModel> get mostRentedVehicles => _mostRentedVehicles;

  Future<void> fetchAllVehicles(String accessToken,
      {bool isLoadMore = false}) async {
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        if (!isLoadMore) {
          emit(VehicleLoading());
        } else {
          emit(VehicleLoadingMore(
            vehicles: ListVehicleModel(data: _allVehicles, totalPages: 0),
          ));
        }

        final response = await dioConsumer.get(
          EndPoint.getVehicles,
          queryParameters: {"pageNo": currentPage, "pageSize": 5},
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );

        final vehicles = ListVehicleModel.fromJson(response);

        if (isLoadMore) {
          _allVehicles.addAll(vehicles.data);
        } else {
          _allVehicles = vehicles.data;
        }

        if (_allVehicles.length > 50) {
          _allVehicles.removeRange(0, _allVehicles.length - 50);
        }

        emit(VehicleLoaded(
          vehicles: ListVehicleModel(
            data: _allVehicles,
            totalPages: vehicles.totalPages,
          ),
        ));
        return;
      } catch (error) {
        if (attempt == 3) {
          emit(VehicleError(
              message:
                  'Failed to fetch vehicles after $attempt attempts: $error'));
        }
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      } finally {
        isLoadingMore = false;
      }
    }
  }

  Future<void> fetchPopularVehicles(String accessToken) async {
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        emit(VehicleLoading());

        final response = await dioConsumer.get(
          EndPoint.getPopularVehicles,
          queryParameters: {"pageNo": 1, "pageSize": 5},
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );

        final vehicles = ListVehicleModel.fromJson(response);
        _popularVehicles = vehicles.data;

        emit(VehicleLoaded(
          vehicles: ListVehicleModel(
            data: _popularVehicles,
            totalPages: vehicles.totalPages,
          ),
        ));
        return;
      } catch (error) {
        if (attempt == 3) {
          emit(VehicleError(
              message:
                  'Failed to fetch popular vehicles after $attempt attempts: $error'));
        }
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }
  }

  Future<void> fetchMostRentedVehicles(String accessToken) async {
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        emit(VehicleLoading());

        final response = await dioConsumer.get(
          EndPoint.mostRentedVehicles,
          queryParameters: {"pageNo": 1, "pageSize": 1},
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );

        final vehicles = ListVehicleModel.fromJson(response);
        _mostRentedVehicles = vehicles.data;

        emit(VehicleLoaded(
          vehicles: ListVehicleModel(
            data: _mostRentedVehicles,
            totalPages: vehicles.totalPages,
          ),
        ));
        return;
      } catch (error) {
        if (attempt == 3) {
          emit(VehicleError(
              message:
                  'Failed to fetch most rented vehicles after $attempt attempts: $error'));
        }
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }
  }

  Future<void> toggleFavorite(
      String accessToken, String vehicleId, bool currentValue) async {
    try {
      // Update all vehicle lists
      final updatedAllVehicles = _allVehicles.map((vehicle) {
        if (vehicle.id == vehicleId) {
          return VehicleModel(
            distance: vehicle.distance,
            type: vehicle.type,
            year: vehicle.year,
            rate: vehicle.rate,
            id: vehicle.id,
            model: vehicle.model,
            brand: vehicle.brand,
            transmission: vehicle.transmission,
            pricePerDay: vehicle.pricePerDay,
            mainImagePath: vehicle.mainImagePath,
            isFavourite: !currentValue,
          );
        }
        return vehicle;
      }).toList();

      final updatedPopularVehicles = _popularVehicles.map((vehicle) {
        if (vehicle.id == vehicleId) {
          return VehicleModel(
            distance: vehicle.distance,
            type: vehicle.type,
            year: vehicle.year,
            rate: vehicle.rate,
            id: vehicle.id,
            model: vehicle.model,
            brand: vehicle.brand,
            transmission: vehicle.transmission,
            pricePerDay: vehicle.pricePerDay,
            mainImagePath: vehicle.mainImagePath,
            isFavourite: !currentValue,
          );
        }
        return vehicle;
      }).toList();

      final updatedMostRentedVehicles = _mostRentedVehicles.map((vehicle) {
        if (vehicle.id == vehicleId) {
          return VehicleModel(
            distance: vehicle.distance,
            type: vehicle.type,
            year: vehicle.year,
            rate: vehicle.rate,
            id: vehicle.id,
            model: vehicle.model,
            brand: vehicle.brand,
            transmission: vehicle.transmission,
            pricePerDay: vehicle.pricePerDay,
            mainImagePath: vehicle.mainImagePath,
            isFavourite: !currentValue,
          );
        }
        return vehicle;
      }).toList();

      _allVehicles = updatedAllVehicles;
      _popularVehicles = updatedPopularVehicles;
      _mostRentedVehicles = updatedMostRentedVehicles;

      emit(VehicleLoaded(
        vehicles: ListVehicleModel(
          data: _allVehicles,
          totalPages: state is VehicleLoaded
              ? (state as VehicleLoaded).vehicles.totalPages
              : 0,
        ),
      ));

      await dioConsumer.put(
        EndPoint.putFavourite,
        data: {"vehicleId": vehicleId, "isFavourite": !currentValue},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
    } catch (error) {
      // Revert changes in case of error
      final revertedAllVehicles = _allVehicles.map((vehicle) {
        if (vehicle.id == vehicleId) {
          return VehicleModel(
            distance: vehicle.distance,
            type: vehicle.type,
            year: vehicle.year,
            rate: vehicle.rate,
            id: vehicle.id,
            model: vehicle.model,
            brand: vehicle.brand,
            transmission: vehicle.transmission,
            pricePerDay: vehicle.pricePerDay,
            mainImagePath: vehicle.mainImagePath,
            isFavourite: currentValue,
          );
        }
        return vehicle;
      }).toList();

      final revertedPopularVehicles = _popularVehicles.map((vehicle) {
        if (vehicle.id == vehicleId) {
          return VehicleModel(
            distance: vehicle.distance,
            type: vehicle.type,
            year: vehicle.year,
            rate: vehicle.rate,
            id: vehicle.id,
            model: vehicle.model,
            brand: vehicle.brand,
            transmission: vehicle.transmission,
            pricePerDay: vehicle.pricePerDay,
            mainImagePath: vehicle.mainImagePath,
            isFavourite: currentValue,
          );
        }
        return vehicle;
      }).toList();

      final revertedMostRentedVehicles = _mostRentedVehicles.map((vehicle) {
        if (vehicle.id == vehicleId) {
          return VehicleModel(
            distance: vehicle.distance,
            type: vehicle.type,
            year: vehicle.year,
            rate: vehicle.rate,
            id: vehicle.id,
            model: vehicle.model,
            brand: vehicle.brand,
            transmission: vehicle.transmission,
            pricePerDay: vehicle.pricePerDay,
            mainImagePath: vehicle.mainImagePath,
            isFavourite: currentValue,
          );
        }
        return vehicle;
      }).toList();

      _allVehicles = revertedAllVehicles;
      _popularVehicles = revertedPopularVehicles;
      _mostRentedVehicles = revertedMostRentedVehicles;

      emit(VehicleLoaded(
        vehicles: ListVehicleModel(
          data: _allVehicles,
          totalPages: state is VehicleLoaded
              ? (state as VehicleLoaded).vehicles.totalPages
              : 0,
        ),
      ));

      emit(VehicleError(message: 'Failed to toggle favorite: $error'));
    }
  }

  void loadMoreVehicles(String accessToken) {
    if (isLoadingMore) {
      return;
    }
    if (state is VehicleLoaded) {
      final currentState = state as VehicleLoaded;
      if (currentPage >= (currentState.vehicles.totalPages ?? 1)) {
        return;
      }
    }
    isLoadingMore = true;
    currentPage++;
    fetchAllVehicles(accessToken, isLoadMore: true);
  }
}
