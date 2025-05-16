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
  List<VehicleModel> allVehicles = [];

  Future<void> fetchVehicle(String accessToken,
      {bool isLoadMore = false}) async {
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        if (!isLoadMore) {
          emit(VehicleLoading());
        } else {
          emit(VehicleLoadingMore(
              vehicles: ListVehicleModel(data: allVehicles, totalPages: 0)));
        }
        final response = await dioConsumer.get(
          EndPoint.getPopularVehicles,
          queryParameters: {"pageNo": currentPage, "pageSize": 5},
          options: Options(headers: {
            'Authorization': 'Bearer $accessToken',
          }),
        );
        final vehicles = ListVehicleModel.fromJson(response);

        if (isLoadMore) {
          allVehicles.addAll(vehicles.data);
        } else {
          allVehicles = vehicles.data;
        }
        // Cap allVehicles at 50 items
        if (allVehicles.length > 50) {
          allVehicles.removeRange(0, allVehicles.length - 50);
        }
        emit(VehicleLoaded(
          vehicles: ListVehicleModel(
            data: allVehicles,
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
    fetchVehicle(accessToken, isLoadMore: true);
  }
}
