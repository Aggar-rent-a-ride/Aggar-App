import 'dart:convert';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/features/main_screen/customer/data/model/vehicle_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as dio;
import '../../../../../../core/api/end_points.dart';
import '../../../data/model/list_vehicle_model.dart';
import 'vehicle_type_state.dart';

class VehicleTypeCubit extends Cubit<VehicleTypeState> {
  VehicleTypeCubit() : super(VehicleTypeInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  final List<String> vehicleTypes = [];
  final List<int> vehicleTypeIds = [];
  final List<String> vehicleTypeSlogenPaths = [];
  bool isLoadingMoreAll = false;
  int currentPageAll = 1;
  int totalPagesAll = 1;
  List<VehicleModel> _allVehicles = [];
  List<VehicleModel> get allVehicles => List.unmodifiable(_allVehicles);

  void resetAllVehicles() {
    _allVehicles.clear();
    currentPageAll = 1;
    totalPagesAll = 1;
    isLoadingMoreAll = false;
  }

  void loadMoreVehicles(String accessToken, int type) async {
    if (isLoadingMoreAll || currentPageAll >= totalPagesAll) return;
    fetchVehicleType(accessToken, type, isLoadMore: true);
  }

  Future<void> fetchVehicleTypes(String accessToken) async {
    try {
      emit(VehicleTypeLoading());
      final response = await dio.get(
        Uri.parse(EndPoint.vehicleType),
        headers: {
          'Authorization': "Bearer $accessToken",
        },
      );
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      if (decodedJson['statusCode'] == 200) {
        vehicleTypes.clear();
        vehicleTypeIds.clear();
        vehicleTypeSlogenPaths.clear();
        for (var item in decodedJson['data']) {
          vehicleTypes.add(item[ApiKey.vehicleTypeName]);
          vehicleTypeIds.add(item[ApiKey.vehicleTypeId]);
          if (item[ApiKey.vehicleTypeSlogen] != null) {
            vehicleTypeSlogenPaths.add(item[ApiKey.vehicleTypeSlogen]);
          } else {
            vehicleTypeSlogenPaths.add("null");
          }
        }
      }
      emit(VehicleLoadedType());
    } catch (error) {
      emit(VehicleTypeError(message: error.toString()));
    }
  }

  Future<void> fetchVehicleType(String accessToken, int type,
      {bool isLoadMore = false, int? page}) async {
    final targetPage = page ?? (isLoadMore ? currentPageAll + 1 : 1);
    if (isLoadMore && isLoadingMoreAll) return;
    if (isLoadMore && targetPage > totalPagesAll) return;
    try {
      if (!isLoadMore) {
        emit(VehicleTypeLoading());
        resetAllVehicles();
      } else {
        isLoadingMoreAll = true;
        emit(VehicleTypeLoadingMore(
          vehicles:
              ListVehicleModel(data: _allVehicles, totalPages: totalPagesAll),
        ));
      }

      final response = await dioConsumer.get(
        EndPoint.getVehicles,
        queryParameters: {"pageNo": targetPage, "pageSize": 10, "typeId": type},
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

      emit(VehicleLoadedType(
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
}
